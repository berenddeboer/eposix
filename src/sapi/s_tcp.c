#include "s_tcp.h"

/* socket levels for getsockopt */

EIF_INTEGER const_tcp_nodelay() {
  return TCP_NODELAY;
}
