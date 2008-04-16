indexing

	description: "Base class for socket descriptors."

	known_bugs: "Should inherit from ABSTRACT_DESCRIPTOPR, not from ABSTRACT_FILE_DESCRIPTOR."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	ABSTRACT_SOCKET


inherit

	ABSTRACT_NET_BASE

	ABSTRACT_DESCRIPTOR
		rename
			attach_to_descriptor as attach_to_socket
		undefine
			is_blocking_io,
			set_blocking_io,
			supports_nonblocking_io
		end


feature -- Status

	supports_receive_buffer_size: BOOLEAN is
			-- Does this socket implementation support querying and
			-- setting the receive buffer size?
			-- Supported on all platforms except BeOS
		do
			Result := SO_RCVBUF /= 0
		end

	supports_send_buffer_size: BOOLEAN is
			-- Does this socket implementation support querying and
			-- setting the send buffer size?
			-- Supported on all platforms except BeOS
		do
			Result := SO_SNDBUF /= 0
		end


feature {NONE} -- Socket creation

	new_socket (a_domain: INTEGER; a_type: INTEGER): INTEGER is
			-- Return file descriptor for new socket. If error occurs, it
			-- raises an exception when exceptions are enabled. If
			-- exceptions are not enabled, it returns `unassigned_value'.
		do
			Result := abstract_socket (
				a_domain,
				a_type,
				0)
			if Result = unassigned_value then
				raise_posix_error
			end
		ensure
			valid_socket: raise_exception_on_error implies Result /= unassigned_value
		end


feature {NONE} -- Socket close

	protected_close_socket (a_socket: INTEGER) is
			-- Close `a_socket', but make sure errno is not reset by a
			-- successful close. An exception will be raised if closing
			-- the socket fails.
		require
			valid_socket: a_socket /= unassigned_value
		deferred
		ensure
			errno_not_changed: errno.value = old errno.value
		end


feature -- Access

	receive_buffer_size: INTEGER is
			-- Size of receive buffer;
			-- Not supported on BeOS.
		require
			can_query_receive_buffer_size: supports_receive_buffer_size
		do
			address_length := 4
			safe_call (abstract_getsockopt (fd, SOL_SOCKET, SO_RCVBUF, $my_flag, $address_length))
			Result := my_flag
		ensure
			positive: Result > 0
		end

	send_buffer_size: INTEGER is
			-- Size of send buffer
			-- Not supported on BeOS.
		require
			can_query_send_buffer_size: supports_send_buffer_size
		do
			address_length := 4
			safe_call (abstract_getsockopt (fd, SOL_SOCKET, SO_SNDBUF, $my_flag, $address_length))
			Result := my_flag
		ensure
			positive: Result > 0
		end


feature -- Change

	set_receive_buffer_size (a_new_size: INTEGER) is
			-- Set size of receive buffer to at least `a_new_size'.
		require
			can_set_receive_buffer_size: supports_receive_buffer_size
			size_positive: a_new_size > 0
		do
			my_flag := a_new_size
			safe_call (abstract_setsockopt (fd, SOL_SOCKET, SO_RCVBUF, $my_flag, 4))
		ensure
			size_set: receive_buffer_size >= a_new_size
		end

	set_send_buffer_size (a_new_size: INTEGER) is
			-- Set size of send buffer to at least `a_new_size'.
		require
			can_set_send_buffer_size: supports_send_buffer_size
			size_positive: a_new_size > 0
		do
			my_flag := a_new_size
			safe_call (abstract_setsockopt (fd, SOL_SOCKET, SO_SNDBUF, $my_flag, 4))
		ensure
			size_set: send_buffer_size >= a_new_size
		end


feature {NONE} -- Implementation

	address_length: INTEGER
			-- Actual length of address, set by various calls;
			-- Only valid immediately after a call.
			-- Local variables do not work for SE.

	my_flag: INTEGER
			-- Boolean to be passed to `setsockopt' or `ioctlsocket' and such

	my_local_address: ABSTRACT_SOCKET_ADDRESS_IN_BASE
			-- Cache for `local_address'

	my_remote_address: ABSTRACT_SOCKET_ADDRESS_IN_BASE
			-- Cache for `remote_address'


feature {NONE} -- Abstract API binding

	abstract_getsockopt (a_socket, a_level, an_option_name: INTEGER; an_option_value: POINTER; an_option_length: POINTER): INTEGER is
			-- Get a socket option.
		require
			valid_socket: a_socket /= unassigned_value
			option_value_not_nil: an_option_value /= default_pointer
			option_length_not_nil: an_option_length /= default_pointer
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end

	abstract_setsockopt (a_socket, a_level, an_option_name: INTEGER; an_option_value: POINTER; an_option_length: INTEGER): INTEGER is
			-- Set a socket option.
		require
			valid_socket: a_socket /= unassigned_value
			option_value_not_nil: an_option_value /= default_pointer
			option_length_positive: an_option_length > 0
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end

	abstract_socket (a_family, a_type, a_protocol: INTEGER): INTEGER is
			-- Create an endpoint for communication. When an error
			-- occurs, `unassigned_value' is returned.
		deferred
		ensure
			-- Result = unassigned_value implies errno.value is set
		end


feature -- Callbacks for the Multiplexer

	multiplexer_read_callback (a_multiplexer: EPX_SOCKET_MULTIPLEXER) is
			-- callback for read
		do
		end

	multiplexer_write_callback (a_multiplexer: EPX_SOCKET_MULTIPLEXER) is
			-- callback for read
		do
		end

	multiplexer_error_callback (a_multiplexer: EPX_SOCKET_MULTIPLEXER) is
			-- callback for read
		do
		end

	multiplexer_read_idle_callback (a_multiplexer: EPX_SOCKET_MULTIPLEXER) is
			-- callback for read
		do
		end

	multiplexer_write_idle_callback (a_multiplexer: EPX_SOCKET_MULTIPLEXER) is
			-- callback for read
		do
		end


end
