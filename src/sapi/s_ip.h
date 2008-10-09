/*

Access to netinet/ip.h.

*/

#ifndef _S_IP_H_
#define _S_IP_H_

#include "s_defs.h"

/* FreeBSD likes sys/stat.h */
#include <sys/stat.h>
#include <netinet/in.h>
#ifdef HAVE_NETINET_IP_H
#include <netinet/ip.h>
#endif
#include "../supportc/eiffel.h"


/* IP_TOS specific options for getsockopt/setsockopt */

EIF_INTEGER const_iptos_lowdelay();
EIF_INTEGER const_iptos_throughput();


#endif
