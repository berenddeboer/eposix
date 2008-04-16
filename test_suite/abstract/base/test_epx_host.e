indexing

	description: "Test abstract host class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_EPX_HOST

inherit

	TS_TEST_CASE

feature -- Tests

	test_local_host is
		do
			do_test_host ("localhost")
		end

	test_freebsd is
		do
			do_test_host ("www.freebsd.org")
		end

	test_well_known is
			-- Test host creation for well-known local IP addresses.
		local
			host: EPX_HOST
		do
			create host.make_from_ip4_loopback
			assert ("Host found.", host.found)
			create host.make_from_ip4_any
			assert ("Host found.", host.found)
		end

	test_unknown_host is
		local
			host: EPX_HOST
		do
			create host.make_from_name ("xyz.xyz.xyz.wakawaka")
			assert ("Host not found.", not host.found)
			debug
				print ("Reason not found: ")
				print (host.not_found_reason)
				print ("%N")
			end
		end


feature {NONE} -- Implementation

	do_test_host (a_host_name: STRING) is
			-- Test access to `a_host_name'.
		require
			a_host_name_not_empty: a_host_name /= Void and then not a_host_name.is_empty
		local
			host: EPX_HOST
			i: INTEGER
		do
			create host.make_from_name (a_host_name)
			debug
				if not host.found then
					print ("Resolving ")
					print (a_host_name)
					print (" failed with: ")
					print (host.not_found_reason)
					print (".%N")
				end
			end
			assert ("Host name resolved.", host.found)
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

end
