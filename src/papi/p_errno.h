/*

Access to Posix errno.h

*/

#ifndef _P_ERRNO_H_
#define _P_ERRNO_H_

#include "p_defs.h"
#include <errno.h>
#include "../supportc/eiffel.h"


/* error numbers */

EIF_INTEGER const_e2big();
EIF_INTEGER const_eacces();
EIF_INTEGER const_eagain();
EIF_INTEGER const_ebadf();
EIF_INTEGER const_ebadmsg();
EIF_INTEGER const_ebusy();
EIF_INTEGER const_ecanceled();
EIF_INTEGER const_echild();
EIF_INTEGER const_edeadlk();
EIF_INTEGER const_eexist();
EIF_INTEGER const_efault();
EIF_INTEGER const_efbig();
EIF_INTEGER const_einprogress();
EIF_INTEGER const_eintr();
EIF_INTEGER const_einval();
EIF_INTEGER const_eio();
EIF_INTEGER const_eisdir();
EIF_INTEGER const_emlink();
EIF_INTEGER const_emsgsize();
EIF_INTEGER const_enametoolong();
EIF_INTEGER const_enfile();
EIF_INTEGER const_enodev();
EIF_INTEGER const_enoent();
EIF_INTEGER const_enoexec();
EIF_INTEGER const_enolck();
EIF_INTEGER const_enomem();
EIF_INTEGER const_enospc();
EIF_INTEGER const_enosys();
EIF_INTEGER const_enotdir();
EIF_INTEGER const_enotempty();
EIF_INTEGER const_enotsup();
EIF_INTEGER const_enotty();
EIF_INTEGER const_enxio();
EIF_INTEGER const_eperm();
EIF_INTEGER const_epipe();
EIF_INTEGER const_erofs();
EIF_INTEGER const_espipe();
EIF_INTEGER const_esrch();
EIF_INTEGER const_etimedout();
EIF_INTEGER const_exdev();


#endif /* _P_ERRNO_H_ */
