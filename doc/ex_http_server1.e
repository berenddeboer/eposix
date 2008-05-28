class EX_HTTP_SERVER1

inherit

	EPX_CURRENT_PROCESS

create

	make

feature

	make is
		local
			server: EPX_HTTP_SERVER
		do
			create server.make (port_to_listen_on, document_root)
			server.set_serve_xhtml_if_supported (False)
			server.listen_locally
			from
			until
				False
			loop
				server.process_next_requests
				millisleep (100)
			end
		end

	port_to_listen_on: INTEGER is 5566

	document_root: STRING is "/var/www/html"

end
