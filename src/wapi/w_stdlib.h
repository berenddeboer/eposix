/*

C layer to Windows stdlib.h

*/


#ifndef _W_STDLIB_H_
#define _W_STDLIB_H_

#include <stdlib.h>
#include "../supportc/eiffel.h"


/* default open mode for streams and file descriptors: binary or text */

EIF_INTEGER posix_fmode();
void posix_set_fmode(EIF_INTEGER value);


#endif /* _W_STDLIB_H_ */
