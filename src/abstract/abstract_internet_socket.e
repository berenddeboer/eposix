note

	description: "Base class for AF_INET/AF_INET6 sockets."

	author: "Berend de Boer"


deferred class

	ABSTRACT_INTERNET_SOCKET


inherit

	ABSTRACT_SOCKET
		rename
			new_socket as plain_new_socket
		end


feature -- Change

	set_low_delay
			-- Minimize delay.
		require
			open: is_open
		do
			if IP_TOS /= 0 and then IPTOS_LOWDELAY /= 0 then
				my_flag := IPTOS_LOWDELAY
				safe_call (abstract_setsockopt (socket, IPPROTO_IP, IP_TOS, $my_flag, 4))
			end
		end

	set_throughput
			-- Maximize throughput.
		require
			open: is_open
		do
			if IP_TOS /= 0 and then IPTOS_THROUGHPUT /= 0 then
				my_flag := IPTOS_THROUGHPUT
				safe_call (abstract_setsockopt (socket, IPPROTO_IP, IP_TOS, $my_flag, 4))
			end
		end


feature -- Local and remote addresses

	local_address: ABSTRACT_SOCKET_ADDRESS_IN_BASE
			-- Return address used on this side to talk to remote.
		require
			open: is_open
		local
			buf: STDC_BUFFER
		do
			if attached my_local_address as a then
				Result := a
			else
				create buf.allocate_and_clear (256)
				address_length := buf.capacity
				safe_call (abstract_getsockname (socket, buf.ptr, $address_length))
				Result := new_socket_address_in_from_pointer (buf, address_length)
				my_local_address := Result
			end
		ensure
			local_address_not_void: Result /= Void
		end

	remote_address: ABSTRACT_SOCKET_ADDRESS_IN_BASE
			-- Return address used at remote side to talk to this side.
		require
			open: is_open
		local
			buf: STDC_BUFFER
		do
			if attached my_remote_address as a then
				Result := a
			else
				create buf.allocate_and_clear (256)
				address_length := buf.capacity
				safe_call (abstract_getpeername (socket, buf.ptr, $address_length))
				Result := new_socket_address_in_from_pointer (buf, address_length)
				my_remote_address := Result
			end
		ensure
			remote_address_not_void: Result /= Void
		end


feature {NONE} -- Socket creation

	new_socket (hp: EPX_HOST_PORT): INTEGER
			-- Return file descriptor for new socket. If error occurs, it
			-- raises an exception when exceptions are enabled. If
			-- exceptions are not enabled, it returns -1.
		require
			hp_not_void: hp /= Void
		do
			-- Assume AF_INET = PF_INET, etc.
			Result := plain_new_socket (hp.host.address_family, hp.service.protocol_type)
		ensure
			valid_socket: raise_exception_on_error implies Result /= unassigned_value
		end


feature {NONE} -- Implementation

	is_family_handled (a_family: INTEGER): BOOLEAN
			-- Is family `a_family' correctly recognized by
			-- `new_socket_address_in_from_pointer'?
		do
			Result :=
				a_family = AF_INET or else
				a_family = AF_INET6
		end

	new_socket_address_in_from_pointer (buf: STDC_BUFFER; actual_length: INTEGER): ABSTRACT_SOCKET_ADDRESS_IN_BASE
			-- Create a new ABSTRACT_SOCKET_ADDRESS_IN_BASE structure,
			-- depending on the family found in `buf'.
		require
			buf_not_void: buf /= Void
			actual_lengt_positive: actual_length >= 1
			actual_length_not_larger_than_buf: actual_length <= buf.capacity
			family_known: is_family_handled (abstract_api.posix_sockaddr_sa_family (buf.ptr))
		local
			family: INTEGER
		do
			family := abstract_api.posix_sockaddr_sa_family (buf.ptr)
			if family = AF_INET then
				create {EPX_SOCKET_ADDRESS_IN} Result.make_from_pointer (buf.ptr, actual_length)
			elseif family = AF_INET6 then
				create {EPX_SOCKET_ADDRESS_IN6} Result.make_from_pointer (buf.ptr, actual_length)
			else
				do_raise ("new_socket_address_in_from_pointer: unsupported family detected: " + family.out)
				-- silence compiler, we never get here.
				create {EPX_SOCKET_ADDRESS_IN} Result.make_from_pointer (buf.ptr, actual_length)
			end
		ensure
			socket_address_in_returned: Result /= Void
		end


feature {NONE} -- Abstract API binding

	abstract_getpeername (a_socket: INTEGER; a_address: POINTER; a_address_length: POINTER): INTEGER
			-- Retrieve the name of the peer to which a socket is connected.
		require
			valid_socket: a_socket /= unassigned_value
			address_not_nil: a_address /= default_pointer
			address_length_not_nil: a_address_length /= default_pointer
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end

	abstract_getsockname (a_socket: INTEGER; a_address: POINTER; a_address_length: POINTER): INTEGER
			-- Retrieve the local name for a socket.
		require
			valid_socket: a_socket /= unassigned_value
			address_not_nil: a_address /= default_pointer
			address_length_not_nil: a_address_length /= default_pointer
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end


end
