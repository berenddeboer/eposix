#include "w_winsock2.h"


/* initialization */

EIF_INTEGER posix_wsastartup(EIF_INTEGER wVersionRequested, EIF_POINTER lpWSAData)
{
  return WSAStartup((WORD) wVersionRequested, (LPWSADATA) lpWSAData);
}

EIF_INTEGER posix_wsacleanup()
{
  return WSACleanup();
}


/* struct WSAData */

EIF_INTEGER posix_wsadata_size()
{
   return (sizeof (struct WSAData));
}

EIF_INTEGER posix_wsadata_wversion(struct WSAData *p)
{
  return p->wVersion;
}

EIF_INTEGER posix_wsadata_whighversion(struct WSAData *p)
{
  return p->wHighVersion;
}

EIF_POINTER posix_wsadata_szdescription(struct WSAData *p)
{
  return ((EIF_POINTER) &(p->szDescription));
}

EIF_POINTER posix_wsadata_szsystemstatus(struct WSAData *p)
{
  return ((EIF_POINTER) &(p->szSystemStatus));
}


/* Error handling */

EIF_INTEGER posix_wsagetlasterror()
{
  return (WSAGetLastError());
}


/* functions */

EIF_INTEGER posix_accept (EIF_INTEGER socket, EIF_POINTER cli_addr, EIF_POINTER addr_len)
{
  return accept (socket, (struct sockaddr *) cli_addr, (int *) addr_len);
}

EIF_INTEGER posix_bind (EIF_INTEGER socket, EIF_POINTER address, EIF_INTEGER addr_len)
{
  return bind (socket, (struct sockaddr *) address, addr_len);
}

EIF_INTEGER posix_closesocket(EIF_INTEGER s)
{
  return closesocket(s);
}

EIF_INTEGER posix_connect (EIF_INTEGER socket, EIF_POINTER address, EIF_INTEGER addr_len)
{
  return connect (socket, (struct sockaddr *) address, addr_len);
}

EIF_POINTER posix_gethostbyaddr(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER type)
{
  return (EIF_POINTER) gethostbyaddr(addr, len, type);
}

EIF_POINTER posix_gethostbyname(EIF_POINTER hostname)
{
  return ((EIF_POINTER) gethostbyname(hostname));
}

EIF_INTEGER posix_getpeername(EIF_INTEGER socket, EIF_POINTER localaddr, EIF_POINTER addrlen)
{
  return getpeername (socket, (struct sockaddr *) localaddr, (int *) addrlen);
}

EIF_POINTER posix_getservbyname(EIF_POINTER name, EIF_POINTER proto)
{
  return (EIF_POINTER) getservbyname(name, proto);
}

EIF_POINTER posix_getservbyport (EIF_INTEGER port, EIF_POINTER proto)
{
  return (EIF_POINTER) getservbyport(port, proto);
}

EIF_INTEGER posix_getsockname(EIF_INTEGER socket, EIF_POINTER localaddr, EIF_POINTER addrlen)
{
  return getsockname (socket, (struct sockaddr *) localaddr, (int *) addrlen);
}

EIF_INTEGER posix_getsockopt(EIF_INTEGER socket, EIF_INTEGER level, EIF_INTEGER option_name, EIF_POINTER option_value, EIF_POINTER option_len)
{
  return getsockopt(socket, level, option_name, option_value, (int *) option_len);
}

EIF_INTEGER posix_ioctlsocket (EIF_INTEGER a_socket, EIF_INTEGER a_cmd, EIF_POINTER a_argp)
{
  return ioctlsocket (a_socket, a_cmd, (u_long *) a_argp);
}

EIF_INTEGER posix_listen(EIF_INTEGER socket, EIF_INTEGER backlog)
{
  return listen (socket, backlog);
}

EIF_INTEGER posix_recv(EIF_INTEGER socket, EIF_POINTER buf, EIF_INTEGER len, EIF_INTEGER flags)
{
  return recv (socket, buf, len, flags);
}

EIF_INTEGER posix_select(EIF_INTEGER nfds, EIF_POINTER readfds, EIF_POINTER writefds, EIF_POINTER errorfds, EIF_POINTER timeout)
{
  return (select (nfds, (fd_set *) readfds, (fd_set *) writefds, (fd_set *) errorfds,  (struct timeval *) timeout));
}


EIF_INTEGER posix_send(EIF_INTEGER socket, EIF_POINTER buf, EIF_INTEGER len, EIF_INTEGER flags)
{
  return send (socket, buf, len, flags);
}

EIF_INTEGER posix_setsockopt(EIF_INTEGER socket, EIF_INTEGER level, EIF_INTEGER option_name, EIF_POINTER option_value, EIF_INTEGER option_len)
{
  return setsockopt(socket, level, option_name, option_value, option_len);
}

EIF_INTEGER posix_shutdown (EIF_INTEGER sockfd, EIF_INTEGER howto)
{
  return shutdown (sockfd, howto);
}

