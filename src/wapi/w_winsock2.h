/*

Access to Windows winsock2.h

*/

#ifndef _W_WINSOCK2_H_
#define _W_WINSOCK2_H_


/* you can set FD_SETSIZE here to a different value than the default
   of 64 if you want to check for more than 64 different descriptors at
   the same time */

#include <winsock2.h>
#include <ws2tcpip.h>
#ifndef IPPROTO_IPV6
/* we don't auto-include this, because we can't detect its presence. */
#ifdef IPV6          // define this to force IPv6 on Windows 2000
#include <tpipv6.h>  // For IPv6 Technology Preview
#endif
#endif
#include "../supportc/eiffel.h"



/* initialization */

EIF_INTEGER posix_wsastartup(EIF_INTEGER wVersionRequested, EIF_POINTER lpWSAData);
EIF_INTEGER posix_wsacleanup();


/* struct WSAData */

EIF_INTEGER posix_wsadata_size();

EIF_INTEGER posix_wsadata_wversion(struct WSAData *p);
EIF_INTEGER posix_wsadata_whighversion(struct WSAData *p);
EIF_POINTER posix_wsadata_szdescription(struct WSAData *p);
EIF_POINTER posix_wsadata_szsystemstatus(struct WSAData *p);


/* Error handling */

EIF_INTEGER posix_wsagetlasterror();


/* functions */

EIF_INTEGER posix_accept (EIF_INTEGER socket, EIF_POINTER cli_addr, EIF_POINTER addr_len);
EIF_INTEGER posix_bind (EIF_INTEGER socket, EIF_POINTER address, EIF_INTEGER addr_len);
EIF_INTEGER posix_closesocket(EIF_INTEGER s);
EIF_INTEGER posix_connect (EIF_INTEGER socket, EIF_POINTER address, EIF_INTEGER addr_len);
EIF_POINTER posix_gethostbyaddr(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER type);
EIF_POINTER posix_gethostbyname(EIF_POINTER hostname);
EIF_INTEGER posix_getpeername(EIF_INTEGER socket, EIF_POINTER localaddr, EIF_POINTER addrlen);
EIF_POINTER posix_getservbyname(EIF_POINTER name, EIF_POINTER proto);
EIF_POINTER posix_getservbyport(EIF_INTEGER port, EIF_POINTER proto);
EIF_INTEGER posix_getsockname(EIF_INTEGER socket, EIF_POINTER localaddr, EIF_POINTER addrlen);
EIF_INTEGER posix_getsockopt(EIF_INTEGER socket, EIF_INTEGER level, EIF_INTEGER option_name, EIF_POINTER option_value, EIF_POINTER option_len);
EIF_INTEGER posix_ioctlsocket (EIF_INTEGER a_socket, EIF_INTEGER a_cmd, EIF_POINTER a_argp);
EIF_INTEGER posix_listen(EIF_INTEGER socket, EIF_INTEGER backlog);
EIF_INTEGER posix_recv(EIF_INTEGER socket, EIF_POINTER buf, EIF_INTEGER len, EIF_INTEGER flags);
EIF_INTEGER posix_select(EIF_INTEGER nfds, EIF_POINTER readfds, EIF_POINTER writefds, EIF_POINTER errorfds, EIF_POINTER timeout);
EIF_INTEGER posix_send(EIF_INTEGER socket, EIF_POINTER buf, EIF_INTEGER len, EIF_INTEGER flags);
EIF_INTEGER posix_setsockopt(EIF_INTEGER socket, EIF_INTEGER level, EIF_INTEGER option_name, EIF_POINTER option_value, EIF_INTEGER option_len);
EIF_INTEGER posix_shutdown (EIF_INTEGER sockfd, EIF_INTEGER howto);
EIF_INTEGER posix_socket(EIF_INTEGER af, EIF_INTEGER type, EIF_INTEGER protocol);


/* network to host byte order conversions */

EIF_INTEGER posix_htons (EIF_INTEGER host16value);
EIF_INTEGER posix_ntohs (EIF_INTEGER net16value);
EIF_INTEGER posix_htonl (EIF_INTEGER host32value);
EIF_INTEGER posix_ntohl (EIF_INTEGER net32value);


/* ip address conversion functions */

EIF_POINTER posix_inet_ntoa(EIF_POINTER in);
EIF_POINTER posix_inet_ntop(EIF_INTEGER af, EIF_POINTER src, EIF_POINTER dst, EIF_INTEGER size);


/* file descriptor set operations */

void posix_fd_clr(EIF_INTEGER fd, EIF_POINTER fdset);
EIF_BOOLEAN posix_fd_isset(EIF_INTEGER fd, EIF_POINTER fdset);
void posix_fd_set(EIF_INTEGER fd, EIF_POINTER fdset);
void posix_fd_zero(EIF_POINTER fdset);


