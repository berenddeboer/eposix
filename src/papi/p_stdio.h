/*

Access to Posix additions to stdio.h

*/

#ifndef _P_STDIO_H_
#define _P_STDIO_H_

#include "p_defs.h"
#include <stdio.h>
#include "../supportc/eiffel.h"


EIF_POINTER posix_fdopen(EIF_INTEGER fildes, EIF_POINTER type);
EIF_INTEGER posix_fileno(EIF_POINTER stream);


#endif /* _P_STDIO_H_ */
