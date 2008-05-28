indexing

	description: "SUSv3 portable implementation of a socket."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_SOCKET


inherit

	EPX_DESCRIPTOR
		rename
			attach_to_descriptor as attach_to_socket
		redefine
			abstract_read,
			abstract_write
		end

	ABSTRACT_SOCKET
		redefine
			new_socket
		end

	SAPI_SOCKET
		export
			{NONE} all
		end


create

	attach_to_socket


feature {NONE} -- Socket creation

	new_socket (a_domain: INTEGER; a_type: INTEGER): INTEGER is
			-- Return file descriptor for new socket. If error occurs, it
			-- raises an exception when exceptions are enabled. If
			-- exceptions are not enabled, it returns `unassigned_value'.
		do
			Result := precursor (a_domain, a_type)
		ensure then
			valid_socket: raise_exception_on_error implies Result >= 0
			valid_socket_or_error: not raise_exception_on_error implies Result >= -1
		end


feature {NONE} -- Socket close

	protected_close_socket (a_socket: INTEGER) is
			-- Close `a_socket', but make sure errno is not reset by a
			-- successful close. An exception will be raised if closing
			-- the socket fails.
		local
			save_errno: INTEGER
		do
			save_errno := errno.value
			safe_call (abstract_close (a_socket))
			errno.set_value (save_errno)
		end


feature {NONE} -- Abstract API binding

	abstract_read (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Use `recv' instead of `read', because for BeOS a socket
			-- handle is not a descriptor.
		do
			Result := posix_recv (fildes, buf, nbyte, 0)
		end

	abstract_getsockopt (a_socket, a_level, an_option_name: INTEGER; an_option_value: POINTER; an_option_length: POINTER): INTEGER is
			-- Get a socket option.
		do
			Result := posix_getsockopt (a_socket, a_level, an_option_name, an_option_value, an_option_length)
		end

	abstract_setsockopt (a_socket, a_level, an_option_name: INTEGER; an_option_value: POINTER; an_option_length: INTEGER): INTEGER is
			-- Set a socket option.
		do
			Result := posix_setsockopt (a_socket, a_level, an_option_name, an_option_value, an_option_length)
		end

	abstract_socket (a_family, a_type, a_protocol: INTEGER): INTEGER is
			-- Create an endpoint for communication.
		do
			Result := posix_socket (a_family, a_type, a_protocol)
		end

	abstract_write (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Use `send' instead of `write', because for BeOS a socket
			-- handle is not a descriptor.
		do
			Result := posix_send (fildes, buf, nbyte, 0)
		end


invariant

	unassigned_value_is_error_value: unassigned_value = -1

end
