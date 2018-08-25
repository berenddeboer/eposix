note

	description: "UDP/SOCK_DGRAM sockets, base class."

	author: "Berend de Boer"


class

	SUS_UDP_SOCKET


inherit

	SUS_INTERNET_SOCKET
		redefine
			abstract_read
		end

	SAPI_SOCKET
		export
			{NONE} all
		end


create

	attach_to_socket


feature -- Access

	last_sender: detachable ABSTRACT_SOCKET_ADDRESS_IN_BASE
			-- Address of sender of last message read


feature -- Status

	is_multicast_supported: BOOLEAN
		do
			Result := IP_ADD_MEMBERSHIP /= 0
		end


feature {NONE} -- Access

	sockaddr: detachable EPX_BUFFER

	addrlen: detachable EPX_BUFFER


feature {NONE} -- Abstract API binding

	abstract_read (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER
			-- For udp sockets, use `recvfrom' so we can get the sender's address.
		do
			if sockaddr = Void then
				create sockaddr.allocate_and_clear (posix_sockaddr_size)
			end
			if attached sockaddr as l_sockaddr then
				my_flag := l_sockaddr.capacity
				Result := posix_recvfrom (fildes, buf, nbyte, 0, l_sockaddr.ptr, $my_flag)
				if Result /= -1 then
					-- TODO: optimise so we don't create new sockaddr_in, but
					-- `posix_recvfrom' should simply write to the right sockaddr_in
					-- structure.
					-- Obviously sockaddr_in should support dynamically
					-- updating its fields.
					if posix_sockaddr_sa_family (l_sockaddr.ptr) = AF_INET then
						create {EPX_SOCKET_ADDRESS_IN} last_sender.make_from_pointer (l_sockaddr.ptr, my_flag)
					elseif posix_sockaddr_sa_family (l_sockaddr.ptr) = AF_INET6 then
						create {EPX_SOCKET_ADDRESS_IN6} last_sender.make_from_pointer (l_sockaddr.ptr, my_flag)
					end
				end
			end
		end


end
