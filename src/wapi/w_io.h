/*

C layer to Windows io.h

*/


#ifndef _W_IO_H_
#define _W_IO_H_

#include <io.h>
#include "../supportc/eiffel.h"


/* functions */

EIF_INTEGER posix_access(EIF_POINTER path, EIF_INTEGER mode);
EIF_INTEGER posix_close(EIF_INTEGER fildes);
EIF_INTEGER posix_create(EIF_POINTER path, EIF_INTEGER oflag, EIF_INTEGER mode);
EIF_INTEGER posix_dup(EIF_INTEGER fildes);
EIF_INTEGER posix_dup2(EIF_INTEGER fildes, EIF_INTEGER fildes2);
EIF_BOOLEAN posix_isatty(EIF_INTEGER handle);
EIF_INTEGER posix_lseek(EIF_INTEGER fildes, EIF_INTEGER offset, EIF_INTEGER whence);
EIF_INTEGER posix_open(EIF_POINTER path, EIF_INTEGER oflag);
EIF_INTEGER posix_read(EIF_INTEGER fildes, EIF_POINTER buf, EIF_INTEGER nbyte);
EIF_INTEGER posix_setmode (EIF_INTEGER handle, EIF_INTEGER mode);
EIF_INTEGER posix_write(EIF_INTEGER fildes, EIF_POINTER buf, EIF_INTEGER nbyte);


#endif /* _W_IO_H_ */
