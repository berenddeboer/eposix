/*

Access to Single Unix Specification netinet/in.h.

*/

#ifndef _S_IN_H_
#define _S_IN_H_

#include "s_defs.h"

/* FreeBSD likes sys/stat.h */
#include <sys/stat.h>
#include <netinet/in.h>
#include "../supportc/eiffel.h"


/* network to host byte order conversions */

EIF_INTEGER posix_htons (EIF_INTEGER host16value);
EIF_INTEGER posix_ntohs (EIF_INTEGER net16value);
EIF_INTEGER posix_htonl (EIF_INTEGER host32value);
EIF_INTEGER posix_ntohl (EIF_INTEGER net32value);


/* socket levels for [gs]etsockopt */

EIF_INTEGER const_ipproto_ip();
EIF_INTEGER const_ipproto_ipv6();
EIF_INTEGER const_ipproto_icmp();
EIF_INTEGER const_ipproto_icmpv6();
EIF_INTEGER const_ipproto_raw();
EIF_INTEGER const_ipproto_tcp();
EIF_INTEGER const_ipproto_udp();


/* socket level options at the IP level */

EIF_INTEGER const_ip_tos();
EIF_INTEGER const_ip_ttl();


/* struct in_addr */

EIF_INTEGER posix_in_addr_size();

EIF_INTEGER posix_in_addr_s_addr(struct in_addr *p);

void posix_set_in_addr_s_addr(struct in_addr *p, EIF_INTEGER my_s_addr);


/* struct in6_addr */
/* if no in6 support, just hack something: we'll never call it. */

#ifdef AF_INET6
EIF_INTEGER posix_in6_addr_size();

EIF_POINTER posix_in6_addr_s6_addr(struct in6_addr *p);

void posix_set_in6_addr_s6_addr(struct in6_addr *p, EIF_POINTER my_s6_addr);
#else
EIF_INTEGER posix_in6_addr_size();

EIF_POINTER posix_in6_addr_s6_addr(EIF_POINTER p);

void posix_set_in6_addr_s6_addr(EIF_POINTER p, EIF_POINTER my_s6_addr);
#endif


/* struct sockaddr_in */

EIF_INTEGER posix_sockaddr_in_size();

EIF_INTEGER posix_sockaddr_in_sin_family(struct sockaddr_in *p);
EIF_INTEGER posix_sockaddr_in_sin_port(struct sockaddr_in *p);
EIF_POINTER posix_sockaddr_in_sin_addr(struct sockaddr_in *p);

void posix_set_sockaddr_in_sin_family(struct sockaddr_in *p, EIF_INTEGER sin_family);
void posix_set_sockaddr_in_sin_port(struct sockaddr_in *p, EIF_INTEGER sin_port);
void posix_set_sockaddr_in_sin_addr(struct sockaddr_in *p, EIF_POINTER sin_addr);


/* struct sockaddr_in6 */

#ifdef AF_INET6
EIF_INTEGER posix_sockaddr_in6_size();

EIF_INTEGER posix_sockaddr_in6_sin6_family(struct sockaddr_in6 *p);
EIF_INTEGER posix_sockaddr_in6_sin6_port(struct sockaddr_in6 *p);
EIF_POINTER posix_sockaddr_in6_sin6_addr(struct sockaddr_in6 *p);

EIF_INTEGER posix_sockaddr_in6_sin6_scope_id(struct sockaddr_in6 *p);
void posix_set_sockaddr_in6_sin6_family(struct sockaddr_in6 *p, EIF_INTEGER sin_family);
void posix_set_sockaddr_in6_sin6_port(struct sockaddr_in6 *p, EIF_INTEGER sin_port);
void posix_set_sockaddr_in6_sin6_addr(struct sockaddr_in6 *p, EIF_POINTER sin_addr);
#else
EIF_INTEGER posix_sockaddr_in6_size();

EIF_INTEGER posix_sockaddr_in6_sin6_family(EIF_POINTER p);
EIF_INTEGER posix_sockaddr_in6_sin6_port(EIF_POINTER p);
EIF_POINTER posix_sockaddr_in6_sin6_addr(EIF_POINTER p);

EIF_INTEGER posix_sockaddr_in6_sin6_scope_id(EIF_POINTER p);
void posix_set_sockaddr_in6_sin6_family(EIF_POINTER p, EIF_INTEGER sin_family);
void posix_set_sockaddr_in6_sin6_port(EIF_POINTER p, EIF_INTEGER sin_port);
void posix_set_sockaddr_in6_sin6_addr(EIF_POINTER p, EIF_POINTER sin_addr);
#endif


#endif /* _S_IN_H_ */
