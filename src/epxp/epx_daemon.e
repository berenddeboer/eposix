indexing

	description:

		"Daemon"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2011, Berend de Boer"
	license: "MIT License (see LICENSE)"


deferred class

	EPX_DAEMON


inherit

	POSIX_DAEMON


feature {NONE} -- Initialisation

	make is
		do
			setup_signals
			parse_arguments
			if foreground_mode_flag.was_found then
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


feature -- Argument parsing

	application_description: STRING is
			-- Daemon description printed when help is requested
		deferred
		end


	foreground_mode_flag: AP_FLAG

	set_arguments (a_parser: AP_PARSER) is
			-- Set application arguments.
		require
			not_void: a_parser /= Void
		do
			create foreground_mode_flag.make ('f', "foreground")
			foreground_mode_flag.set_description ("Run in foreground, not as a daemon.")
			a_parser.options.force_last (foreground_mode_flag)
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
