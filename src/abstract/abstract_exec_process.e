indexing

	description: "Abstraction for child processes that make stdin/stdout %
	%available to their parents."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #11 $"


deferred class

	ABSTRACT_EXEC_PROCESS


inherit

	ABSTRACT_CHILD_PROCESS
		redefine
			wait_for
		end


feature {NONE} -- Initialization

	make (a_program: STRING; a_arguments: ARRAY[STRING]) is
		require
			program_name_not_empty: a_program /= Void and then not a_program.is_empty
			all_arguments_not_void: not has_void_argument (a_arguments)
		do
			create program_name.make_from_string (a_program)
			set_arguments (a_arguments)
		end

	make_capture_input (a_program: STRING; a_arguments: ARRAY[STRING]) is
		require
			program_name_not_empty: a_program /= Void and then not a_program.is_empty
			all_arguments_not_void: not has_void_argument (a_arguments)
		do
			make (a_program, a_arguments)
			set_capture_input (True)
		ensure
			input_will_becaptured: capture_input
		end

	make_capture_output (a_program: STRING; a_arguments: ARRAY[STRING]) is
		require
			program_name_not_empty: a_program /= Void and then not a_program.is_empty
			all_arguments_not_void: not has_void_argument (a_arguments)
		do
			make (a_program, a_arguments)
			set_capture_output (True)
		ensure
			output_will_becaptured: capture_output
		end

	make_capture_io (a_program: STRING; a_arguments: ARRAY[STRING]) is
			-- Why not use three directional i/o, because you're getting
			-- yourself in great, great trouble anyway.
			-- A bit of advice: call stdin.close before starting to call
			-- stdout.read_string. But: your pipe might not have a large
			-- enough buffer, so you write to the process stdin and get
			-- blocked, because the process must empty its stdin
			-- first. The process will do that, but next write to
			-- stdout. If the stdout buffer is full, the process will
			-- block. Now we have a nice dead-lock. Happy coding.
		require
			program_name_not_empty: a_program /= Void and then not a_program.is_empty
			all_arguments_not_void: not has_void_argument (a_arguments)
		do
			make (a_program, a_arguments)
			set_capture_output (True)
			set_capture_input (True)
		ensure
			input_will_becaptured: capture_input
			output_will_becaptured: capture_output
		end

	make_capture_all (a_program: STRING; a_arguments: ARRAY[STRING]) is
			-- Three directional i/o is a great way to get yourself in trouble.
		require
			program_name_not_empty: a_program /= Void and then not a_program.is_empty
			all_arguments_not_void: not has_void_argument (a_arguments)
		do
			make (a_program, a_arguments)
			set_capture_output (True)
			set_capture_input (True)
			set_capture_error (True)
		ensure
			input_will_becaptured: capture_input
			output_will_becaptured: capture_output
			error_will_becaptured: capture_error
		end

	make_from_command_line (a_command_line: STRING) is
			-- Initialize something like "/usr/sbin/sendmail -i -t".
			-- Assume `a_command_line' is space separated. The first
			-- argument is the program name, the others are
			-- arguments. You can escape a space by prefixing it with a slash.
		require
			command_line_not_empty: a_command_line /= Void and then not a_command_line.is_empty
			no_null_in_input: not a_command_line.has ('%U')
		local
			ar: ARRAY [STRING]
			s: STRING
			args: ARRAY [STRING]
			i, j: INTEGER
		do
			-- First replace the quoted spaces by %U as this cannot
			-- appear in the input.
			s := a_command_line.twin
			from
				i := 1
			variant
				s.count - (i - 1)
			until
				i = s.count
			loop
				if
					s.item (i) = '\' and then
					s.item (i + 1) = ' '
				then
					s.replace_substring (once_null, i, i+1)
				end
				i := i + 1
			end

			-- Next replace multiple spaces by a single space
			from
				i := 1
			variant
				s.count - (i - 1)
			until
				i = s.count
			loop
				if
					s.item (i) = ' ' and then
					s.item (i + 1) = ' '
				then
					s.remove (i)
				end
				i := i + 1
			end

			-- Now split it on the spaces
			ar := sh.split_on (s, ' ')
			if ar.count > 1 then
				args := ar.subarray (ar.lower + 1, ar.upper)
				-- Process arguments, revert '%U' to ' '
				from
					i := args.lower
				variant
					args.count - (i - args.lower)
				until
					i > args.upper
				loop
					s := args.item (i)
					from
						j := 1
					variant
						s.count - (j - 1)
					until
						j > s.count
					loop
						if s.item (j) = '%U' then
							s.put (' ', j)
						end
						j := j + 1
					end
					i := i + 1
				end
			end

			-- Done, now have path to program and arguments
			make (ar.item (ar.lower), args)
		end


feature -- (re)set arguments

	has_void_argument (a_arguments: ARRAY[STRING]): BOOLEAN is
			-- Is one of the items in `a_arguments' Void?
		local
			i: INTEGER
		do
			if a_arguments /= Void then
				from
					i := a_arguments.lower
				until
					Result or else
					i >= a_arguments.upper
				loop
					Result := a_arguments.item (i) = Void
					i := i + 1
				end
			end
		end

	set_arguments (a_arguments: ARRAY[STRING]) is
		require
			all_arguments_not_void: not has_void_argument (a_arguments)
		do
			if a_arguments = Void then
				create arguments.make(0, -1)
			else
				arguments := a_arguments
			end
		end


