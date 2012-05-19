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

	make (a_service: attached like wgi_service; an_options: attached like options_template)
		require
			options_not_void: an_options /= Void
			valid_port: an_options.port > 0 and then an_options.port <= 65535
			signal_handler_attached: an_options.terminate_signal /= Void
		do
			options := an_options
			terminate_signal := options.terminate_signal
			wgi_service := a_service
			create tcp_service.make_from_port (options.port, once "tcp")
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

	child_signal: attached EPX_SIGNALLED_SIGNAL_HANDLER


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
			handler: EPX_WSF_REQUEST_HANDLER
		do
			create pending_handlers.make
			from
				begin_to_listen
			until
				terminate_signal.should_stop
			loop
				my_client := socket.accept
				if my_client = Void then
					print ("client = Void%N")
				else
					print ("client /= Void%N")
				end
				if my_client /= Void then
					create handler.make (wgi_service, my_client)
					if options.no_fork then
						handler.execute
					else
						fork (handler)
						wait_for_handlers
						pending_handlers.put_last (handler)
					end
				elseif not terminate_signal.should_stop and then not options.no_fork then
					wait_for_handlers
				end
			end
			stop_listening
			wait_for_handlers
		end

	pending_handlers: DS_LINKED_LIST [POSIX_CHILD_PROCESS]

	wait_for_handlers
		require
			pending_handlers_not_void: pending_handlers /= Void
		local
			c: DS_LINKED_LIST_CURSOR [POSIX_CHILD_PROCESS]
		do
			c := pending_handlers.new_cursor
			from
				c.start
			until
				c.after
			loop
				c.item.wait_for (False)
				if c.item.is_terminated then
					c.remove
				else
					c.forth
				end
			end
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
