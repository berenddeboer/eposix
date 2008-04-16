/*

C layer to Windows direct.h

*/


#ifndef _W_DIRECT_H_
#define _W_DIRECT_H_

#include <direct.h>
#ifdef __BORLANDC__
#include <dos.h>
#endif
#include "../supportc/eiffel.h"


/* functions with have a path as argument */

EIF_INTEGER posix_chdir(EIF_POINTER path);
EIF_INTEGER posix_chdrive(EIF_INTEGER drive);
EIF_POINTER posix_getcwd(EIF_POINTER buf, EIF_INTEGER size);
EIF_POINTER posix_getdcwd(EIF_INTEGER drive, EIF_POINTER buffer, EIF_INTEGER maxlen);
EIF_INTEGER posix_getdrive(void);
EIF_INTEGER posix_mkdir(EIF_POINTER path);
EIF_INTEGER posix_rmdir(EIF_POINTER path);


#endif /* _W_DIRECT_H_ */
