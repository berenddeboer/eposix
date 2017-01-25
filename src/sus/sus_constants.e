note

	description: "SUS symbolic constants"

	author: "Berend de Boer"


class

	SUS_CONSTANTS


inherit

	POSIX_CONSTANTS


feature -- Syslog facility codes

	LOG_KERN: INTEGER
			-- kernel messages
		external "C"
		alias "const_log_kern"
		end

	LOG_USER: INTEGER
			-- random user-level messages
		external "C"
		alias "const_log_user"
		end

	LOG_MAIL: INTEGER
			-- mail system
		external "C"
		alias "const_log_mail"
		end

	LOG_DAEMON: INTEGER
			-- system daemons
		external "C"
		alias "const_log_daemon"
		end

	LOG_AUTH: INTEGER
			-- security/authorization messages
		external "C"
		alias "const_log_auth"
		end

	LOG_LPR: INTEGER
			-- line printer subsystem
		external "C"
		alias "const_log_lpr"
		end

	LOG_NEWS: INTEGER
			-- network news subsystem
		external "C"
		alias "const_log_news"
		end

	LOG_UUCP: INTEGER
			-- UUCP subsystem
		external "C"
		alias "const_log_uucp"
		end

	LOG_CRON: INTEGER
			-- clock daemon
		external "C"
		alias "const_log_cron"
		end

	LOG_LOCAL0: INTEGER
			-- Reserved for local use
		external "C"
		alias "const_log_local0"
		end

	LOG_LOCAL1: INTEGER
			-- Reserved for local use
		external "C"
		alias "const_log_local1"
		end

	LOG_LOCAL2: INTEGER
			-- Reserved for local use
		external "C"
		alias "const_log_local2"
		end

	LOG_LOCAL3: INTEGER
			-- Reserved for local use
		external "C"
		alias "const_log_local3"
		end

	LOG_LOCAL4: INTEGER
			-- Reserved for local use
		external "C"
		alias "const_log_local4"
		end

	LOG_LOCAL5: INTEGER
			-- Reserved for local use
		external "C"
		alias "const_log_local5"
		end

	LOG_LOCAL6: INTEGER
			-- Reserved for local use
		external "C"
		alias "const_log_local6"
		end

	LOG_LOCAL7: INTEGER
			-- Reserved for local use
		external "C"
		alias "const_log_local7"
		end


feature -- Syslog open options

	LOG_PID: INTEGER
			-- log the pid with each message
		external "C"
		alias "const_log_pid"
		end

	LOG_CONS: INTEGER
			-- log on the console if errors in sending
		external "C"
		alias "const_log_cons"
		end

	LOG_ODELAY: INTEGER
			-- delay open until first syslog() (default)
		external "C"
		alias "const_log_odelay"
		end

	LOG_NDELAY: INTEGER
			-- don't delay open
		external "C"
		alias "const_log_ndelay"
		end


feature -- Syslog priorities

	LOG_EMERG: INTEGER
		external "C"
		alias "const_log_emerg"
		end

	LOG_ALERT: INTEGER
		external "C"
		alias "const_log_alert"
		end

	LOG_CRIT: INTEGER
		external "C"
		alias "const_log_crit"
		end

	LOG_ERR: INTEGER
		external "C"
		alias "const_log_err"
		end

	LOG_WARNING: INTEGER
		external "C"
		alias "const_log_warning"
		end

	LOG_NOTICE: INTEGER
		external "C"
		alias "const_log_notice"
		end

	LOG_INFO: INTEGER
		external "C"
		alias "const_log_info"
		end

	LOG_DEBUG: INTEGER
		external "C"
		alias "const_log_debug"
		end


feature -- Socket kinds

	SOCK_DGRAM: INTEGER
			-- Connectionless, unreliable datagrams of fixed maximum length.
		external "C"
		alias "const_sock_dgram"
		end

	SOCK_PACKET: INTEGER
			-- Linux specific way of getting packets at the dev level.
			-- For writing rarp and other similar things on the user
			-- level.
		external "C"
		alias "const_sock_packet"
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

	AF_UNIX: INTEGER
			-- UNIX domain sockets.
		external "C"
		alias "const_af_unix"
		end

	AF_UNSPEC: INTEGER
			-- Unspecified.
		external "C"
		alias "const_af_unspec"
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


