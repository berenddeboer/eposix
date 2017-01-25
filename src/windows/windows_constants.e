note

	description: "Windows symbolic constants"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"


class

	WINDOWS_CONSTANTS


inherit

	STDC_CONSTANTS


feature -- Windows open symbolic constants

	O_APPEND: INTEGER
			-- Set the file offset to the end-of-file prior to each write
		external "C"
		alias "const_o_append"
		end

	O_BINARY: INTEGER
			-- Opens file in binary (untranslated) mode.
		external "C"
		alias "const_o_binary"
		end

	O_CREAT: INTEGER
			-- If the file does not exist, allow it to be created. This
			-- flag indicates that the mode argument is present in the
			-- call to open.
		external "C"
		alias "const_o_creat"
		end

	O_EXCL, O_EXCLUSIVE: INTEGER
			-- Open fails if the file already exists
		external "C"
		alias "const_o_excl"
		end

	O_RANDOM: INTEGER
			-- Specifies primarily random access from disk
		external "C"
		alias "const_o_random"
		end

	O_RDONLY: INTEGER
			-- Open for reading only
		external "C"
		alias "const_o_rdonly"
		end

	O_RDWR: INTEGER
			-- Open fo reading and writing
		external "C"
		alias "const_o_rdwr"
		end

	O_SHORT_LIVED: INTEGER
			-- Create file as temporary and if possible do not flush to disk.
		external "C"
		alias "const_o_short_lived"
		end

	O_TEMPORARY: INTEGER
			-- Create file as temporary; file is deleted when last file
			-- handle is closed.
		external "C"
		alias "const_o_temporary"
		end

	O_SEQUENTIAL: INTEGER
			-- Specifies primarily sequential access from disk
		external "C"
		alias "const_o_sequential"
		end

	O_TEXT: INTEGER
			-- Opens file in text (translated) mode.
		external "C"
		alias "const_o_text"
		end

	O_TRUNC: INTEGER
			-- Use only on ordinary files opened for writing. It causes
			-- the file to be truncated to zero length.
		external "C"
		alias "const_o_trunc"
		end

	O_WRONLY: INTEGER
			-- Open for writing only
		external "C"
		alias "const_o_wronly"
		end


feature -- Windows permission symbolic constants

	S_IEXEC: INTEGER
			-- execute/search permission, owner
		external "C"
		alias "const_s_iexec"
		end

	S_IREAD: INTEGER
			-- read permission, owner
		external "C"
		alias "const_s_iread"
		end

	S_IWRITE: INTEGER
			-- write permission, owner
		external "C"
		alias "const_s_iwrite"
		end


feature -- Windows error codes

	EAGAIN: INTEGER
		external "C"
		alias "const_eagain"
		end

	EINTR: INTEGER
		external "C"
		alias "const_eintr"
		end

	EPIPE: INTEGER = 10054
			-- Broken pipe


feature -- Pipe modes

	PIPE_NOWAIT: INTEGER
			-- Nonblocking mode is enabled.
		external "C"
		alias "const_pipe_nowait"
		end

	PIPE_WAIT: INTEGER
			-- Blocking mode is enabled.
		external "C"
		alias "const_pipe_wait"
		end


feature -- Protocol families

	AF_INET: INTEGER
			-- Internet domain sockets for use with IPv4 addresses.
		external "C"
		alias "const_af_inet"
		end

	AF_INET6: INTEGER
			-- Internet domain sockets for use with IPv6 addresses.
		external "C"
		alias "const_af_inet6"
		end

	AF_UNSPEC: INTEGER
			-- Unspecified.
		external "C"
		alias "const_af_unspec"
		end


feature -- Lengths of string forms of ip addresses

	INET_ADDRSTRLEN: INTEGER = 16
			-- Length of an IPv4 string.

	INET6_ADDRSTRLEN: INTEGER = 46
			-- Length of an IPv6 string.


feature -- WSAGetLastError codes

	WSANOTINITIALIZED: INTEGER = 10093

	WSAHOSTNOTFOUND: INTEGER = 11001

	WSATRY_AGAIN: INTEGER = 11002

	WSANO_RECOVERY: INTEGER = 11003


