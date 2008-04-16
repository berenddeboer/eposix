/*

C layer to Windows stdio.h

*/


#ifndef _W_STDIO_H_
#define _W_STDIO_H_

#include <stdio.h>
#include "../supportc/eiffel.h"


EIF_POINTER posix_fdopen(EIF_INTEGER fildes, EIF_POINTER type);
EIF_INTEGER posix_fileno(EIF_POINTER stream);


#endif /* _W_STDIO_H_ */
