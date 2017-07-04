note

	description:

		"A daemon that is managed and monitored by systemd. It does not fork. It supports the systemd software watchdog (setting RuntimeWatchdogSec=)"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2017, Berend de Boer"
	license: "MIT License (see LICENSE)"


deferred class

	EPX_SYSTEMD_DAEMON


inherit

	EPX_CURRENT_PROCESS


inherit

	{NONE} STDC_CONSTANTS


feature {NONE} -- Initialisation

	make
		do
			setup_signals
			execute
		end


feature -- Access

	terminate_signal: EPX_KILL_SIGNAL_HANDLER
			-- Signal handler

	watchdog_microseconds: INTEGER
		local
			env: EPX_ENV_VAR
		once
			create env.make ("WATCHDOG_USEC")
			if env.is_set and then env.value.is_integer then
				Result := env.value.to_integer
			end
		end


feature {NONE} -- Execution

	execute
		deferred
		end

	watchdog_alive
			-- Notify systemd we're still alive.
		do
			if watchdog_microseconds > 0 then
				sd_notify_watchdog
			end
		end


feature {NONE} -- Signal handling

	setup_signals
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

	application_description: STRING
			-- Daemon description printed when help is requested
		deferred
		end

	set_arguments (a_parser: AP_PARSER)
			-- Set application arguments.
		require
			parser_not_void: a_parser /= Void
		do
		ensure
			options_valid: a_parser.valid_options
		end

	parse_arguments
			-- Create parser, set arguments, and parse arguments.
			-- To validate specific arguments, override this, and exit
			-- the application if some argument has not been given.
		local
			parser: AP_PARSER
		do
			create parser.make
			parser.set_application_description (application_description)
			set_arguments (parser)
			parser.parse_arguments
		end


feature {NONE} -- systemd notification

	sd_notify_ready
		do
			do_sd_notify ("READY=1")
		end

	sd_notify_watchdog
		do
			do_sd_notify ("WATCHDOG=1")
		end

	sd_notify_stopping
		do
			do_sd_notify ("STOPPING=1")
		end

	do_sd_notify (s: STRING)
		local
			p: POINTER
			r: INTEGER
		do
			p := sh.string_to_pointer (s)
			r := sd_notify (0, p)
			sh.unfreeze_all
		end

	sd_notify (unset_environment: INTEGER; p: POINTER): INTEGER
		external "C | <systemd/sd-daemon.h>"
		end


invariant

	terminate_signal_not_void: terminate_signal /= Void


end
