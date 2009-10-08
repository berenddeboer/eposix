indexing

	description: "Windows child processes created by call to CreateProcess."

	how_to: "http://support.microsoft.com/default.aspx?scid=http://support.microsoft.com:80/support/kb/articles/q190/3/51.asp&NoWebContent=1&NoWebContent=1"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #11 $"


class

	EPX_EXEC_PROCESS


inherit

	ABSTRACT_EXEC_PROCESS
		undefine
			raise_posix_error
		end

	WINDOWS_PROCESS

	WINDOWS_BASE


create

	make,
	make_capture_input,
	make_capture_output,
	make_capture_io,
	make_capture_all,
	make_from_command_line


feature -- Access

	pid: INTEGER is
		do
			Result := procinfo.pid
		end


feature -- Status

	is_pid_valid: BOOLEAN is
			-- Does Current refer to an actual child process?
		do
			Result := running and then procinfo /= Void
		end


feature -- Execution

	execute is
			-- Executes `program_name'.
			-- Don't forget to `wait' for this process to terminate.
		local
			si: WINDOWS_STARTUPINFO
			command_line: STRING
			sa: WINDOWS_SECURITY_ATTRIBUTES
		do
			-- reset some state
			error_pipe := Void
			input_pipe := Void
			output_pipe := Void

			command_line := program_name + all_arguments
			create si.make
			if capture_input or else capture_output or else capture_error then
				si.set_dwFlags (STARTF_USESHOWWINDOW + STARTF_USESTDHANDLES)
			else
				si.set_dwFlags (STARTF_USESHOWWINDOW)
			end
			create sa.make
			sa.set_inherit_handle (True)
			if capture_input then
				create {WINDOWS_PIPE} input_pipe.make_inheritable_write
				si.set_hStdInput (input_pipe.fdout.value)
			else
				si.set_hStdInput (posix_getstdhandle (STD_INPUT_HANDLE))
			end
			if capture_output then
				create {WINDOWS_PIPE} output_pipe.make_inheritable_read
				si.set_hStdOutput (output_pipe.fdin.value)
			else
				si.set_hStdOutput (posix_getstdhandle (STD_OUTPUT_HANDLE))
			end
			if capture_error then
				create {WINDOWS_PIPE} error_pipe.make_inheritable_read
				si.set_hStdError (error_pipe.fdin.value)
			else
				si.set_hStdError (posix_getstdhandle (STD_ERROR_HANDLE))
			end
			si.set_wShowWindow (SW_HIDE)
			create procinfo.make
			safe_win_call (
				posix_createprocess (
					default_pointer,
					sh.string_to_pointer (command_line),
					default_pointer,
					default_pointer,
					True,
-- 					False,
					CREATE_NEW_PROCESS_GROUP,
					default_pointer,
					sh.string_to_pointer (initial_directory),
					si.ptr,
					procinfo.ptr))
			sh.unfreeze_all
			running := True
			-- close any unnecessary (??) handles.
			safe_win_call (posix_closehandle (procinfo.thread_handle))

			-- child has handles now, close our part of the handle
			if capture_input then
				fd_stdin := input_pipe.fdin
				input_pipe.fdout.close
			else
				fd_stdin := Void
			end
			if capture_output then
				fd_stdout := output_pipe.fdout
				output_pipe.fdin.close
			else
				fd_stdout := Void
			end
			if capture_error then
				fd_stderr := error_pipe.fdout
				error_pipe.fdin.close
			else
				fd_stderr := Void
			end
		end

	terminate is
			-- This is definitively not a graceful termination.
		do
			safe_win_call (posix_terminateprocess (procinfo.process_handle, Terminate_exit_code))
		end

	wait_for (suspend: BOOLEAN) is
			-- Wait for this process to terminate. If `suspend' then we
			-- wait until the information about this process is available.
			-- If suspend is False, check the running property to see
			-- if this child is really terminated.
		local
			dw: INTEGER
		do
			if suspend then
				-- Close stdin which should cause an end-of-input at the
				-- child process.
				if input_pipe /= Void then
					input_pipe.close
					input_pipe := Void
				end
				-- Must close other pipes as well, else if they have
				-- unread data, the other process will wait and not exit,
				-- until it is read.
				if output_pipe /= Void then
					output_pipe.close
					output_pipe := Void
				end
				if error_pipe /= Void then
					error_pipe.close
					error_pipe := Void
				end
				dw := posix_waitforsingleobject (procinfo.process_handle, INFINITE)
				if dw = WAIT_FAILED then
					raise_windows_error
				else
					running := False
				end
			else
				dw := posix_waitforsingleobject (procinfo.process_handle, 0)
				if dw = WAIT_FAILED then
					raise_windows_error
				elseif dw = WAIT_OBJECT_0 then
					running := False
				end
			end
			if is_terminated then
				safe_win_call (posix_getexitcodeprocess (procinfo.process_handle, $exit_code))
				safe_win_call (posix_closehandle (procinfo.process_handle))
				if input_pipe /= Void then
					input_pipe.close
					input_pipe := Void
				end
				if output_pipe /= Void then
					output_pipe.close
					output_pipe := Void
				end
				if error_pipe /= Void then
					error_pipe.close
					error_pipe := Void
				end
			end
		end


feature -- Termination info

	exit_code: INTEGER
			-- Value returned by external process upon exit.


feature {NONE} -- Implementation

	all_arguments: STRING is
			-- Return arguments as a single string.
			-- First character returned is a space.
		local
			i: INTEGER
		do
			create Result.make (256)
			from
				i := arguments.lower
			until
				i > arguments.upper
			loop
				Result.append_character (' ')
				Result.append_string (arguments.item (i))
				i := i + 1
			end
		ensure
			all_arguments_not_void: Result /= Void
			all_arguments_copied: arguments.is_empty = Result.is_empty
			first_character_is_space: not arguments.is_empty implies Result.item (1) = ' '
		end


feature {NONE} -- Implementation

	procinfo: WINDOWS_PROCESS_INFORMATION

	initial_directory: STRING is
		do
			Result := Void
		end

	input_pipe,
	output_pipe,
	error_pipe: EPX_PIPE
			-- Pipes that communicate with child process

end
