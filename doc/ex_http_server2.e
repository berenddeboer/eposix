class EX_HTTP_SERVER2

inherit

	EPX_CURRENT_PROCESS

create

	make

feature

	make is
		local
			server: EPX_HTTP_SERVER
			servlet: EX_HTTP_SERVLET2
		do
			create server.make_virtual (port_to_listen_on)
			create servlet.make
			server.register_fixed_resource ("/customers", servlet)
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

end
