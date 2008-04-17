/*

Access to Standard C errno.h

*/

#ifndef _C_ERRNO_H_
#define _C_ERRNO_H_


#include "../supportc/eiffel.h"
#include <errno.h>


EIF_INTEGER const_edom();
EIF_INTEGER const_emfile();
EIF_INTEGER const_erange();

void posix_clear_errno();
EIF_INTEGER posix_errno();
void posix_set_errno(EIF_INTEGER new_value);


#endif /* _C_ERRNO_H_ */
