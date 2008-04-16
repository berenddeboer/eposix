indexing

	description: "Test portable select calls."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	TEST_EPX_SELECT


inherit

	TS_TEST_CASE

-- 	EPX_NET_API

-- 	WAPI_IPHLPAPI


feature

	test_close is
			-- Test if we can detect that a file descriptor is closed by
			-- a client.
		local
			host: EPX_HOST
			service: EPX_SERVICE
			client_socket: EPX_TCP_CLIENT_SOCKET
			server_socket: EPX_TCP_SERVER_SOCKET
			sa: EPX_HOST_PORT
			client_fd: ABSTRACT_TCP_SOCKET
			my_select: EPX_SELECT
			timeout: EPX_TIME_VALUE
-- 			buf: STDC_BUFFER
-- 			r: INTEGER
-- 			i: INTEGER
-- 			row: POINTER
-- 			ip_address: EPX_IP4_ADDRESS
		do
			create host.make_from_name ("localhost")
			create service.make_from_port (port, "tcp")
			create sa.make (host, service)
			create server_socket.listen_by_address (sa)
			create client_socket.open_by_address (sa)
			client_fd := server_socket.accept
			server_socket.close
			client_socket.write_string (hello)

			-- Test if we can read from the client
			create my_select.make
			my_select.check_for_reading.put (client_fd)
			my_select.execute
			assert ("Ready for reading.", my_select.ready_for_reading.has (client_fd))
			assert_integers_equal ("One selector ready for reading.", 1, my_select.ready_descriptors)

			-- And read it
			client_fd.read_string (256)
			assert_equal ("Read what written by client.", hello, client_fd.last_string)

			-- Test if we can write to the client.
			create my_select.make
			my_select.check_for_writing.put (client_fd)
			my_select.execute
			assert ("Teady for writing.", my_select.ready_for_writing.has (client_fd))
			assert_integers_equal ("One selector ready for writing.", 1, my_select.ready_descriptors)

			-- Can we read although there is nothing to read?
			create my_select.make
			my_select.check_for_reading.put (client_fd)
			create timeout.make
			timeout.set_seconds (1)
			my_select.set_timeout (timeout)
			my_select.execute
			assert_integers_equal ("No selectors ready for reading.", 0, my_select.ready_descriptors)
			assert ("Not ready for reading.", not my_select.ready_for_reading.has (client_fd))

			-- Does a shutdown_write cause the server to see something to read?
			client_socket.shutdown_write
			my_select.execute
			assert_integers_equal ("Socket ready for reading after shutdown_write.", 1, my_select.ready_descriptors)
			assert ("Ready for reading after shutdown_write.", my_select.ready_for_reading.has (client_fd))
			client_fd.read_string (256)
			assert_integers_equal ("Zero bytes read.", 0, client_fd.last_read)
			assert ("And EOF set.", client_fd.eof)

			-- More to read?
			my_select.execute
			assert ("Even more to read.", my_select.ready_for_reading.has (client_fd))
			-- Which is strange, because we have encountered EOF.
			-- Probably we always get 0 now as result from read().

			-- Test if we can see if a socket is closed by a client
			--client_socket.shutdown_read_write
			client_socket.shutdown_read
			client_socket.close
			create my_select.make
			my_select.check_for_reading.put (client_fd)
			my_select.check_for_writing.put (client_fd)
			my_select.execute
			assert ("Still ready for writing.", my_select.ready_for_writing.has (client_fd))

			-- Print socket state on Windows
-- 			create buf.allocate (8 * 1024)
-- 			len := buf.capacity
-- 			r := posix_gettcptable (buf.ptr, $len, False)
-- 			print ("Table size: ")
-- 			print (len.out)
-- 			print ("%N")
-- 			print ("Number of entries: ")
-- 			print (posix_mib_tcptable_dwnumentries (buf.ptr))
-- 			print ("%N")
-- 			from
-- 				i := 0
-- 			until
-- 				i = posix_mib_tcptable_dwnumentries (buf.ptr)
-- 			loop
-- 				row := posix_mib_tcptable_table_item (buf.ptr, i)
-- 				print ("State: ")
-- 				print (posix_mib_tcprow_dwstate (row))
-- 				print ("%N")
-- 				print ("Local: ")
-- 				create ip_address.make_from_integer (posix_ntohl (posix_mib_tcprow_dwlocaladdr (row)))
-- 				print (ip_address.out)
-- 				print (":")
-- 				print (posix_ntohs (posix_mib_tcprow_dwlocalport (row)))
-- 				print ("%N")
-- 				print ("Remote: ")
-- 				create ip_address.make_from_integer (posix_ntohl (posix_mib_tcprow_dwremoteaddr (row)))
-- 				print (ip_address.out)
-- 				print (":")
-- 				print (posix_ntohs (posix_mib_tcprow_dwremoteport (row)))
-- 				print ("%N")
-- 				print ("%N")
-- 				i := i + 1
-- 			end

			client_fd.put_string ("up%N")
			assert_integers_equal ("All bytes written (but don't know where to...)", 3, client_fd.last_written)
			my_select.execute
			assert ("Ready for receiving the SIGPIPE.", my_select.ready_for_writing.has (client_fd))
			-- don't call, you get that SIGPIPE
			--client_fd.write_string ("up%N")
		end


feature {NONE} -- Implementation

	len: INTEGER

	port: INTEGER is 9877
			-- Thanks to W. Richard Stevens

	hello: STRING is "Hello World.%N"

end
