indexing

	description: "SUSv3 portable implementation of a client side TCP socket."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_TCP_CLIENT_SOCKET


inherit

	EPX_TCP_SOCKET

	ABSTRACT_TCP_CLIENT_SOCKET
		undefine
			new_socket,
			plain_new_socket
		end


create

	make,
	open_by_address,
	open_by_name_and_port


feature {NONE} -- Abstract API binding

	abstract_connect (a_socket: INTEGER; an_address: POINTER; an_address_length: INTEGER): INTEGER is
			-- Connect a socket.
		do
			Result := posix_connect (a_socket, an_address, an_address_length)
		end

end
