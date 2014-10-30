note

	description: "SUSv3 portable implementation of a TCP socket."

	author: "Berend de Boer"


class

	EPX_TCP_SOCKET


inherit

	EPX_INTERNET_SOCKET

	ABSTRACT_TCP_SOCKET
		undefine
			new_socket,
			plain_new_socket
		end


create

	attach_to_socket


feature {NONE} -- Shutdown

	shutdown (a_how: INTEGER)
			-- Shut down part of a full-duplex connection.
		do
			safe_call (posix_shutdown (socket, a_how))
		end

end