feature -- Socket kinds

	SOCK_DGRAM: INTEGER
			-- Connectionless, unreliable datagrams of fixed maximum length.
		external "C"
		alias "const_sock_dgram"
		end

	SOCK_RAW: INTEGER
			-- Raw protocol interface.
		external "C"
		alias "const_sock_raw"
		end

	SOCK_SEQPACKET: INTEGER
			-- Sequenced, reliable, connection-based, datagrams of fixed
			-- maximum length.
		external "C"
		alias "const_sock_seqpacket"
		end

	SOCK_STREAM: INTEGER
			-- Sequenced, reliable, connection-based byte streams.
		external "C"
		alias "const_sock_stream"
		end


feature -- Other socket constants

	INVALID_SOCKET: INTEGER = 0
			-- Denotes an invalid socket.

	SOCKET_ERROR: INTEGER = -1
			-- Return value if a Windows socket function fails.

	SOMAXCONN: INTEGER
			-- Maximum backlog.
		external "C"
		alias "const_somaxconn"
		end


feature -- Shutdown options

	SHUT_RD: INTEGER
			-- No more receptions.
		external "C"
		alias "const_shut_rd"
		end

	SHUT_RDWR: INTEGER
			-- No more receptions or transmissions.
		external "C"
		alias "const_shut_rdwr"
		end

	SHUT_WR: INTEGER
			-- No more transmissions.
		external "C"
		alias "const_shut_wr"
		end


feature -- Socket options level

	SOL_SOCKET: INTEGER = 65535

	IPPROTO_IP: INTEGER = 0

	IPPROTO_IPV4: INTEGER = 4

	IPPROTO_IPV6: INTEGER = 41

	IPPROTO_ICMP: INTEGER = 1

	IPPROTO_ICMPV6: INTEGER = 58

	IPPROTO_RAW: INTEGER = 255

	IPPROTO_TCP: INTEGER = 6

	IPPROTO_UDP: INTEGER = 17


feature -- IP type-of-service options

	IP_TOS: INTEGER = 3

	IPTOS_LOWDELAY: INTEGER = 0
			-- Not implemented

	IPTOS_THROUGHPUT: INTEGER = 0
			-- Not implemented


feature -- SOL_SOCKET option names

	SO_RCVBUF: INTEGER = 4098
	SO_REUSEADDR: INTEGER = 4
	SO_SNDBUF: INTEGER = 4097


feature -- ioctlsocket commands

	FIONBIO: INTEGER
		external "C"
		alias "const_fionbio"
		end


feature -- WSA error codes

	WSAEWOULDBLOCK: INTEGER = 10035
			-- Resource temporarily unavailable.

	WSAENOTSOCK: INTEGER = 10038
			-- Socket operation on a nonsocket


feature -- Special IPv4 addresses

	INADDR_ANY: INTEGER = 0
			-- 0.0.0.0

	INADDR_BROADCAST: INTEGER = -1
			-- 255.255.255.255

	INADDR_LOOPBACK: INTEGER = 2130706433
		-- 127.0.0.1


feature -- TCP options

	TCP_NODELAY: INTEGER = 1
			-- Disables the Nagle algorithm for send coalescing


feature -- Semaphore access rights

	SEMAPHORE_ALL_ACCESS: INTEGER
			-- All possible access rights for a semaphore object;
			-- Seems to be defined only for Windows NT?
		external "C"
		alias "const_semaphore_all_access"
		end

	SEMAPHORE_MODIFY_STATE: INTEGER = 2
			-- Modify state access, which is required for the
			-- ReleaseSemaphore function


feature -- Security

	SECURITY_DESCRIPTOR_REVISION: INTEGER
			-- Constant that must be passed to InitializeSecurityDescriptor
		external "C"
		alias "const_security_descriptor_revision"
		end


feature -- Max lengths

	UNLEN: INTEGER
			-- Maximum length of user name
		external "C"
		alias "const_unlen"
		end

end
