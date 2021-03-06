#include "s_in.h"


/* network to host byte order conversions */

EIF_INTEGER posix_htons (EIF_INTEGER host16value)
{
  return htons(host16value);
}

EIF_INTEGER posix_ntohs (EIF_INTEGER net16value)
{
  return ntohs(net16value);
}

EIF_INTEGER posix_htonl (EIF_INTEGER host32value)
{
  return htonl(host32value);
}

EIF_INTEGER posix_ntohl (EIF_INTEGER net32value)
{
  return ntohl(net32value);
}


/* socket levels for getsockopt */

/* IPPROTO_IP and IPPROTO_RAW not recognized on BeOS */


EIF_INTEGER const_ipproto_ip() {
#ifdef IPPROTO_IP
  return IPPROTO_IP;
#else
  return 0;
#endif
}

EIF_INTEGER const_ipproto_ipv6() {
#ifdef IPPROTO_IPV6
  return IPPROTO_IPV6;
#else
    return 0;
#endif
}

EIF_INTEGER const_ipproto_icmp() {
  return IPPROTO_ICMP;
}

EIF_INTEGER const_ipproto_icmpv6() {
#ifdef IPPROTO_ICMPV6
  return IPPROTO_ICMPV6;
#else
    return 0;
#endif
}

EIF_INTEGER const_ipproto_raw() {
#ifdef IPPROTO_RAW
  return IPPROTO_RAW;
#else
  return 0;
#endif
}

EIF_INTEGER const_ipproto_tcp() {
  return IPPROTO_TCP;
}

EIF_INTEGER const_ipproto_udp() {
  return IPPROTO_UDP;
}


/* socket level options at the IP level */

EIF_INTEGER const_ip_tos() {
#ifdef IP_TOS
  return IP_TOS;
#else
  return 0;
#endif
}

EIF_INTEGER const_ip_ttl() {
#ifdef IP_TTL
  return IP_TTL;
#else
  return 0;
#endif
}


/* Multicast extensions, not in SUS */

EIF_INTEGER const_ip_multicast_ttl() {
#ifdef IP_MULTICAST_TTL
  return IP_MULTICAST_TTL;
#else
  return 0;
#endif
}

EIF_INTEGER const_ip_multicast_if() {
#ifdef IP_MULTICAST_IF
  return IP_MULTICAST_IF;
#else
  return 0;
#endif
}

EIF_INTEGER const_ip_multicast_loop() {
#ifdef IP_MULTICAST_LOOP
  return IP_MULTICAST_LOOP;
#else
  return 0;
#endif
}


/* RFC3768 socket level options */

EIF_INTEGER const_ip_add_membership() {
#ifdef IP_ADD_MEMBERSHIP
  return IP_ADD_MEMBERSHIP;
#else
  return 0;
#endif
}

EIF_INTEGER const_ip_block_source() {
#ifdef IP_BLOCK_SOURCE
  return IP_BLOCK_SOURCE;
#else
  return 0;
#endif
}

EIF_INTEGER const_ip_unblock_source() {
#ifdef IP_UNBLOCK_SOURCE
  return IP_UNBLOCK_SOURCE;
#else
  return 0;
#endif
}

EIF_INTEGER const_ip_drop_membership() {
#ifdef IP_DROP_MEMBERSHIP
  return IP_DROP_MEMBERSHIP;
#else
  return 0;
#endif
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

#ifdef AF_INET6
EIF_INTEGER posix_in6_addr_size()
{
   return (sizeof (struct in6_addr));
}

EIF_POINTER posix_in6_addr_s6_addr(struct in6_addr *p)
{
  return p->s6_addr;
}

void posix_set_in6_addr_s6_addr(struct in6_addr *p, EIF_POINTER my_s6_addr)
{
  memmove (&p->s6_addr, my_s6_addr, (sizeof (struct in6_addr)));
}
#else
EIF_INTEGER posix_in6_addr_size()
{
   return 0;
}

EIF_POINTER posix_in6_addr_s6_addr(EIF_POINTER p)
{
  return NULL;
}

void posix_set_in6_addr_s6_addr(EIF_POINTER p, EIF_POINTER my_s6_addr)
{
}
#endif


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

#ifdef AF_INET6
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
  return (EIF_INTEGER) (p->sin6_scope_id);
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
  memcpy(&(p->sin6_addr), sin_addr, sizeof(struct in6_addr));
}
#else
EIF_INTEGER posix_sockaddr_in6_size()
{
   return 0;
}

EIF_INTEGER posix_sockaddr_in6_sin6_family(EIF_POINTER p)
{
  return 0;
}

EIF_INTEGER posix_sockaddr_in6_sin6_port(EIF_POINTER p)
{
  return 0;
}

EIF_POINTER posix_sockaddr_in6_sin6_addr(EIF_POINTER p)
{
  return NULL;
}

EIF_INTEGER posix_sockaddr_in6_sin6_scope_id(EIF_POINTER p)
{
  return 0;
}


void posix_set_sockaddr_in6_sin6_family(EIF_POINTER p, EIF_INTEGER sin_family)
{
}

void posix_set_sockaddr_in6_sin6_port(EIF_POINTER p, EIF_INTEGER sin_port)
{
}

void posix_set_sockaddr_in6_sin6_addr(EIF_POINTER p, EIF_POINTER sin_addr)
{
}
#endif


/* struct ip_mreq */

EIF_INTEGER posix_ip_mreq_size()
{
#ifdef HAVE_STRUCT_IP_MREQN
   return (sizeof (struct ip_mreqn));
#elif HAVE_STRUCT_IP_MREQ
   return (sizeof (struct ip_mreq));
#else
   return 0;
#endif
}

#ifdef HAVE_STRUCT_IP_MREQN
EIF_POINTER posix_ip_mreq_imr_multiaddr(struct ip_mreqn *p) {
  return &p->imr_multiaddr;
}

EIF_POINTER posix_ip_mreq_imr_interface(struct ip_mreqn *p) {
  return &p->imr_address;
}


void posix_set_ip_mreq_imr_multiaddr(struct ip_mreqn *p, EIF_POINTER imr_multiaddr)
{
  memmove (&p->imr_multiaddr, imr_multiaddr, (sizeof (struct in_addr)));
}

void posix_set_ip_mreq_imr_interface(struct ip_mreqn *p, EIF_POINTER imr_interface)
{
  memmove (&p->imr_address, imr_interface, (sizeof (struct in_addr)));
}

#else

EIF_POINTER posix_ip_mreq_imr_multiaddr(struct ip_mreq *p)
{
  return (EIF_POINTER) &p->imr_multiaddr;
}

EIF_POINTER posix_ip_mreq_imr_interface(struct ip_mreq *p)
{
  return (EIF_POINTER) &p->imr_interface;
}


void posix_set_ip_mreq_imr_multiaddr(struct ip_mreq *p, EIF_POINTER imr_multiaddr)
{
  memmove (&p->imr_multiaddr, imr_multiaddr, (sizeof (struct in_addr)));
}

void posix_set_ip_mreq_imr_interface(struct ip_mreq *p, EIF_POINTER imr_interface)
{
  memmove (&p->imr_interface, imr_interface, (sizeof (struct in_addr)));
}

#endif