feature -- i/o capturing

	capture_input: BOOLEAN
			-- is input captured on execute?

	capture_output: BOOLEAN
			-- is output captured on execute?

	capture_error: BOOLEAN
			-- is error captured on execute?

	set_capture_input (on: BOOLEAN) is
		do
			capture_input := on
		ensure
			definition: capture_input = on
		end

	set_capture_output (on: BOOLEAN) is
		do
			capture_output := on
		ensure
			definition: capture_output = on
		end

	set_capture_error (on: BOOLEAN) is
		do
			capture_error := on
		ensure
			definition: capture_error = on
		end

	fd_stdin: ABSTRACT_FILE_DESCRIPTOR
			-- Input read by process

	fd_stdout: ABSTRACT_FILE_DESCRIPTOR
			-- Output emitted by process

	fd_stderr: ABSTRACT_FILE_DESCRIPTOR
			-- Error output from process


feature -- Execute

	execute is
			-- Execute `program_name' with arguments `arguments'. After
			-- execution, at some point in time, you have to `wait' or
			-- `wait_for' for this process to terminate.
		require
			not_already_started: is_terminated
		deferred
		end


feature -- Actions that parent may execute

	wait_for (suspend: BOOLEAN) is
			-- Wait for this process to terminate. If `suspend' then we
			-- wait until the information about this process is available,
			-- else we return immediately.
			-- If suspend is False, check `is_terminated' to see
			-- if this child is really terminated.
		deferred
		ensure then
			stdin_closed: is_terminated implies fd_stdin = Void or else not fd_stdin.is_open
			--stdout_closed: is_terminated implies fd_stdout = Void or else not fd_stdout.is_open
			--stderr_closed: is_terminated implies fd_stderr = Void or else not fd_stderr.is_open
		end


feature -- Access

	program_name: STDC_PATH
			-- Program to execute

	arguments: ARRAY [STRING]
			-- Arguments to pass to `program_name'


feature {NONE} -- Implementation

	once_null: STRING is "%U"


invariant

	program_name_not_empty: program_name /= Void and then not program_name.is_empty
	arguments_not_void: arguments /= Void
	all_arguments_not_void: not has_void_argument (arguments)

	descriptors_are_owners:
		(fd_stdin /= Void and then fd_stdin.is_open implies fd_stdin.is_owner) and then
		(fd_stdout /= Void and then fd_stdout.is_open implies fd_stdout.is_owner) and then
		(fd_stderr /= Void and then fd_stderr.is_open implies fd_stderr.is_owner)

end
