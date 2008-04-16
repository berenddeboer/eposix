indexing

	description: "Windows portable implementation of a TCP socket."

	author: "Berend de Boer"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #2 $"


class

	EPX_TCP_SOCKET


inherit

	EPX_INTERNET_SOCKET

	ABSTRACT_TCP_SOCKET
		undefine
			raise_posix_error,
			unassigned_value
		end


creation

	attach_to_socket


feature {NONE} -- Shutdown

	shutdown (a_how: INTEGER) is
			-- Shut down part of a full-duplex connection.
		do
			assert_winsock_initialized
			safe_wsa_call (posix_shutdown (fd, a_how))
		end

end
