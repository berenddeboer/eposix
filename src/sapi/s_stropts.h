/*

C layer to SUSv3 stropts header

*/


#ifndef _S_STROPTS_H_
#define _S_STROPTS_H_

#include "s_defs.h"

#ifdef HAVE_STROPTS_H
#include <stropts.h>
#else
#ifdef HAVE_SYS_IOCTL_H
#include <sys/ioctl.h>
#else
#include <unistd.h>
#endif
#endif
#include "../supportc/eiffel.h"


/* functions */

EIF_INTEGER posix_ioctl(EIF_INTEGER fildes, EIF_INTEGER request, EIF_POINTER arg);


#endif /* _S_STROPTS_H_ */
