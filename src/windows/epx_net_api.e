indexing

	description: "Windows specific network API portable at the ABSTRACT_XXXX layer."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_NET_API


inherit

	ANY

	EPX_NET_CONSTANTS

	WAPI_WINSOCK2
		export
			{NONE} all;
			{ANY}
				FD_SETSIZE,
				posix_fd_clr,
				posix_fd_isset,
				posix_fd_set_size,
				posix_fd_set,
				posix_fd_zero,
				posix_getservbyname,
				posix_getservbyport,
				posix_hostent_h_name,
				posix_hostent_h_aliases,
				posix_hostent_h_addrtype,
				posix_hostent_h_length,
				posix_hostent_h_addr_list,
				posix_htonl,
				posix_ntohl,
				posix_htons,
				posix_ntohs,
				posix_in_addr_size,
				posix_in6_addr_size,
				posix_in_addr_s_addr,
				posix_inet_ntoa,
				posix_inet_ntop,
				posix_servent_s_name,
				posix_servent_s_port,
				posix_servent_s_proto,
				posix_servent_s_aliases,
				posix_set_in_addr_s_addr,
				posix_set_in6_addr_s6_addr,
				posix_set_timeval_tv_usec,
				posix_set_timeval_tv_sec,
				posix_sockaddr_in_size,
				posix_sockaddr_in_sin_family,
				posix_sockaddr_in_sin_port,
				posix_sockaddr_in_sin_addr,
				posix_set_sockaddr_in_sin_family,
				posix_set_sockaddr_in_sin_port,
				posix_set_sockaddr_in_sin_addr,
				posix_sockaddr_in6_size,
				posix_sockaddr_in6_sin6_family,
				posix_sockaddr_in6_sin6_port,
				posix_sockaddr_in6_sin6_addr,
				posix_sockaddr_in6_sin6_scope_id,
				posix_set_sockaddr_in6_sin6_family,
				posix_set_sockaddr_in6_sin6_port,
				posix_set_sockaddr_in6_sin6_addr,
				posix_sockaddr_sa_family,
				posix_set_sockaddr_sa_family,
				posix_timeval_size,
				posix_timeval_tv_usec,
				posix_timeval_tv_sec
		end

end
