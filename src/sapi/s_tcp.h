/*

Access to Single Unix Specification netinet/tcp.h.

*/

#ifndef _S_TCP_H_
#define _S_TCP_H_

#include "sys/socket.h"
/* FreeBSD likes sys/stat.h */
#include <sys/stat.h>
#include <netinet/in.h>
#include "netinet/tcp.h"
#include "../supportc/eiffel.h"


/* TCP specific options for getsockopt/setsockopt */

EIF_INTEGER const_tcp_nodelay();


#endif
