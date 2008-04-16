#include "s_inet.h"


/* ip address conversion functions */

EIF_POINTER posix_inet_ntoa(EIF_POINTER in)
{
  return (EIF_POINTER) inet_ntoa(*((struct in_addr *) in));
}

EIF_POINTER posix_inet_ntop(EIF_INTEGER af, EIF_POINTER src, EIF_POINTER dst, EIF_INTEGER size)
{
#ifdef AF_INET6
  return ((EIF_POINTER) inet_ntop (af, (void *) src, (char *) dst, (size_t) size));
#else
  return NULL;
#endif
}
