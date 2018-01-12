note

	description: "Portable child processes for POSIX."

	author: "Berend de Boer"


class

	EPX_EXEC_PROCESS


inherit

	ABSTRACT_EXEC_PROCESS
		undefine
			has_exit_code
		redefine
			fd_stdin,
			fd_stdout,
			fd_stderr
		end

	POSIX_FORK_ROOT
		rename -- these are only applicable if you're the child
			stdin as child_stdin,
			stdout as child_stdout,
			stderr as child_stderr,
			fd_stdin as child_fd_stin,
			fd_stdout as child_fd_stdout,
			fd_stderr as child_fd_sterr,
			pid as fork_parent_pid,
			child_pid as pid,
			is_child_pid_valid as is_pid_valid,
			kill as kill_fork_parent,
			kill_child as kill,
			terminate_child as terminate
		redefine
			wait_for
		end


create

	make,
	make_capture_input,
	make_capture_output,
	make_capture_io,
	make_capture_all,
	make_from_command_line


feature -- Access

	new_uid: INTEGER
			-- If set to a different value then 0, change `uid' before
			-- executing `program_name';
			-- Failure to do so is silently ignored, and you need to run
			-- as root to be able to do this.

	new_gid: INTEGER
			-- If set to a different value then 0, change `gid' before
			-- executing `program_name';
			-- Failure to do so is silently ignored, and you need to run
			-- as root to be able to do this.


