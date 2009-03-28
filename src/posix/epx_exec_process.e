indexing

	description: "Portable child processes for POSIX."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #10 $"


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


feature {NONE} -- i/o capturing, only visible at POSIX_EXEC_PROCESS level

	stdin: POSIX_TEXT_FILE

	stdout: POSIX_TEXT_FILE

	stderr: POSIX_TEXT_FILE


feature -- i/o capturing

	fd_stdin: POSIX_FILE_DESCRIPTOR

	fd_stdout: POSIX_FILE_DESCRIPTOR

	fd_stderr: POSIX_FILE_DESCRIPTOR


feature -- Execution

	execute is
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
					if capture_output then
						create fd_stdout.attach_to_fd (STDOUT_FILENO, False)
					end
					if capture_error then
						create fd_stderr.attach_to_fd (STDERR_FILENO, False)
					end

					-- Close a captured standard file and attach it to the pipe.
					if capture_input then
						fd_stdin.make_as_duplicate (input_pipe.fdin)
						check
							fd_stdin.value = STDIN_FILENO
						end
					end
					if capture_output then
						fd_stdout.make_as_duplicate (output_pipe.fdout)
						check
							fd_stdout.value = STDOUT_FILENO
						end
					end
					if capture_error then
						fd_stderr.make_as_duplicate (error_pipe.fdout)
						check
							fd_stderr.value = STDERR_FILENO
						end
					end

					-- Close left over file descriptors.
					if capture_input then
						input_pipe.close
					end
					if capture_output then
						output_pipe.close
					end
					if capture_error then
						error_pipe.close
					end

					do_execute

				else -- This is parent

					-- Make the captured i/o available as the stdout
					-- of this object.
					-- File descriptor will remain owner, to be portable at
					-- the ABSTRACT_EXEC_PROCESS level were we expect that
					-- the file descriptors are owners.
					if capture_input then
						fd_stdin := input_pipe.fdout
						fd_stdin.inherit_error_handling (Current)
						create stdin.make_from_file_descriptor (fd_stdin, once "w")
						input_pipe.fdin.close
						fd_stdin.become_owner
						stdin.unown
					end
					if capture_output then
						fd_stdout := output_pipe.fdin
						fd_stdout.inherit_error_handling (Current)
						create stdout.make_from_file_descriptor (fd_stdout, once "r")
						output_pipe.fdout.close
						fd_stdout.become_owner
						stdout.unown
					end
					if capture_error then
						fd_stderr := error_pipe.fdin
						fd_stderr.inherit_error_handling (Current)
						create stderr.make_from_file_descriptor (fd_stderr, once "r")
						error_pipe.fdout.close
						fd_stderr.become_owner
						stderr.unown
					end
				end
			end
		rescue
			if in_child then
				child_stderr.puts (once "in child %N")
				handle_execute_failure
			end
		end


feature -- Actions that parent may execute

	wait_for (suspend: BOOLEAN) is
			-- Wait for this process to terminate. If `suspend' then we
			-- wait until the information about this process is available,
			-- else we return immediately.
			-- If `suspend' is False, check `is_terminated' to see
			-- if this child is really terminated.
		do
			-- Close stdin if it is not closed. This will signal an
			-- end-of-input to the child process.
			if suspend then
				if stdin /= Void and then stdin.is_open then
					stdin.detach
				end
				if fd_stdin /= Void and then fd_stdin.is_open then
					fd_stdin.close
				end
			end
			precursor (suspend)
			if is_terminated then
				-- avoid file handle leaks. We have to be careful because
				-- the streams can be closed too. And because the file
				-- descriptor also is an owner, we should avoid closing an
				-- already closed descriptor.
				if stdin /= Void and then stdin.is_open then
					stdin.detach
				end
				if fd_stdin /= Void and then fd_stdin.is_open then
					fd_stdin.close
				end
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
					(stdin = Void or else not stdin.is_open) and then
-- 					(stdout = Void or else not stdout.is_open) and then
-- 					(stderr = Void or else not stderr.is_open) and then
					(fd_stdin = Void or else not fd_stdin.is_open)
-- 					and then
-- 					(fd_stdout = Void or else not fd_stdout.is_open) and then
-- 					(fd_stderr = Void or else not fd_stderr.is_open)
		end


feature {NONE}

	do_execute is
			-- Actually execute `program_name'.
		local
			argv: ARRAY [STRING]
			cargv: ARRAY [POINTER]
			i, j: INTEGER
			r: INTEGER
		do
			create argv.make (0, arguments.count+1)
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
			r := posix_execvp (
				sh.string_to_pointer (program_name),
				ah.pointer_array_to_pointer (cargv))
			ah.unfreeze_all
			sh.unfreeze_all

			-- We should never return here,
			-- but if we do, r = -1
			-- And we're already forked, so we're really in a separate process
			-- There's no way to signal the parent (except through SIGCHILD).
			child_stderr.puts ("r = " + r.out + "%N")
			handle_execute_failure
		end

	handle_execute_failure is
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
				fd_stdin.close
			end
			if capture_output then
				fd_stdout.close
			end
			if capture_error then
				fd_stderr.close
			end
			-- a failed child should not flush parent files
			minimal_exit (EXIT_FAILURE)
		rescue
			minimal_exit (EXIT_FAILURE)
		end


invariant

	streams_are_not_owner:
		(stdin /= Void implies not stdin.is_owner) and then
		(stdout /= Void implies not stdout.is_owner) and then
		(stderr /= Void implies not stderr.is_owner)

end
