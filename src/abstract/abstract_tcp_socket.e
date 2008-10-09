indexing

	description: "Base class for TCP/SOCK_STREAM sockets."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	ABSTRACT_TCP_SOCKET


inherit

	ABSTRACT_INTERNET_SOCKET


feature -- Shutdown

	shutdown_read is
			-- The read-half of the connection is closed. No more data
			-- can be received on the socket and any data currently in
			-- the socket receive buffer is discarded. The process can no
			-- longer issue any of the read functions on the socket. Any
			-- data received after this call for a TCP socket is
			-- acknowledged and then silently discarded.
		require
			open: is_open_read
			owner: is_owner
		do
			shutdown (SHUT_RD)
			is_open_read := False
		ensure
			not_readable: not is_open_read
		end

	shutdown_read_write is
			-- The read-half and write-half of the connection are both
			-- closed. This is equivalent to calling `shutdown-read' and
			-- `shutdown_write'.
		require
			open: is_open_read and is_open_write
			owner: is_owner
		do
			shutdown (SHUT_RDWR)
			is_open_read := False
			is_open_write := False
		ensure
			not_readable: not is_open_read
			not_writable: not is_open_write
		end

	shutdown_write is
			-- The write-half of the connection is closed. In the case of
			-- TCP, this is called a half-close. Any data currently in
			-- the socket send buffer will be sent, followed by TCP's
			-- normal connection termination sequence. The process can no
			-- longer issue any of the write functions on the socket.
		require
			open: is_open_write
			owner: is_owner
		do
			shutdown (SHUT_WR)
			is_open_write := False
		ensure
			not_writable: not is_open_write
		end


feature -- Socket options

	set_nodelay is
			-- Disable TCP's Nagle algorithm. By default this algorithm
			-- is enabled.
		do
			my_flag := 1
			safe_call (abstract_setsockopt (fd, IPPROTO_TCP, TCP_NODELAY, $my_flag, 4))
		end


feature {NONE} -- Shutdown

	shutdown (a_how: INTEGER) is
			-- Shut down part of a full-duplex connection.
		require
			open: is_open
			owner: is_owner
			a_how_recognized: a_how = SHUT_RD or else a_how = SHUT_WR or else a_how = SHUT_RDWR
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end


end
