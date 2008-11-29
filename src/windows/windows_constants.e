indexing

	description: "Windows symbolic constants"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"


class

	WINDOWS_CONSTANTS


inherit

	STDC_CONSTANTS


feature -- Windows open symbolic constants

	O_APPEND: INTEGER is
			-- Set the file offset to the end-of-file prior to each write
		external "C"
		alias "const_o_append"
		end

	O_BINARY: INTEGER is
			-- Opens file in binary (untranslated) mode.
		external "C"
		alias "const_o_binary"
		end

	O_CREAT: INTEGER is
			-- If the file does not exist, allow it to be created. This
			-- flag indicates that the mode argument is present in the
			-- call to open.
		external "C"
		alias "const_o_creat"
		end

	O_EXCL, O_EXCLUSIVE: INTEGER is
			-- Open fails if the file already exists
		external "C"
		alias "const_o_excl"
		end

	O_RANDOM: INTEGER is
			-- Specifies primarily random access from disk
		external "C"
		alias "const_o_random"
		end

	O_RDONLY: INTEGER is
			-- Open for reading only
		external "C"
		alias "const_o_rdonly"
		end

	O_RDWR: INTEGER is
			-- Open fo reading and writing
		external "C"
		alias "const_o_rdwr"
		end

	O_SHORT_LIVED: INTEGER is
			-- Create file as temporary and if possible do not flush to disk.
		external "C"
		alias "const_o_short_lived"
		end

	O_TEMPORARY: INTEGER is
			-- Create file as temporary; file is deleted when last file
			-- handle is closed.
		external "C"
		alias "const_o_temporary"
		end

	O_SEQUENTIAL: INTEGER is
			-- Specifies primarily sequential access from disk
		external "C"
		alias "const_o_sequential"
		end

	O_TEXT: INTEGER is
			-- Opens file in text (translated) mode.
		external "C"
		alias "const_o_text"
		end

	O_TRUNC: INTEGER is
			-- Use only on ordinary files opened for writing. It causes
			-- the file to be truncated to zero length.
		external "C"
		alias "const_o_trunc"
		end

	O_WRONLY: INTEGER is
			-- Open for writing only
		external "C"
		alias "const_o_wronly"
		end


feature -- Windows permission symbolic constants

	S_IEXEC: INTEGER is
			-- execute/search permission, owner
		external "C"
		alias "const_s_iexec"
		end

	S_IREAD: INTEGER is
			-- read permission, owner
		external "C"
		alias "const_s_iread"
		end

	S_IWRITE: INTEGER is
			-- write permission, owner
		external "C"
		alias "const_s_iwrite"
		end


feature -- Windows error codes

	EAGAIN: INTEGER is
		external "C"
		alias "const_eagain"
		end

	EINTR: INTEGER is
		external "C"
		alias "const_eintr"
		end

	EPIPE: INTEGER is 10054
			-- Broken pipe


feature -- Pipe modes

	PIPE_NOWAIT: INTEGER is
			-- Nonblocking mode is enabled.
		external "C"
		alias "const_pipe_nowait"
		end

	PIPE_WAIT: INTEGER is
			-- Blocking mode is enabled.
		external "C"
		alias "const_pipe_wait"
		end


feature -- Protocol families

	AF_INET: INTEGER is
			-- Internet domain sockets for use with IPv4 addresses.
		external "C"
		alias "const_af_inet"
		end

	AF_INET6: INTEGER is
			-- Internet domain sockets for use with IPv6 addresses.
		external "C"
		alias "const_af_inet6"
		end

	AF_UNSPEC: INTEGER is
			-- Unspecified.
		external "C"
		alias "const_af_unspec"
		end


feature -- Lengths of string forms of ip addresses

	INET_ADDRSTRLEN: INTEGER is 16
			-- Length of an IPv4 string.

	INET6_ADDRSTRLEN: INTEGER is 46
			-- Length of an IPv6 string.


feature -- WSAGetLastError codes

	WSANOTINITIALIZED: INTEGER is 10093

	WSAHOSTNOTFOUND: INTEGER is 11001

	WSATRY_AGAIN: INTEGER is 11002

	WSANO_RECOVERY: INTEGER is 11003