/* struct fd_set size */

EIF_INTEGER posix_fd_set_size ();


/* struct in_addr */

EIF_INTEGER posix_in_addr_size();

EIF_INTEGER posix_in_addr_s_addr(struct in_addr *p);

void posix_set_in_addr_s_addr(struct in_addr *p, EIF_INTEGER my_s_addr);


/* struct in6_addr */

EIF_INTEGER posix_in6_addr_size();

EIF_POINTER posix_in6_addr_s6_addr(struct in6_addr *p);

void posix_set_in6_addr_s6_addr(struct in6_addr *p, EIF_POINTER my_s6_addr);


/* struct sockaddr */

EIF_INTEGER posix_sockaddr_size();

EIF_INTEGER posix_sockaddr_sa_family(struct sockaddr *p);
EIF_POINTER posix_sockaddr_sa_data(struct sockaddr *p);

void posix_set_sockaddr_sa_family(struct sockaddr *p, EIF_INTEGER sa_family);


/* struct sockaddr_in */

EIF_INTEGER posix_sockaddr_in_size();

EIF_INTEGER posix_sockaddr_in_sin_family(struct sockaddr_in *p);
EIF_INTEGER posix_sockaddr_in_sin_port(struct sockaddr_in *p);
EIF_POINTER posix_sockaddr_in_sin_addr(struct sockaddr_in *p);

void posix_set_sockaddr_in_sin_family(struct sockaddr_in *p, EIF_INTEGER sin_family);
void posix_set_sockaddr_in_sin_port(struct sockaddr_in *p, EIF_INTEGER sin_port);
void posix_set_sockaddr_in_sin_addr(struct sockaddr_in *p, EIF_POINTER sin_addr);


/* struct sockaddr_in6 */

EIF_INTEGER posix_sockaddr_in6_size();

EIF_INTEGER posix_sockaddr_in6_sin6_family(struct sockaddr_in6 *p);
EIF_INTEGER posix_sockaddr_in6_sin6_port(struct sockaddr_in6 *p);
EIF_POINTER posix_sockaddr_in6_sin6_addr(struct sockaddr_in6 *p);

EIF_INTEGER posix_sockaddr_in6_sin6_scope_id(struct sockaddr_in6 *p);
void posix_set_sockaddr_in6_sin6_family(struct sockaddr_in6 *p, EIF_INTEGER sin_family);
void posix_set_sockaddr_in6_sin6_port(struct sockaddr_in6 *p, EIF_INTEGER sin_port);
void posix_set_sockaddr_in6_sin6_addr(struct sockaddr_in6 *p, EIF_POINTER sin_addr);


/* struct hostent */

EIF_INTEGER posix_hostent_size();

EIF_POINTER posix_hostent_h_name(struct hostent *p);
EIF_POINTER posix_hostent_h_aliases(struct hostent *p);
EIF_INTEGER posix_hostent_h_addrtype(struct hostent *p);
EIF_INTEGER posix_hostent_h_length(struct hostent *p);
EIF_POINTER posix_hostent_h_addr_list(struct hostent *p);


/* struct servent */

EIF_INTEGER posix_servent_size();

EIF_POINTER posix_servent_s_name(struct servent *p);
EIF_POINTER posix_servent_s_aliases(struct servent *p);
EIF_INTEGER posix_servent_s_port(struct servent *p);
EIF_POINTER posix_servent_s_proto(struct servent *p);


/* struct timeval */

EIF_INTEGER posix_timeval_size();

EIF_INTEGER posix_timeval_tv_sec(struct timeval *p);
EIF_INTEGER posix_timeval_tv_usec(struct timeval *p);

void posix_set_timeval_tv_sec(struct timeval *p, EIF_INTEGER tv_sec);
void posix_set_timeval_tv_usec(struct timeval *p, EIF_INTEGER tv_usec);


/* protocol families */

EIF_INTEGER const_af_inet();
EIF_INTEGER const_af_inet6();
EIF_INTEGER const_af_unspec();


/* socket kinds */

EIF_INTEGER const_sock_dgram();
EIF_INTEGER const_sock_packet();
EIF_INTEGER const_sock_raw();
EIF_INTEGER const_sock_seqpacket();
EIF_INTEGER const_sock_stream();


/* shutdown options */

EIF_INTEGER const_shut_rd();
EIF_INTEGER const_shut_rdwr();
EIF_INTEGER const_shut_wr();


/* other constants */

EIF_INTEGER const_somaxconn();


/* ioctl socket commands */

EIF_INTEGER const_fionbio();


/* constants */

EIF_INTEGER const_fd_setsize();


#endif /* _W_WINSOCK2_H_ */
