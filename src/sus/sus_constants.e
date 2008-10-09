indexing

	description: "SUS symbolic constants"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

class

	SUS_CONSTANTS


inherit

	POSIX_CONSTANTS


feature -- Syslog facility codes

	LOG_KERN: INTEGER is
			-- kernel messages
		external "C"
		alias "const_log_kern"
		end

	LOG_USER: INTEGER is
			-- random user-level messages
		external "C"
		alias "const_log_user"
		end

	LOG_MAIL: INTEGER is
			-- mail system
		external "C"
		alias "const_log_mail"
		end

	LOG_DAEMON: INTEGER is
			-- system daemons
		external "C"
		alias "const_log_daemon"
		end

	LOG_AUTH: INTEGER is
			-- security/authorization messages
		external "C"
		alias "const_log_auth"
		end

	LOG_LPR: INTEGER is
			-- line printer subsystem
		external "C"
		alias "const_log_lpr"
		end

	LOG_NEWS: INTEGER is
			-- network news subsystem
		external "C"
		alias "const_log_news"
		end

	LOG_UUCP: INTEGER is
			-- UUCP subsystem
		external "C"
		alias "const_log_uucp"
		end

	LOG_CRON: INTEGER is
			-- clock daemon
		external "C"
		alias "const_log_cron"
		end

	LOG_LOCAL0: INTEGER is
			-- Reserved for local use
		external "C"
		alias "const_log_local0"
		end

	LOG_LOCAL1: INTEGER is
			-- Reserved for local use
		external "C"
		alias "const_log_local1"
		end

	LOG_LOCAL2: INTEGER is
			-- Reserved for local use
		external "C"
		alias "const_log_local2"
		end

	LOG_LOCAL3: INTEGER is
			-- Reserved for local use
		external "C"
		alias "const_log_local3"
		end

	LOG_LOCAL4: INTEGER is
			-- Reserved for local use
		external "C"
		alias "const_log_local4"
		end

	LOG_LOCAL5: INTEGER is
			-- Reserved for local use
		external "C"
		alias "const_log_local5"
		end

	LOG_LOCAL6: INTEGER is
			-- Reserved for local use
		external "C"
		alias "const_log_local6"
		end

	LOG_LOCAL7: INTEGER is
			-- Reserved for local use
		external "C"
		alias "const_log_local7"
		end


feature -- Syslog open options

	LOG_PID: INTEGER is
			-- log the pid with each message
		external "C"
		alias "const_log_pid"
		end

	LOG_CONS: INTEGER is
			-- log on the console if errors in sending
		external "C"
		alias "const_log_cons"
		end

	LOG_ODELAY: INTEGER is
			-- delay open until first syslog() (default)
		external "C"
		alias "const_log_odelay"
		end

	LOG_NDELAY: INTEGER is
			-- don't delay open
		external "C"
		alias "const_log_ndelay"
		end


feature -- Syslog priorities

	LOG_EMERG: INTEGER is
		external "C"
		alias "const_log_emerg"
		end

	LOG_ALERT: INTEGER is
		external "C"
		alias "const_log_alert"
		end

	LOG_CRIT: INTEGER is
		external "C"
		alias "const_log_crit"
		end

	LOG_ERR: INTEGER is
		external "C"
		alias "const_log_err"
		end

	LOG_WARNING: INTEGER is
		external "C"
		alias "const_log_warning"
		end

	LOG_NOTICE: INTEGER is
		external "C"
		alias "const_log_notice"
		end

	LOG_INFO: INTEGER is
		external "C"
		alias "const_log_info"
		end

	LOG_DEBUG: INTEGER is
		external "C"
		alias "const_log_debug"
		end


feature -- Socket kinds

	SOCK_DGRAM: INTEGER is
			-- Connectionless, unreliable datagrams of fixed maximum length.
		external "C"
		alias "const_sock_dgram"
		end

	SOCK_PACKET: INTEGER is
			-- Linux specific way of getting packets at the dev level.
			-- For writing rarp and other similar things on the user
			-- level.
		external "C"
		alias "const_sock_packet"
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

	AF_UNIX: INTEGER is
			-- UNIX domain sockets.
		external "C"
		alias "const_af_unix"
		end

	AF_UNSPEC: INTEGER is
			-- Unspecified.
		external "C"
		alias "const_af_unspec"
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


