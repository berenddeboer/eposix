/*

Access to netinet/ip.h.

*/

#ifndef _S_IP_H_
#define _S_IP_H_

// FreeBSD doesn't like this
//#include "s_defs.h"

/* FreeBSD likes sys/types.h */
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#include <netinet/in.h>
#ifdef HAVE_NETINET_IN_SYSTM_H
#include <netinet/in_systm.h>
#endif
#ifdef HAVE_NETINET_IP_H
#include <netinet/ip.h>
#endif
#include "../supportc/eiffel.h"


/* IP_TOS specific options for getsockopt/setsockopt */

EIF_INTEGER const_iptos_lowdelay();
EIF_INTEGER const_iptos_throughput();


#endif
