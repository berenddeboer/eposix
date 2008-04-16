/*

Access to Single Unix Specification arpa/inet.h

*/

#ifndef _S_INET_H_
#define _S_INET_H_

#include "s_defs.h"

/* FreeBSD likes sys/stat.h and netinet/in.h */
#include <sys/stat.h>
#include <netinet/in.h>
#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>
#endif
#include "../supportc/eiffel.h"


/* ip address conversion functions */

EIF_POINTER posix_inet_ntoa(EIF_POINTER in);
EIF_POINTER posix_inet_ntop(EIF_INTEGER af, EIF_POINTER src, EIF_POINTER dst, EIF_INTEGER size);


#endif /* _S_INET_H_ */
