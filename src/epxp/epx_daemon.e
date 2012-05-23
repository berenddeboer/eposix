indexing

	description:

		"Daemon that enhances POSIX_DAEMON with common options"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2011-2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


deferred class

	EPX_DAEMON


inherit

	POSIX_DAEMON

	EPX_FILE_SYSTEM
		export
			{NONE} all
		end

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end


feature {NONE} -- Initialisation

	make is
		do
			parse_arguments
			if not is_writable (pid_file_name) then
				stderr.put_line ("Cannot create or write to " + pid_file_name)
				exit_with_failure
			end
			setup_signals
			if foreground_mode_flag.was_found then
				write_pid
				execute
			else
				detach
			end
		end


feature -- Access

	terminate_signal: EPX_KILL_SIGNAL_HANDLER
			-- Signal handler


feature {NONE} -- Signal handling

	setup_signals is
			-- Bind to SIGINT (Ctrl+C) and SIGTERM (kill signal) so
			-- daemon can be gracefully terminated.
		require
			not_initialised: terminate_signal = Void
		local
			my_signal: EPX_SIGNAL
		do
			create terminate_signal
			create my_signal.make (SIGINT)
			my_signal.set_handler (terminate_signal)
			my_signal.apply
			create my_signal.make (SIGTERM)
			my_signal.set_handler (terminate_signal)
			my_signal.apply
		ensure
			terminate_signal_not_void: terminate_signal /= Void
		end


feature -- PID writing

	pid_file_name: STRING is
		require
			pid_file_name_flag_not_void: pid_file_name_flag /= Void
		once
			if pid_file_name_flag.was_found then
				Result := pid_file_name_flag.parameter
			else
				Result := default_pid_file_name
			end
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	write_pid is
			-- Write `pid' to `pid_file_name'.
		do
			string_to_file (pid.out, pid_file_name)
		end


feature -- Argument parsing

	application_description: STRING is
			-- Daemon description printed when help is requested
		deferred
		end

	foreground_mode_flag: AP_FLAG

	pid_file_name_flag: AP_STRING_OPTION

	default_pid_file_name: STRING
			-- Default file where pid will be written to
		local
			path: EPX_PATH
		once
			create path.make_from_string (Arguments.program_name)
			path.parse (Void)
			Result := "/var/run/" + path.basename + ".pid"
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	set_arguments (a_parser: AP_PARSER) is
			-- Set application arguments.
		require
			parser_not_void: a_parser /= Void
		do
			create foreground_mode_flag.make ('f', "foreground")
			foreground_mode_flag.set_description ("Run in foreground, not as a daemon.")
			a_parser.options.force_last (foreground_mode_flag)
			create pid_file_name_flag.make_with_long_form ("pid-file")
			pid_file_name_flag.set_description ("File to write pid to. Default is " + default_pid_file_name)
			a_parser.options.force_last (pid_file_name_flag)
		ensure
			options_valid: a_parser.valid_options
		end

	parse_arguments is
			-- Create parser, set arguments, and parse arguments.
		local
			parser: AP_PARSER
		do
			create parser.make
			parser.set_application_description (application_description)
			set_arguments (parser)
			parser.parse_arguments
		end


invariant

	terminate_signal_not_void: terminate_signal /= Void

end