feature -- Change

	set_new_uid (a_uid: INTEGER)
			-- Set `new_uid'.
			-- To be executed program will run with `new_uid' privileges. It
			-- is strongly recommended to use `set_new_gid' to change the
			-- group to the user's primary group as well.
		require
			valid_uid: a_uid > 0
		do
			new_uid := a_uid
		ensure
			definition: new_uid = a_uid
		end

	set_new_gid (a_gid: INTEGER)
			-- Set `new_gid'.
			-- To be executed program will run with `new_gid' privileges.
		require
			valid_uid: a_gid > 0
		do
			new_gid := a_gid
		ensure
			definition: new_gid = a_gid
		end


feature {NONE} -- i/o capturing, only visible at POSIX_EXEC_PROCESS level

	stdin: detachable POSIX_TEXT_FILE

	stdout: detachable POSIX_TEXT_FILE

	stderr: detachable POSIX_TEXT_FILE


feature -- i/o capturing

	fd_stdin: detachable POSIX_FILE_DESCRIPTOR

	fd_stdout: detachable POSIX_FILE_DESCRIPTOR

	fd_stderr: detachable POSIX_FILE_DESCRIPTOR


feature -- Execution

	execute
			-- Execute `program_name' with arguments `arguments'. After
			-- execution, at some point in time, you have to `wait' or
			-- `wait_for' for this process to terminate.
			-- Current setting for error handling is retained for the
			-- captured i/o on the parent side, but not for the child's
			-- side (but maybe should??).
		local
			input_pipe,
			output_pipe,
			error_pipe: POSIX_PIPE
			in_child: BOOLEAN
			dev_null: POSIX_FILE_DESCRIPTOR
			fs: EPX_FILE_SYSTEM
		do
			if capture_input then
				create input_pipe.make
			else
				stdin := Void
				fd_stdin := Void
			end
			if capture_output then
				create output_pipe.make
			else
				stdout := Void
				fd_stdout := Void
			end
			if capture_error then
				create error_pipe.make
			else
				stderr := Void
				fd_stderr := Void
			end

			my_pid := posix_fork
			if my_pid = -1 then
				raise_posix_error
			else
				running := True
				in_child := my_pid = 0
				if in_child  then

					-- This child process has now current process characteristics.
					-- Open the standard io files if needed.
					if capture_input then
						create fd_stdin.attach_to_fd (STDIN_FILENO, False)
					end
					create fd_stdout.attach_to_fd (STDOUT_FILENO, False)
					if capture_error then
						create fd_stderr.attach_to_fd (STDERR_FILENO, False)
					end

					-- Close a captured standard file and attach it to the pipe.
					if capture_input and then attached fd_stdin as my_fd_stdin and then attached input_pipe as my_input_pipe then
						my_fd_stdin.make_as_duplicate (input_pipe.fdin)
							check
								my_fd_stdin.value = STDIN_FILENO
							end
					end
					if capture_output and then attached fd_stdout as my_fd_stdout and then attached output_pipe as my_output_pipe then
						my_fd_stdout.make_as_duplicate (my_output_pipe.fdout)
							check
								my_fd_stdout.value = STDOUT_FILENO
							end
					elseif close_output and then attached fd_stdout as my_fd_stdout then
						create dev_null.open_write (once "/dev/null")
						my_fd_stdout.make_as_duplicate (dev_null)
						fd_stdout := Void
					end
					if capture_error and then attached fd_stderr as my_fd_stderr and then attached error_pipe as my_error_pipe then
						my_fd_stderr.make_as_duplicate (my_error_pipe.fdout)
						check
							my_fd_stderr.value = STDERR_FILENO
						end
					elseif close_error and then attached fd_stderr as my_fd_stderr then
						create dev_null.open_write (once "/dev/null")
						my_fd_stderr.make_as_duplicate (dev_null)
						fd_stderr := Void
					end

					-- Close left over file descriptors.
					if capture_input and then attached input_pipe as my_input_pipe then
						my_input_pipe.close
					end
					if capture_output and then attached output_pipe as my_output_pipe then
						my_output_pipe.close
					end
					if capture_error and then attached error_pipe as my_error_pipe then
						my_error_pipe.close
					end

					if attached working_directory as wd then
						create fs
						fs.change_directory (wd)
					end

					do_execute

				else -- This is parent

					-- Make the captured i/o available as the stdout
					-- of this object.
					-- File descriptor will remain owner, to be portable at
					-- the ABSTRACT_EXEC_PROCESS level were we expect that
					-- the file descriptors are owners.
					if capture_input and then attached input_pipe as my_input_pipe then
						if attached my_input_pipe.fdout as my_fd_stdin then
							fd_stdin := my_fd_stdin
							my_fd_stdin.inherit_error_handling (Current)
							create stdin.make_from_file_descriptor (my_fd_stdin, once "w")
							my_input_pipe.fdin.close
							my_fd_stdin.become_owner
						end
						if attached stdin as my_stdin then
							my_stdin.unown
						end
					end
					if capture_output and then attached output_pipe as my_output_pipe then
						if attached my_output_pipe.fdin as my_fd_stdout then
							fd_stdout := my_fd_stdout
							my_fd_stdout.inherit_error_handling (Current)
							create stdout.make_from_file_descriptor (my_fd_stdout, once "r")
							my_output_pipe.fdout.close
							my_fd_stdout.become_owner
						end
						if attached stdout as my_stdout then
							my_stdout.unown
						end
					end
					if capture_error and then attached error_pipe as my_error_pipe then
						if attached my_error_pipe.fdin as my_fd_stderr then
							fd_stderr := my_fd_stderr
							my_fd_stderr.inherit_error_handling (Current)
							create stderr.make_from_file_descriptor (my_fd_stderr, once "r")
							my_error_pipe.fdout.close
							my_fd_stderr.become_owner
						end
						if attached stderr as my_stderr then
							my_stderr.unown
						end
					end
				end
			end
		rescue
			if in_child then
				child_stderr.puts (once "Exception after forking into child %N")
				handle_execute_failure
			end
		end


feature -- Actions that parent may execute

	wait_for (suspend: BOOLEAN)
			-- Wait for this process to terminate. If `suspend' then we
			-- wait until the information about this process is available,
			-- else we return immediately.
			-- If `suspend' is False, check `is_terminated' to see
			-- if this child is really terminated.
			-- If `is_terminated', you can check `exit_code' for example.
		do
			-- Close stdin if it is not closed. This will signal an
			-- end-of-input to the child process.
			if suspend then
				if attached stdin as my_stdin and then my_stdin.is_open then
					my_stdin.detach
				end
				close_fd_stdin
			end
			precursor (suspend)
			if is_terminated then
				-- avoid file handle leaks. We have to be careful because
				-- the streams can be closed too. And because the file
				-- descriptor also is an owner, we should avoid closing an
				-- already closed descriptor.
				if attached stdin as my_stdin and then my_stdin.is_open then
					my_stdin.detach
				end
				close_fd_stdin
