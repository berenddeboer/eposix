#include "s_ip.h"

/* IP_TOS specific options for getsockopt/setsockopt */

EIF_INTEGER const_iptos_lowdelay() {
#ifdef IPTOS_LOWDELAY
  return IPTOS_LOWDELAY;
#else
  return 0;
#endif;
}

EIF_INTEGER const_iptos_throughput() {
#ifdef IPTOS_THROUGHPUT
  return IPTOS_THROUGHPUT;
#else
  return 0;
#endif;
}
