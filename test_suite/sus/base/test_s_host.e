indexing

	description: "Test SUS host class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_S_HOST

inherit

	TS_TEST_CASE

feature -- Tests

	test_local_host is
		local
			host: SUS_HOST
			i: INTEGER
		do
			-- create host.make_from_name ("www.freebsd.org")
			-- create host.make_from_name ("www.mit.edu")
			-- create host.make_from_name ("www.cnn.com")
			create host.make_from_name ("localhost")
			debug
				print ("canonical name: ")
				print (host.name)
				print ("%N")
				print ("address type: ")
				print (host.address_family)
				print ("%N")
				print ("address length: ")
				print (host.address_length)
				print ("%N")
			end
			assert ("Canonical name available.", not host.name.is_empty)

			from
				i := host.aliases.lower
			until
				i > host.aliases.upper
			loop
				print ("alias ")
				print (host.aliases.item (i))
				print ("%N")
				i := i + 1
			end

			from
				i := host.addresses.lower
			until
				i > host.addresses.upper
			loop
				print ("ip address ")
				print (host.addresses.item (i).out)
				print ("%N")
				i := i + 1
			end
		end

	test_unknown_host is
		local
			host: SUS_HOST
		do
			create host.make_from_name ("xyz.xyz.xyz.wakawaka")
			assert ("Host not found.", not host.found)
			debug
				print ("Reason not found: ")
				print (host.not_found_reason)
				print ("%N")
			end
		end

end
