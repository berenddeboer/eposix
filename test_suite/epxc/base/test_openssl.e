indexing

	description: "getest based test to see if EPX_OPENSSL works."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_OPENSSL


inherit

	TS_TEST_CASE


feature -- Tests

	test_connect is
		local
			openssl: EPX_OPENSSL
		do
			create openssl.make_ssl3_client (host, port)
			openssl.execute
			openssl.fd_stdout.read_line
			assert ("Got greeting.", not openssl.fd_stdout.last_string.is_empty)
			debug ("test")
				print (openssl.fd_stdout.last_string)
				print ("%N")
			end
			-- Assume imap server at `port'
			openssl.fd_stdin.write_string ("a1 logout%N")
			openssl.wait_for (true)
		end



feature {NONE} -- Implementation

	host: STRING is "berend.gotdns.org"

	port: INTEGER is 993


end