feature -- h_errno values

	TRY_AGAIN: INTEGER is
			-- Non-Authoritative Host not found, or SERVERFAIL.
		external "C"
		alias "const_try_again"
		end

	NO_RECOVERY: INTEGER is
			-- Non recoverable errors, FORMERR, REFUSED, NOTIMP.
		external "C"
		alias "const_no_recovery"
		end

	NO_DATA: INTEGER is
		-- Valid name, no data record of requested type.
		external "C"
		alias "const_no_data"
		end

	NO_ADDRESS: INTEGER is
			-- No address, look for MX record. Equal to NO_DATA.
		do
			Result := NO_DATA
		end


feature -- Lengths of string forms of ip addresses

	INET_ADDRSTRLEN: INTEGER is 16
			-- Length of an IPv4 string.

	INET6_ADDRSTRLEN: INTEGER is 46
			-- Length of an IPv6 string.


feature -- Other constants

	SOMAXCONN: INTEGER is
			-- Maximum backlog.
		external "C"
		alias "const_somaxconn"
		end


feature -- Socket options level for `getsockopt' and `setsockopt'

	SOL_SOCKET: INTEGER is
		external "C"
		alias "const_sol_socket"
		end

	IPPROTO_IP: INTEGER is
		external "C"
		alias "const_ipproto_ip"
		end

	IPPROTO_IPV6: INTEGER is
		external "C"
		alias "const_ipproto_ipv6"
		end

	IPPROTO_ICMP: INTEGER is
		external "C"
		alias "const_ipproto_icmp"
		end

	IPPROTO_ICMPV6: INTEGER is
		external "C"
		alias "const_ipproto_icmpv6"
		end

	IPPROTO_RAW: INTEGER is
		external "C"
		alias "const_ipproto_raw"
		end

	IPPROTO_TCP: INTEGER is
		external "C"
		alias "const_ipproto_tcp"
		end

	IPPROTO_UDP: INTEGER is
		external "C"
		alias "const_ipproto_udp"
		end


feature -- SOL_SOCKET option names

	SO_RCVBUF: INTEGER is
			-- Receive buffer size;
			-- 0 if option not supported (only on BeOS).
		external "C"
		alias "const_so_rcvbuf"
		end

	SO_REUSEADDR: INTEGER is
			-- Allow local address reuse
		external "C"
		alias "const_so_reuseaddr"
		end

	SO_SNDBUF: INTEGER is
			-- Send buffer size;
			-- 0 if option not supported (only on BeOS).
		external "C"
		alias "const_so_sndbuf"
		end


feature -- IP type-of-service options

	IP_TOS: INTEGER is
		external "C"
		alias "const_ip_tos"
		end

	IPTOS_LOWDELAY: INTEGER is
		external "C"
		alias "const_iptos_lowdelay"
		end

	IPTOS_THROUGHPUT: INTEGER is
		external "C"
		alias "const_iptos_throughput"
		end


feature -- TCP options

	TCP_NODELAY: INTEGER is
		external "C"
		alias "const_tcp_nodelay"
		end


feature -- Special IPv4 addresses

	INADDR_ANY: INTEGER is 0
			-- 0.0.0.0

	INADDR_BROADCAST: INTEGER is -1
			-- 255.255.255.255

	INADDR_LOOPBACK: INTEGER is 2130706433
		-- 127.0.0.1


feature -- Available clocks (-1 if not available)

	CLOCK_REALTIME: INTEGER is
		external "C"
		alias "const_clock_realtime"
		end

	CLOCK_MONOTONIC: INTEGER is
		external "C"
		alias "const_clock_monotonic"
		end

	CLOCK_PROCESS_CPUTIME_ID: INTEGER is
		external "C"
		alias "const_clock_process_cputime_id"
		end

	CLOCK_THREAD_CPUTIME_ID: INTEGER is
		external "C"
		alias "const_clock_thread_cputime_id"
		end


end
