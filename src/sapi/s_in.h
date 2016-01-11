/*

Access to Single Unix Specification netinet/in.h.

It also adds support for rfc3678 extensions.

*/

#ifndef _S_IN_H_
#define _S_IN_H_

#include "s_defs.h"

#ifdef HAVE_STRUCT_IP_MREQN
#undef _XOPEN_SOURCE
#endif

#include <arpa/inet.h>
/* FreeBSD likes sys/stat.h */
#include <sys/stat.h>
/* Linux likes <string.h> */
#include <string.h>
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


/* Multicast extensions, not in SUS */

EIF_INTEGER const_ip_multicast_ttl();
EIF_INTEGER const_ip_multicast_if();
EIF_INTEGER const_ip_multicast_loop();


/* RFC3768, not available on all platforms */

EIF_INTEGER const_ip_add_membership();
EIF_INTEGER const_ip_block_source();
EIF_INTEGER const_ip_unblock_source();
EIF_INTEGER const_ip_drop_membership();


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


/* struct ip_mreq */

EIF_INTEGER posix_ip_mreq_size();

#ifndef HAVE_STRUCT_IP_MREQN
#ifndef HAVE_STRUCT_IP_MREQ
struct ip_mreq {
      struct in_addr imr_multiaddr;  /* IP address of group */
      struct in_addr imr_interface;  /* IP address of interface */
   };
#endif
#endif

#ifdef HAVE_STRUCT_IP_MREQN
EIF_POINTER posix_ip_mreq_imr_multiaddr(struct ip_mreqn *p);
EIF_POINTER posix_ip_mreq_imr_interface(struct ip_mreqn *p);

void posix_set_ip_mreq_imr_multiaddr(struct ip_mreqn *p, EIF_POINTER imr_multiaddr);
void posix_set_ip_mreq_imr_interface(struct ip_mreqn *p, EIF_POINTER imr_interface);
#else
EIF_POINTER posix_ip_mreq_imr_multiaddr(struct ip_mreq *p);
EIF_POINTER posix_ip_mreq_imr_interface(struct ip_mreq *p);

void posix_set_ip_mreq_imr_multiaddr(struct ip_mreq *p, EIF_POINTER imr_multiaddr);
void posix_set_ip_mreq_imr_interface(struct ip_mreq *p, EIF_POINTER imr_interface);
#endif


#endif /* _S_IN_H_ */
