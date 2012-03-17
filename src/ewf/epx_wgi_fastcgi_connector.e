note

	description:

		"Connects eposix to EWF by providing a fastcgi implementation"

	library: "epoxi library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_WGI_FASTCGI_CONNECTOR


inherit

	WGI_CONNECTOR

	SUS_CURRENT_PROCESS


inherit {NONE}

	EPX_WGI_FASTCGI_CONNECTOR_OPTIONS


create

	make


feature {NONE} -- Initialization

	make (a_terminate_signal: attached EPX_KILL_SIGNAL_HANDLER; a_service: attached like wgi_service; an_options: attached like options_template)
		require
			signal_handler_attached: a_terminate_signal /= Void
		do
			terminate_signal := a_terminate_signal
			wgi_service := a_service
			options := an_options
			create tcp_service.make_from_port (options.port, once "tcp")
			--create {EPX_WGI_FASTCGI_STREAM} input.make (fcgi)
			--create {WGI_LIBFCGI_OUTPUT_STREAM} output.make (fcgi)
		end


feature -- Access

	name: STRING_8 = "eposix fastcgi"
			-- Name of Current connector

	version: STRING_8 = "0.1"
			-- Version of Current connector

	tcp_service: EPX_SERVICE
			-- Port on which this server listens

	socket: EPX_TCP_SERVER_SOCKET
			-- Listening socket

	terminate_signal: attached EPX_KILL_SIGNAL_HANDLER


feature {NONE} -- Access

	wgi_service: WGI_SERVICE
			-- Gateway Service

	options: attached like options_template


feature -- Status

	is_open: BOOLEAN
			-- Is the server listening?
		do
			Result := socket /= Void
		end


feature -- Server

	launch
		local
			my_client: ABSTRACT_TCP_SOCKET
		do
			from
				begin_to_listen
			until
				terminate_signal.should_stop
			loop
				my_client := socket.accept
				if my_client /= Void then
					print ("incoming connection%N")
					process_request (my_client)
				end
			end
			print ("terminated%N")
			stop_listening
		end


feature -- Execution

	process_request (a_socket: attached ABSTRACT_TCP_SOCKET)
		local
			rescued: BOOLEAN
			fcgi: EPX_FAST_CGI
			req: WGI_REQUEST_FROM_TABLE
			res: WGI_RESPONSE_STREAM
			input: WGI_INPUT_STREAM
			output: WGI_OUTPUT_STREAM
		do
			if not rescued then
				create fcgi.make (a_socket)
				fcgi.read_all_parameters
				create {EPX_WGI_FASTCGI_INPUT_STREAM} input.make (fcgi)
				create {EPX_WGI_FASTCGI_OUTPUT_STREAM} output.make (fcgi)
				create req.make (fcgi.parameters, input, Current)
				create res.make (output)
				wgi_service.execute (req, res)
				fcgi.close
			else
				-- TODO: fix, don't write trace to browser
				if attached (create {EXCEPTION_MANAGER}).last_exception as e and then attached e.exception_trace as l_trace then
					if res /= Void then
						if not res.status_is_set then
							res.set_status_code ({HTTP_STATUS_CODE}.internal_server_error)
						end
						if res.message_writable then
							res.put_string ("<pre>" + l_trace + "</pre>")
						end
					end
				end
			end
		-- rescue
		-- 	rescued := True
		-- 	retry
		end


feature -- Connection handling

	begin_to_listen
			-- Begin to listen to the specified interface(s).
		require
			not_listening: not is_open
		local
			host: EPX_HOST
		do
			if options.bind = Void or else options.bind.is_empty then
				listen_local
			elseif options.bind ~ "*" then
				listen_all
			else
				create host.make_from_name (options.bind)
				listen (host)
			end
		ensure
			open: is_open
		end

	listen_local
			-- Listen on loopback interface only. No outside machines can
			-- connect to this server.
		require
			not_listening: not is_open
		local
			host: EPX_HOST
		do
			host := new_host (True)
			listen (host)
		ensure
			open: is_open
		end

	listen_all
			-- Listen on all interfaces for incoming connections.
		require
			not_listening: not is_open
		local
			host: EPX_HOST
		do
			host := new_host (False)
			listen (host)
		ensure
			open: is_open
		end

	listen (a_host: EPX_HOST)
			-- Listen on interface(s) `a_host' for incoming connections.
		require
			not_listening: not is_open
		local
			hp: EPX_HOST_PORT
		do
			create hp.make (a_host, tcp_service)
			create socket.listen_by_address (hp)
		ensure
			open: is_open
		end

	stop_listening
			-- Don't listen to requests anymore.
		require
			open: is_open
		do
			socket.close
			socket := Void
		ensure
			closed: not is_open
		end

	new_host (a_loopback_only: BOOLEAN): EPX_HOST
			-- The host name/ip address this web server listen on.
		do
			if a_loopback_only then
				create Result.make_from_ip4_loopback
			else
				create Result.make_from_ip4_any
			end
		ensure
			host_assigned: Result /= Void
			host_found: Result.found
		end


invariant

	terminate_signal_not_void: terminate_signal /= Void

end