-- 				if stdout /= Void and then stdout.is_open then
-- 					stdout.detach
-- 				end
-- 				if fd_stdout /= Void and then fd_stdout.is_open then
-- 					fd_stdout.close
-- 				end
-- 				if stderr /= Void and then stderr.is_open then
-- 					stderr.detach
-- 				end
-- 				if fd_stderr /= Void and then fd_stderr.is_open then
-- 					fd_stderr.close
-- 				end
			end
		ensure then
			terminated_implies_closed:
				is_terminated implies
					(not attached stdin as my_stdin or else not my_stdin.is_open) and then
-- 					(stdout = Void or else not stdout.is_open) and then
-- 					(stderr = Void or else not stderr.is_open) and then
					(not attached fd_stdin as my_fd_stdin or else not my_fd_stdin.is_open)
-- 					and then
-- 					(fd_stdout = Void or else not fd_stdout.is_open) and then
-- 					(fd_stderr = Void or else not fd_stderr.is_open)
		end


feature {NONE}

	do_execute
			-- Actually execute `program_name'.
		local
			argv: ARRAY [STRING]
			cargv: ARRAY [POINTER]
			i, j: INTEGER
			r: INTEGER
			user: POSIX_USER
			env: SUS_ENV_VAR
		do
			create argv.make_filled ("", 0, arguments.count)
			argv.put (program_name, 0)
			from
				i := arguments.lower
				j := 1
			until
				i > arguments.upper
			loop
				argv.put (arguments.item(i), j)
				i := i + 1
				j := j + 1
			end
			cargv := ah.string_array_to_pointer_array (argv)
			if new_uid > 0 then
				create user.make_from_uid (new_uid)
			end
			if new_gid > 0 then
				r := posix_setgid (new_gid)
			end
			if new_uid > 0 and then attached user as my_user then
				r := posix_setuid (new_uid)
				create env.make ("USER")
				env.set_value (my_user.name)
				create env.make ("LOGNAME")
				env.set_value (my_user.name)
				create env.make ("HOME")
				env.set_value (my_user.home_directory)
				-- What about MAIL ?
			end
			r := posix_execvp (
				sh.string_to_pointer (program_name),
				ah.pointer_array_to_pointer (cargv))
			--ah.unfreeze_all
			--sh.unfreeze_all

			-- We should never return here,
			-- but if we do, r = -1
			-- And we're already forked, so we're really in a separate process
			-- There's no way to signal the parent (except through SIGCHILD).
			child_stderr.puts ("r = " + r.out + "%N")
			handle_execute_failure
		end

	handle_execute_failure
			-- Attempt to clean up and make a graceful exit.
		do
			-- not sure if creating stuff is a good idea here
			-- perhaps should be done earlier?
			-- Anyway, I want to write something to stderr
			-- Format of error message is from perl5
			child_stderr.puts (once "Can't exec %"")
			child_stderr.puts (program_name)
			child_stderr.puts (once "%": ")
			child_stderr.puts (errno.message)
			child_stderr.puts (once ".%N")
			if capture_input then
				close_fd_stdin
			end
			if capture_output and then attached fd_stdout as my_fd_stdout then
				my_fd_stdout.close
			end
			if capture_error and then attached fd_stderr as my_fd_stderr then
				my_fd_stderr.close
			end
			-- a failed child should not flush parent files
			minimal_exit (EXIT_FAILURE)
		rescue
			minimal_exit (EXIT_FAILURE)
		end

	close_fd_stdin
		do
			if attached fd_stdin as my_fd_stdin and then my_fd_stdin.is_open then
				my_fd_stdin.close
			end
		ensure
			closed: attached fd_stdin as my_fd_stdin implies not my_fd_stdin.is_open
		end


invariant

	streams_are_not_owner:
		(attached stdin as a_stdin implies not a_stdin.is_owner) and then
		(attached stdout as a_stdout implies not a_stdout.is_owner) and then
		(attached stderr as a_stderr implies not a_stderr.is_owner)

end