EIF_INTEGER posix_socket(EIF_INTEGER af, EIF_INTEGER type, EIF_INTEGER protocol)
{
  return socket(af, type, protocol);
}


/* network to host byte order conversions */


EIF_INTEGER posix_htons (EIF_INTEGER host16value)
{
  return htons((u_short) host16value);
}

EIF_INTEGER posix_ntohs (EIF_INTEGER net16value)
{
  return ntohs((u_short) net16value);
}

EIF_INTEGER posix_htonl (EIF_INTEGER host32value)
{
  return htonl(host32value);
}

EIF_INTEGER posix_ntohl (EIF_INTEGER net32value)
{
  return ntohl(net32value);
}


/* ip address conversion functions */

EIF_POINTER posix_inet_ntoa(EIF_POINTER in)
{
  return inet_ntoa(*((struct in_addr *) in));
}

EIF_POINTER posix_inet_ntop(EIF_INTEGER af, EIF_POINTER src, EIF_POINTER dst, EIF_INTEGER size)
{
#ifdef IPPROTO_IPV6
  return NULL;
/* current not implemented in Windows:
  return ((EIF_POINTER) inet_ntop (af, (void *) src, (char *) dst, (size_t) size));
*/
#else
  return NULL;
#endif
}


/* file descriptor set operations */

void posix_fd_clr(EIF_INTEGER fd, EIF_POINTER fdset)
{
  FD_CLR (fd, (fd_set *) fdset);
}

EIF_BOOLEAN posix_fd_isset(EIF_INTEGER fd, EIF_POINTER fdset)
{
  return (FD_ISSET (fd, (fd_set *) fdset));
}

void posix_fd_set(EIF_INTEGER fd, EIF_POINTER fdset)
{
  FD_SET (fd, (fd_set *) fdset);
}

void posix_fd_zero(EIF_POINTER fdset)
{
  FD_ZERO ((fd_set *) fdset);
}


/* struct fd_set size */

EIF_INTEGER posix_fd_set_size ()
{
  return (sizeof (fd_set));
}


/* struct in_addr */

EIF_INTEGER posix_in_addr_size()
{
   return (sizeof (struct in_addr));
}

EIF_INTEGER posix_in_addr_s_addr(struct in_addr *p)
{
  return p->s_addr;
}

void posix_set_in_addr_s_addr(struct in_addr *p, EIF_INTEGER my_s_addr)
{
  p->s_addr = my_s_addr;
}


/* struct in6_addr */

EIF_INTEGER posix_in6_addr_size()
{
#ifdef IPPROTO_IPV6
   return (sizeof (struct in6_addr));
#else
   return 0;
#endif
}

EIF_POINTER posix_in6_addr_s6_addr(struct in6_addr *p)
{
#ifdef IPPROTO_IPV6
  return p->s6_addr;
#else
  return NULL;
#endif
}

void posix_set_in6_addr_s6_addr(struct in6_addr *p, EIF_POINTER my_s6_addr)
{
#ifdef IPPROTO_IPV6
  memmove (p->s6_addr, my_s6_addr, (sizeof (struct in6_addr)));
#endif
}


/* struct sockaddr */

EIF_INTEGER posix_sockaddr_size()
{
   return (sizeof (struct sockaddr));
}

EIF_INTEGER posix_sockaddr_sa_family(struct sockaddr *p)
{
  return p->sa_family;
}

EIF_POINTER posix_sockaddr_sa_data(struct sockaddr *p)
{
  return (EIF_POINTER) &(p->sa_data);
}


void posix_set_sockaddr_sa_family(struct sockaddr *p, EIF_INTEGER sa_family)
{
  p->sa_family = sa_family;
}


/* struct sockaddr_in */

EIF_INTEGER posix_sockaddr_in_size()
{
   return (sizeof (struct sockaddr_in));
}

EIF_INTEGER posix_sockaddr_in_sin_family(struct sockaddr_in *p)
{
  return p->sin_family;
}

EIF_INTEGER posix_sockaddr_in_sin_port(struct sockaddr_in *p)
{
  return p->sin_port;
}

EIF_POINTER posix_sockaddr_in_sin_addr(struct sockaddr_in *p)
{
  return (EIF_POINTER) & (p->sin_addr);
}


void posix_set_sockaddr_in_sin_family(struct sockaddr_in *p, EIF_INTEGER sin_family)
{
  p->sin_family = sin_family;
}

void posix_set_sockaddr_in_sin_port(struct sockaddr_in *p, EIF_INTEGER sin_port)
{
  p->sin_port = sin_port;
}

void posix_set_sockaddr_in_sin_addr(struct sockaddr_in *p, EIF_POINTER sin_addr)
{
  memcpy(&(p->sin_addr), sin_addr, sizeof(struct in_addr));
}


/* struct sockaddr_in6 */

EIF_INTEGER posix_sockaddr_in6_size()
{
   return (sizeof (struct sockaddr_in6));
}

