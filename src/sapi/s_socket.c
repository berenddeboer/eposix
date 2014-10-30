#include "s_socket.h"


/* functions */

EIF_INTEGER posix_accept (EIF_INTEGER socket, EIF_POINTER cli_addr, EIF_POINTER addr_len)
{
  return accept (socket, cli_addr, addr_len);
}

EIF_INTEGER posix_bind (EIF_INTEGER socket, EIF_POINTER address, EIF_INTEGER addr_len)
{
  return bind (socket, (struct sockaddr *) address, addr_len);
}

EIF_INTEGER posix_connect (EIF_INTEGER socket, EIF_POINTER address, EIF_INTEGER addr_len)
{
  return connect (socket, (struct sockaddr *) address, addr_len);
}

EIF_INTEGER posix_getsockname(EIF_INTEGER socket, EIF_POINTER localaddr, EIF_POINTER addrlen)
{
  return getsockname (socket, (struct sockaddr *) localaddr, addrlen);
}

EIF_INTEGER posix_getsockopt(EIF_INTEGER socket, EIF_INTEGER level, EIF_INTEGER option_name, EIF_POINTER option_value, EIF_POINTER option_len)
{
  return getsockopt(socket, level, option_name, option_value, option_len);
}

EIF_INTEGER posix_getpeername(EIF_INTEGER socket, EIF_POINTER localaddr, EIF_POINTER addrlen)
{
  return getpeername (socket, (struct sockaddr *) localaddr, addrlen);
}

EIF_INTEGER posix_listen(EIF_INTEGER socket, EIF_INTEGER backlog)
{
  return listen (socket, backlog);
}

EIF_INTEGER posix_recv(EIF_INTEGER socket, EIF_POINTER buf, EIF_INTEGER len, EIF_INTEGER flags)
{
  return recv (socket, buf, len, flags);
}

EIF_INTEGER posix_recvfrom(EIF_INTEGER socket, EIF_POINTER buf, EIF_INTEGER len, EIF_INTEGER flags, EIF_POINTER src_addr, EIF_POINTER addrlen)
{
  return recvfrom (socket, buf, len, flags, src_addr, addrlen);
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

EIF_INTEGER posix_socket (EIF_INTEGER family, EIF_INTEGER type, EIF_INTEGER protocol)
{
  return socket (family, type, protocol);
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


/* constants */

EIF_INTEGER const_sock_dgram()
{
  return SOCK_DGRAM;
}

EIF_INTEGER const_sock_packet()
{
#ifdef SOCK_PACKET
  return SOCK_PACKET;
#else
  return -1;
#endif
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
  return -1;
#endif
}

EIF_INTEGER const_af_unix()
{
#ifdef AF_UNIX
  return AF_UNIX;
#else
#ifdef AF_UNSPEC
  return AF_UNSPEC;
#else
  return 0;
#endif
#endif
}

EIF_INTEGER const_af_unspec()
{
#ifdef AF_UNSPEC
  return AF_UNSPEC;
#else
  return 0;
#endif
}


/* other constants */

EIF_INTEGER const_somaxconn()
{
#ifdef SOMAXCONN
  return SOMAXCONN;
#else
  return 64;
#endif
}


/* Socket options level */

EIF_INTEGER const_sol_socket()
{
  return SOL_SOCKET;
}


/* SOL_SOCKET option names */

/* SO_RCVBUF and SO_SNDBUF not defined on BeOS */

EIF_INTEGER const_so_rcvbuf()
{
#ifdef SO_RCVBUF
  return SO_RCVBUF;
#else
  return 0;
#endif
}

EIF_INTEGER const_so_reuseaddr()
{
#ifdef __CYGWIN__
  /* Windows screws your system with SO_REUSEADDR: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winsock/winsock/using_so_reuseaddr_and_so_exclusiveaddruse.asp, so prevent SO_REUSEADDR from doing anything with cygwin */
  return 0;
#else
  return SO_REUSEADDR;
#endif
}

EIF_INTEGER const_so_sndbuf()
{
#ifdef SO_SNDBUF
  return SO_SNDBUF;
#else
  return 0;
#endif
}
