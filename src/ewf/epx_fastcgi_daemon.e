note

	description:

		"External FastCGI daemon"

	todo: "handle SIGUSR1"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


deferred class

	EPX_FASTCGI_DAEMON [G -> WSF_EXECUTION create make end]


inherit

	EPX_WATCHDOG_DAEMON
		redefine
			set_arguments,
			setup_signals
		end

	WSF_DEFAULT_SERVICE [G]


inherit {NONE}

	EPX_WGI_FASTCGI_CONNECTOR_OPTIONS


feature -- Execution

	execute
			-- Call `service_execute' which will loop until a STOP signal
			-- has been received.
		do
			set_service_option ("terminate_signal", terminate_signal)
			if port_option.was_found then
				set_service_option ("port", port_option.parameter)
			else
				set_service_option ("port", default_port)
			end
			if bind_option.was_found then
				set_service_option ("bind", bind_option.parameter)
			end
			if foreground_mode_flag.was_found then
				set_service_option ("no_fork", True)
			end
			launch (service_options)
		end

	execute_service_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- I'm using this method to handle the method not allowed
			-- response in the case that the given uri does not have a
			-- corresponding http method to handle it.
		local
			h : HTTP_HEADER
			l_description : STRING
			l_api_doc : STRING
		do
			res.set_status_code ({HTTP_STATUS_CODE}.method_not_allowed)
			if req.content_length_value > 0 then
				req.input.read_string (req.content_length_value.as_integer_32)
			end
			create h.make
			h.put_content_type_text_plain
			l_api_doc := "%NPlease check the API%N"
			l_description := req.request_method + " " + req.request_uri + " is not supported" + "%N" + l_api_doc
			h.put_current_date
			res.put_header_text (h.string)
			res.put_string (l_description)
		end


feature -- Signal handling

	child_signal: EPX_SIGNALLED_SIGNAL_HANDLER

	setup_signals
		local
			my_signal: EPX_SIGNAL
		do
			precursor
			create my_signal.make (SIGPIPE)
			my_signal.set_ignore_action
			my_signal.apply
			-- We don't really need to use this signal. Setting ourselves
			-- up to receive the signal is enough to interrupt listening
			-- to the socket, so we simply check for terminated children
			-- every time we are interrupted, and no socket is returned.
			posix_enable_custom_signal_handler_1 (SIGCHLD)
		end


feature -- Defaults

	default_port: INTEGER
		do
			-- No default
		end


feature -- Argument parsing

	port_option: AP_INTEGER_OPTION

	bind_option: AP_STRING_OPTION

	set_arguments (a_parser: AP_PARSER)
			-- Set application arguments.
		do
			precursor (a_parser)
			create port_option.make ('p', "port")
			port_option.enable_mandatory
			port_option.set_description ("Port where fastcgi process listens.")
			a_parser.options.force_last (port_option)
			create bind_option.make ('b', "bind")
			bind_option.set_description ("Bind address; if not given listens on local interface only.%NUse * to listen on all interfaces.")
			a_parser.options.force_last (bind_option)
		end


end
