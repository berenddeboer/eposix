indexing

	description: "Class that covers POSIX current process related routines."
	usage: "Just inherit from this class."
	notes: "Most of the features of this class are available only if%
	%you really are a POSIX_CURRENT_PROCESS, they cannot be applied to%
	%an instance of this class, this to protect against unintended effects."

	library: "eposix"
	author: "Berend de Boer"


class

	POSIX_CURRENT_PROCESS


inherit

	EPX_CURRENT_PROCESS
		redefine
			stdin,
			stdout,
			stderr
		end

	POSIX_PROCESS

	PAPI_TYPES
		export
			{NONE} all
		end


feature -- my standard input/output/error

	stdin: POSIX_TEXT_FILE is
		once
			create Result.attach_to_stream (stream_stdin, "r")
		end

	stdout: POSIX_TEXT_FILE is
		once
			create Result.attach_to_stream (stream_stdout, "w")
		end

	stderr: POSIX_TEXT_FILE is
		once
			create Result.attach_to_stream (stream_stderr, "w")
		end


feature -- signal this process

	kill (a_signal_code: INTEGER) is
			-- Send signal `signal_code' to current process.
		require
			valid_signal: a_signal_code >= 0
		do
			safe_call (posix_kill (pid, a_signal_code))
		end


feature {NONE} -- Various access

	getlogin: STRING is
			-- Name of the user logged in on the controlling terminal of
			-- the process, or an empty string if this information cannot
			-- be determined.
		obsolete "2004-12-10: avoid this routine for security-related purposes, use `login_name' instead"
		do
			Result := sh.pointer_to_string (posix_getlogin)
		ensure
			login_name_not_void: Result /= Void
		end

	parent_pid: INTEGER is
			-- Parent process id
		do
			Result := posix_getppid
		end

	frozen getppid: INTEGER is
		obsolete "2008-11-03: please use `parent_pid'"
		do
			Result := parent_pid
		end

	login_name: STRING is
			-- Name of effective user of this process
		obsolete	"2005-11-12: Use effective_user_name instead"
		do
			Result := effective_user_name
		end


feature {NONE} -- ways to exit a program

	minimal_exit (a_status: INTEGER) is
			-- terminate this process with exit code `a_status'.
			-- `_exit' does not call any exit handlers registered with
			-- STDC_EXIT_SWITCH.install
		do
			posix__exit (a_status)
		end


feature {NONE} -- Owner/group queries

	real_user: POSIX_USER is
			-- Real user of this process
		do
			create Result.make_from_uid (effective_user_id)
		ensure
			real_user_not_void: Result /= Void
		end

	is_in_group (a_gid: INTEGER): BOOLEAN is
			-- Is this process in group `a_gid'?
			-- `a_gid' is either a primary or supplementary group.
		require
			valid_gid: a_gid >= 0
			-- sizeof(gid_t) = sizeof(EIF_INTEGER) ...
		local
			num_entries: INTEGER
			has_entries: BOOLEAN
			group_list: STDC_BUFFER
			i: INTEGER
		do
			Result := a_gid = effective_group_id
			if not Result then
				num_entries := posix_getgroups (0, default_pointer)
				if num_entries = -1 then
					raise_posix_error
				end
				has_entries := num_entries > 0
				if has_entries then
					create group_list.allocate (num_entries * posix_gid_t_size)
					safe_call ( posix_getgroups (num_entries, group_list.ptr))
					from
						i := 0
					until
						Result or else i = num_entries
					loop
						Result := posix_group_item (group_list.ptr, i) = a_gid
						i := i + 1
					end
				else
					Result := False
				end
			end
		end


feature {NONE} -- owner/group queries, unix style

	getegid, effective_group_id: INTEGER is
			-- effective group id
		do
			Result := posix_getegid
		end

	geteuid, effective_user_id: INTEGER is
			-- Effective user id
		do
			Result := posix_geteuid
		end

	getgid, gid, real_group_id: INTEGER is
			-- real group id
		do
			Result := posix_getgid
		end

	getpgrp, process_group_id: INTEGER is
			-- process group id
		do
			Result := posix_getpgrp
		end

	getuid, uid, real_user_id: INTEGER is
			-- real user id
		do
			Result := posix_getuid
		end


feature {NONE} -- Security related commands

	restore_group_id is
			-- Sets group id back to the real or saved value.
		do
			safe_call (posix_setgid (real_group_id))
		end

	restore_user_id is
			-- Sets user id back to the real or saved value.
		do
			safe_call (posix_setuid (real_user_id))
		end

	set_group_id (new_gid: INTEGER) is
			-- Set group id to `new_gid`.
		do
			safe_call (posix_setgid (new_gid))
		end

	set_user_id (new_uid: INTEGER) is
			-- Set user id to `new_uid`.
		do
			safe_call (posix_setuid (new_uid))
		end


feature {NONE}  -- various actions

	alarm (seconds: INTEGER) is
			-- Schedules an alarm to arrive as signal in `seconds' seconds
		local
			remaining: INTEGER
		do
			remaining := posix_alarm (seconds)
		end

	cancel_alarm is
			-- cancel an outstanding alarm, if any
		local
			remaining: INTEGER
		do
			remaining := posix_alarm (0)
		end

	last_child_pid: INTEGER
			-- pid of last forked (exec'd child)

	fork (root: POSIX_FORK_ROOT) is
			-- Fork this process, parent continues normally, child
			-- continues at root.execute. Child's pid is availabe in
			-- `last_child_pid'. If `root' isn't the current process,
			-- it's `pid' is set to `last_child_pid'.
		require
			valid_root: root /= Void
		local
			in_child: BOOLEAN
		do
			last_child_pid := posix_fork
			if last_child_pid = -1 then
				raise_posix_error
			else
				in_child := last_child_pid = 0
				if in_child  then
					root.start
				else
					if root /= Current then
						root.set_pid (last_child_pid)
					end
				end
			end
		ensure
			child_started:
				raise_exception_on_error implies
					(root = Current or else not root.is_terminated)
		rescue
			if in_child then
				-- make sure child does not, I repeat, not return...
				minimal_exit (EXIT_FAILURE)
			end
		end


feature {NONE} -- signal related routines

	ignore_child_stop_signal is
			-- Do not generate SIGCHLD when children stop
		local
			signal: POSIX_SIGNAL
		do
			create signal.make (SIGCHLD)
			signal.set_child_stop (False)
			signal.set_default_action
			signal.apply
		end

	pause is
			-- Wait for signal.
			-- Only works if you have installed you're own signal handler!
		require
			signal_handler_installed: -- a user signal handler is installed
		local
			r: INTEGER
		do
			r := posix_pause
		end


feature {NONE} -- child process related routines

	waited_child_pid: INTEGER
			-- id of child that `wait' waited for

	wait is
			-- Suspend execution until status information of one of its
			-- terminated children is available, or until delivery of a
			-- signal whose action is either to execute a signal-catching
			-- function or to terminate the process.
			-- POSIX_CHILD_PROCESS.wait_for as the recommended manner
			-- to wait for child processes, but if you fork yourself,
			-- use this function.
		do
			waited_child_pid := posix_wait (default_pointer)
			if waited_child_pid = -1 then
				raise_posix_error
			end
		end


feature -- POSIX locale specifics

	set_native_messages is
			-- Select native language as the language in which messages
			-- are displayed.
		do
			set_locale (LC_MESSAGES, "")
		end


end
