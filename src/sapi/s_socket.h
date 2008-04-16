/*

Access to Single Unix Specification sys/socket.h

*/

#ifndef _S_SOCKET_H_
#define _S_SOCKET_H_

#include "s_defs.h"

/* FreeBSD likes sys/stat.h */
#include <sys/stat.h>
#include <sys/socket.h>
#include "../supportc/eiffel.h"


/* functions */

EIF_INTEGER posix_accept (EIF_INTEGER socket, EIF_POINTER cli_addr, EIF_POINTER addr_len);
EIF_INTEGER posix_bind (EIF_INTEGER socket, EIF_POINTER address, EIF_INTEGER addr_len);
EIF_INTEGER posix_connect (EIF_INTEGER socket, EIF_POINTER address, EIF_INTEGER addr_len);
EIF_INTEGER posix_getsockname(EIF_INTEGER socket, EIF_POINTER localaddr, EIF_POINTER addrlen);
EIF_INTEGER posix_getsockopt(EIF_INTEGER socket, EIF_INTEGER level, EIF_INTEGER option_name, EIF_POINTER option_value, EIF_POINTER option_len);
EIF_INTEGER posix_getpeername(EIF_INTEGER socket, EIF_POINTER localaddr, EIF_POINTER addrlen);
EIF_INTEGER posix_listen(EIF_INTEGER socket, EIF_INTEGER backlog);
EIF_INTEGER posix_recv(EIF_INTEGER socket, EIF_POINTER buf, EIF_INTEGER len, EIF_INTEGER flags);
EIF_INTEGER posix_send(EIF_INTEGER socket, EIF_POINTER buf, EIF_INTEGER len, EIF_INTEGER flags);
EIF_INTEGER posix_setsockopt(EIF_INTEGER socket, EIF_INTEGER level, EIF_INTEGER option_name, EIF_POINTER option_value, EIF_INTEGER option_len);
EIF_INTEGER posix_shutdown (EIF_INTEGER sockfd, EIF_INTEGER howto);
EIF_INTEGER posix_socket (EIF_INTEGER family, EIF_INTEGER type, EIF_INTEGER protocol);


/* struct sockaddr */

EIF_INTEGER posix_sockaddr_size();

EIF_INTEGER posix_sockaddr_sa_family(struct sockaddr *p);
EIF_POINTER posix_sockaddr_sa_data(struct sockaddr *p);

void posix_set_sockaddr_sa_family(struct sockaddr *p, EIF_INTEGER sa_family);


/* constants */

EIF_INTEGER const_sock_dgram();
EIF_INTEGER const_sock_packet();
EIF_INTEGER const_sock_raw();
EIF_INTEGER const_sock_seqpacket();
EIF_INTEGER const_sock_stream();

EIF_INTEGER const_shut_rd();
EIF_INTEGER const_shut_rdwr();
EIF_INTEGER const_shut_wr();


/* protocol families */

EIF_INTEGER const_af_inet();
EIF_INTEGER const_af_inet6();
EIF_INTEGER const_af_unix();
EIF_INTEGER const_af_unspec();


/* other constants */

EIF_INTEGER const_somaxconn();


/* Socket options level */

EIF_INTEGER const_sol_socket();


/* SOL_SOCKET option names */

EIF_INTEGER const_so_rcvbuf();
EIF_INTEGER const_so_reuseaddr();
EIF_INTEGER const_so_sndbuf();


#endif /* _S_SOCKET_H_ */
