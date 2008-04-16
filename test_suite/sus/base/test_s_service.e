indexing

	description: "Test SUS service class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_S_SERVICE


inherit

	TS_TEST_CASE


feature -- Tests

	test_all is
		local
			service: SUS_SERVICE
		do
			create service.make_from_port (7, "tcp")
			print_service (service)

			create service.make_from_port (7, Void)
			print_service (service)

			create service.make_from_port (7, "udp")
			print_service (service)

			create service.make_from_name ("echo", "udp")
			print_service (service)

			create service.make_from_name ("ftp", "tcp")
			print_service (service)

			create service.make_from_name ("ftp", Void)
			print_service (service)
		end


feature

	print_service (service: SUS_SERVICE) is
		do
			debug
				print ("name: ")
				print (service.name)
				print ("%N")
				print ("port: ")
				print (service.port)
				print ("%N")
				print ("protocol: ")
				print (service.protocol)
				print ("%N")
				print ("type: ")
				print (service.protocol_type)
				print ("%N")
			end
		end

end
