/*

Access to Single Unix Specification sys/select.h

*/

#ifndef _S_SELECT_H_
#define _S_SELECT_H_

#include "s_defs.h"
#include <sys/time.h>
#ifdef HAVE_SYS_SELECT_H
#include <sys/select.h>
#else
/* happens on BeOS */
#include <sys/socket.h>
#endif
#include "../supportc/eiffel.h"


/* synchronous I/O multiplexing */

EIF_INTEGER posix_select(EIF_INTEGER nfds, EIF_POINTER readfds, EIF_POINTER writefds, EIF_POINTER errorfds, EIF_POINTER timeout);


/* file descriptor set operations */

void posix_fd_clr(EIF_INTEGER fd, EIF_POINTER fdset);
EIF_BOOLEAN posix_fd_isset(EIF_INTEGER fd, EIF_POINTER fdset);
void posix_fd_set(EIF_INTEGER fd, EIF_POINTER fdset);
void posix_fd_zero(EIF_POINTER fdset);


/* struct fd_set size */

EIF_INTEGER posix_fd_set_size ();


/* constants */

EIF_INTEGER const_fd_setsize();


#endif /* _S_SELECT_H_ */
