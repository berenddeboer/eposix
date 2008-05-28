class EX_ECHO_CLIENT_TCP

create

	make

feature

	hello: STRING is "Hello World.%N"

	make is
		local
			host: EPX_HOST
			service: EPX_SERVICE
			echo: EPX_TCP_CLIENT_SOCKET
			sa: EPX_HOST_PORT
		do
			create host.make_from_name ("localhost")
			create service.make_from_name ("echo", "tcp")

			create sa.make (host, service)

			create echo.open_by_address (sa)
			echo.put_string (hello)
			echo.read_string (256)
			if not echo.last_string.is_equal (hello) then
				print ("!! got: ")
				print (echo.last_string)
			end
		end

end