feature -- h_errno values

	TRY_AGAIN: INTEGER
			-- Non-Authoritative Host not found, or SERVERFAIL.
		external "C"
		alias "const_try_again"
		end

	NO_RECOVERY: INTEGER
			-- Non recoverable errors, FORMERR, REFUSED, NOTIMP.
		external "C"
		alias "const_no_recovery"
		end

	NO_DATA: INTEGER
		-- Valid name, no data record of requested type.
		external "C"
		alias "const_no_data"
		end

	NO_ADDRESS: INTEGER
			-- No address, look for MX record. Equal to NO_DATA.
		do
			Result := NO_DATA
		end


feature -- Lengths of string forms of ip addresses

	INET_ADDRSTRLEN: INTEGER = 16
			-- Length of an IPv4 string.

	INET6_ADDRSTRLEN: INTEGER = 46
			-- Length of an IPv6 string.


feature -- Other constants

	SOMAXCONN: INTEGER
			-- Maximum backlog.
		external "C"
		alias "const_somaxconn"
		end


feature -- Socket options level for `getsockopt' and `setsockopt'

	SOL_SOCKET: INTEGER
		external "C"
		alias "const_sol_socket"
		end

	IPPROTO_IP: INTEGER
		external "C"
		alias "const_ipproto_ip"
		end

	IPPROTO_IPV6: INTEGER
		external "C"
		alias "const_ipproto_ipv6"
		end

	IPPROTO_ICMP: INTEGER
		external "C"
		alias "const_ipproto_icmp"
		end

	IPPROTO_ICMPV6: INTEGER
		external "C"
		alias "const_ipproto_icmpv6"
		end

	IPPROTO_RAW: INTEGER
		external "C"
		alias "const_ipproto_raw"
		end

	IPPROTO_TCP: INTEGER
		external "C"
		alias "const_ipproto_tcp"
		end

	IPPROTO_UDP: INTEGER
		external "C"
		alias "const_ipproto_udp"
		end


feature -- SOL_SOCKET option names

	SO_RCVBUF: INTEGER
			-- Receive buffer size;
			-- 0 if option not supported (only on BeOS).
		external "C"
		alias "const_so_rcvbuf"
		end

	SO_REUSEADDR: INTEGER
			-- Allow local address reuse
		external "C"
		alias "const_so_reuseaddr"
		end

	SO_SNDBUF: INTEGER
			-- Send buffer size;
			-- 0 if option not supported (only on BeOS).
		external "C"
		alias "const_so_sndbuf"
		end


feature -- IP type-of-service options

	IP_TOS: INTEGER
		external "C"
		alias "const_ip_tos"
		end

	IP_TTL: INTEGER
		external "C"
		alias "const_ip_ttl"
		end

	IPTOS_LOWDELAY: INTEGER
		external "C"
		alias "const_iptos_lowdelay"
		end

	IPTOS_THROUGHPUT: INTEGER
		external "C"
		alias "const_iptos_throughput"
		end


feature -- TCP options

	TCP_NODELAY: INTEGER
		external "C"
		alias "const_tcp_nodelay"
		end


feature -- Multicast extensions

	IP_MULTICAST_TTL: INTEGER
		external "C"
		alias "const_ip_multicast_ttl"
		end

	IP_MULTICAST_IF: INTEGER
		external "C"
		alias "const_ip_multicast_if"
		end

	IP_MULTICAST_LOOP: INTEGER
		external "C"
		alias "const_ip_multicast_loop"
		end


feature -- RFC3768

	IP_ADD_MEMBERSHIP: INTEGER
		external "C"
		alias "const_ip_add_membership"
		end

	IP_BLOCK_SOURCE: INTEGER
		external "C"
		alias "const_ip_block_source"
		end

	IP_UNBLOCK_SOURCE: INTEGER
		external "C"
		alias "const_ip_unblock_source"
		end

	IP_DROP_MEMBERSHIP: INTEGER
		external "C"
		alias "const_ip_drop_membership"
		end



feature -- Special IPv4 addresses

	INADDR_ANY: INTEGER = 0
			-- 0.0.0.0

	INADDR_BROADCAST: INTEGER = -1
			-- 255.255.255.255

	INADDR_LOOPBACK: INTEGER = 2130706433
		-- 127.0.0.1


feature -- Available clocks (-1 if not available)

	CLOCK_REALTIME: INTEGER
		external "C"
		alias "const_clock_realtime"
		end

	CLOCK_MONOTONIC: INTEGER
		external "C"
		alias "const_clock_monotonic"
		end

	CLOCK_PROCESS_CPUTIME_ID: INTEGER
		external "C"
		alias "const_clock_process_cputime_id"
		end

	CLOCK_THREAD_CPUTIME_ID: INTEGER
		external "C"
		alias "const_clock_thread_cputime_id"
		end


end
