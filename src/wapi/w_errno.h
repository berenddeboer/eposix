/*

C layer to Windows errno.h

*/


#ifndef _W_ERRNO_H_
#define _W_ERRNO_H_

#include <errno.h>
#include "../supportc/eiffel.h"


/* errorcodes */

EIF_INTEGER const_eagain();
EIF_INTEGER const_eintr();


#endif /* _W_ERRNO_H_ */
