/*

Access to Single Unix Specification sys/un.h

*/

#ifndef _S_UN_H_
#define _S_UN_H_

#include "s_defs.h"

#ifdef HAVE_SYS_UN_H

/* FreeBSD likes unistd.h here */
#include <unistd.h>
#include <sys/un.h>
#include "../supportc/eiffel.h"


/* struct sockaddr_un */

EIF_INTEGER posix_sockaddr_un_size();

EIF_INTEGER posix_sockaddr_un_sun_family(struct sockaddr_un *p);
EIF_POINTER posix_sockaddr_un_sun_path(struct sockaddr_un *p);

void posix_set_sockaddr_un_sun_family(struct sockaddr_un *p, EIF_INTEGER sun_family);
void posix_set_sockaddr_un_sun_path(struct sockaddr_un *p, EIF_POINTER sun_path);

#endif

#endif /* _S_UN_H_ */
