indexing

	description: "SUSv3 portable implementation of a TCP socket."

	author: "Berend de Boer"
	date: "$Date: 2003/03/20 $"
	revision: "$Revision: #1 $"


class

	EPX_TCP_SOCKET


inherit

	EPX_INTERNET_SOCKET

	ABSTRACT_TCP_SOCKET
		undefine
			new_socket,
			plain_new_socket
		end


creation

	attach_to_socket


feature {NONE} -- Shutdown

	shutdown (a_how: INTEGER) is
			-- Shut down part of a full-duplex connection.
		do
			safe_call (posix_shutdown (fd, a_how))
		end

end
