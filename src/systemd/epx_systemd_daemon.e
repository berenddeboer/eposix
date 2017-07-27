note

	description:

		"A daemon that is managed and monitored by systemd. It does not fork. It supports the systemd software watchdog (setting RuntimeWatchdogSec=). You can either use Type=simple or Type=notify. For the latter, make sure to call `sd_notify_ready' after initialisation has finished."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2017, Berend de Boer"
	license: "MIT License (see LICENSE)"


deferred class

	EPX_SYSTEMD_DAEMON


inherit

	EPX_CURRENT_PROCESS


feature {NONE} -- Initialisation

	make
		do
			parse_arguments
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

	argument_parser: AP_PARSER

	set_arguments
			-- Set application arguments.
		require
			parser_not_void: attached argument_parser
		do
		ensure
			options_valid: argument_parser.valid_options
		end

	parse_arguments
			-- Create parser, set arguments, and parse arguments.  To
			-- validate specific arguments, override
			-- this feature, and exit the application if some
			-- argument has not been given.
		do
			create argument_parser.make
			argument_parser.set_application_description (application_description)
			set_arguments
			argument_parser.parse_arguments
		ensure
			parser_attached: attached argument_parser
		end


feature {NONE} -- systemd notification

	sd_notify_ready
			-- Call this when daemon has finished initialisation.
			-- Only useful when "Type=notify".
		do
			do_sd_notify ("READY=1")
		end

	sd_notify_watchdog
			-- If the RuntimeWatchdogSec setting has been enabled, make
			-- sure to call in less 50% of the time specified.
		do
			do_sd_notify ("WATCHDOG=1")
		end

	sd_notify_stopping
			-- Call this when the daemon starts to stop.
			-- Only useful when "Type=notify".
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