EIF_INTEGER posix_sockaddr_in6_sin6_family(struct sockaddr_in6 *p)
{
  return p->sin6_family;
}

EIF_INTEGER posix_sockaddr_in6_sin6_port(struct sockaddr_in6 *p)
{
  return p->sin6_port;
}

EIF_POINTER posix_sockaddr_in6_sin6_addr(struct sockaddr_in6 *p)
{
  return (EIF_POINTER) & (p->sin6_addr);
}

EIF_INTEGER posix_sockaddr_in6_sin6_scope_id(struct sockaddr_in6 *p)
{
  /* it seems VC98 does not have this definition. It is in Borland's BCC 5.5
     included with ISE 5.3. As I don't use it, just return 0 for now.
     return (EIF_INTEGER) (p->sin6_scope_id); */
  return 0;
}


void posix_set_sockaddr_in6_sin6_family(struct sockaddr_in6 *p, EIF_INTEGER sin_family)
{
  p->sin6_family = sin_family;
}

void posix_set_sockaddr_in6_sin6_port(struct sockaddr_in6 *p, EIF_INTEGER sin_port)
{
  p->sin6_port = sin_port;
}

void posix_set_sockaddr_in6_sin6_addr(struct sockaddr_in6 *p, EIF_POINTER sin_addr)
{
#ifdef IPPROTO_IPV6
  memcpy(&(p->sin6_addr), sin_addr, sizeof(struct in6_addr));
#endif
}


/* struct hostent */

EIF_INTEGER posix_hostent_size()
{
   return (sizeof (struct hostent));
}

EIF_POINTER posix_hostent_h_name(struct hostent *p)
{
  return p->h_name;
}


EIF_POINTER posix_hostent_h_aliases(struct hostent *p)
{
  return (EIF_POINTER) (p->h_aliases);
}

EIF_INTEGER posix_hostent_h_addrtype(struct hostent *p)
{
  return p->h_addrtype;
}

EIF_INTEGER posix_hostent_h_length(struct hostent *p)
{
  return p->h_length;
}

EIF_POINTER posix_hostent_h_addr_list(struct hostent *p)
{
  return (EIF_POINTER) (p->h_addr_list);
}


/* struct servent */

EIF_INTEGER posix_servent_size()
{
   return (sizeof (struct servent));
}

EIF_POINTER posix_servent_s_name(struct servent *p)
{
  return p->s_name;
}

EIF_POINTER posix_servent_s_aliases(struct servent *p)
{
  return (EIF_POINTER) (p->s_aliases);
}

EIF_INTEGER posix_servent_s_port(struct servent *p)
{
  return p->s_port;
}

EIF_POINTER posix_servent_s_proto(struct servent *p)
{
  return p->s_proto;
}


/* struct timeval */

EIF_INTEGER posix_timeval_size()
{
   return (sizeof (struct timeval));
}

EIF_INTEGER posix_timeval_tv_sec(struct timeval *p)
{
  return p->tv_sec;
}

EIF_INTEGER posix_timeval_tv_usec(struct timeval *p)
{
  return p->tv_usec;
}


void posix_set_timeval_tv_sec(struct timeval *p, EIF_INTEGER tv_sec)
{
  p->tv_sec = tv_sec;
}

void posix_set_timeval_tv_usec(struct timeval *p, EIF_INTEGER tv_usec)
{
  p->tv_usec = tv_usec;
}


/* protocol families */

EIF_INTEGER const_af_inet()
{
  return AF_INET;
}

EIF_INTEGER const_af_inet6()
{
#ifdef AF_INET6
  return AF_INET6;
#else
  return 0;
#endif
}

EIF_INTEGER const_af_unspec()
{
  return AF_UNSPEC;
}


/* socket kinds */

EIF_INTEGER const_sock_dgram()
{
  return SOCK_DGRAM;
}

EIF_INTEGER const_sock_raw()
{
#ifdef SOCK_RAW
  return SOCK_RAW;
#else
  return -1;
#endif
}

EIF_INTEGER const_sock_seqpacket()
{
#ifdef SOCK_SEQPACKET
  return SOCK_SEQPACKET;
#else
  return -1;
#endif
}

EIF_INTEGER const_sock_stream()
{
  return SOCK_STREAM;
}


/* shutdown options */

EIF_INTEGER const_shut_rd()
{
#ifdef SHUT_RD
  return SHUT_RD;
#else
  return 0;
#endif
}

EIF_INTEGER const_shut_rdwr()
{
#ifdef SHUT_RDWR
  return SHUT_RDWR;
#else
  return 2;
#endif
}

EIF_INTEGER const_shut_wr()
{
#ifdef SHUT_WR
  return SHUT_WR;
#else
  return 1;
#endif
}


/* other constants */

EIF_INTEGER const_somaxconn()
{
  return SOMAXCONN;
}


/* ioctl socket commands */

EIF_INTEGER const_fionbio()
{
  return FIONBIO;
}

/* constants */

EIF_INTEGER const_fd_setsize()
{
  return FD_SETSIZE;
}