feature -- Socket kinds

	SOCK_DGRAM: INTEGER is
			-- Connectionless, unreliable datagrams of fixed maximum length.
		external "C"
		alias "const_sock_dgram"
		end

	SOCK_RAW: INTEGER is
			-- Raw protocol interface.
		external "C"
		alias "const_sock_raw"
		end

	SOCK_SEQPACKET: INTEGER is
			-- Sequenced, reliable, connection-based, datagrams of fixed
			-- maximum length.
		external "C"
		alias "const_sock_seqpacket"
		end

	SOCK_STREAM: INTEGER is
			-- Sequenced, reliable, connection-based byte streams.
		external "C"
		alias "const_sock_stream"
		end


feature -- Other socket constants

	INVALID_SOCKET: INTEGER is 0
			-- Denotes an invalid socket.

	SOCKET_ERROR: INTEGER is -1
			-- Return value if a Windows socket function fails.

	SOMAXCONN: INTEGER is
			-- Maximum backlog.
		external "C"
		alias "const_somaxconn"
		end


feature -- Shutdown options

	SHUT_RD: INTEGER is
			-- No more receptions.
		external "C"
		alias "const_shut_rd"
		end

	SHUT_RDWR: INTEGER is
			-- No more receptions or transmissions.
		external "C"
		alias "const_shut_rdwr"
		end

	SHUT_WR: INTEGER is
			-- No more transmissions.
		external "C"
		alias "const_shut_wr"
		end


feature -- Socket options level

	SOL_SOCKET: INTEGER is 65535

	IPPROTO_IP: INTEGER is 0

	IPPROTO_IPV4: INTEGER is 4

	IPPROTO_IPV6: INTEGER is 41

	IPPROTO_ICMP: INTEGER is 1

	IPPROTO_ICMPV6: INTEGER is 58

	IPPROTO_RAW: INTEGER is 255

	IPPROTO_TCP: INTEGER is 6

	IPPROTO_UDP: INTEGER is 17


feature -- IP type-of-service options

	IP_TOS: INTEGER is 3

	IPTOS_LOWDELAY: INTEGER is 0
			-- Not implemented

	IPTOS_THROUGHPUT: INTEGER is 0
			-- Not implemented


feature -- SOL_SOCKET option names

	SO_RCVBUF: INTEGER is 4098
	SO_REUSEADDR: INTEGER is 4
	SO_SNDBUF: INTEGER is 4097


feature -- ioctlsocket commands

	FIONBIO: INTEGER is
		external "C"
		alias "const_fionbio"
		end


feature -- WSA error codes

	WSAEWOULDBLOCK: INTEGER is 10035
			-- Resource temporarily unavailable.

	WSAENOTSOCK: INTEGER is 10038
			-- Socket operation on a nonsocket


feature -- Special IPv4 addresses

	INADDR_ANY: INTEGER is 0
			-- 0.0.0.0

	INADDR_BROADCAST: INTEGER is -1
			-- 255.255.255.255

	INADDR_LOOPBACK: INTEGER is 2130706433
		-- 127.0.0.1


feature -- TCP options

	TCP_NODELAY: INTEGER is 1
			-- Disables the Nagle algorithm for send coalescing


feature -- Semaphore access rights

	SEMAPHORE_ALL_ACCESS: INTEGER is
			-- All possible access rights for a semaphore object;
			-- Seems to be defined only for Windows NT?
		external "C"
		alias "const_semaphore_all_access"
		end

	SEMAPHORE_MODIFY_STATE: INTEGER is 2
			-- Modify state access, which is required for the
			-- ReleaseSemaphore function


feature -- Security

	SECURITY_DESCRIPTOR_REVISION: INTEGER is
			-- Constant that must be passed to InitializeSecurityDescriptor
		external "C"
		alias "const_security_descriptor_revision"
		end


feature -- Max lengths

	UNLEN: INTEGER is
			-- Maximum length of user name
		external "C"
		alias "const_unlen"
		end

end
