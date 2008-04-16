/*

Interface to string.h

*/

#ifndef _C_STRING_H_
#define _C_STRING_H_

#include <string.h>
#include "../supportc/eiffel.h"


EIF_INTEGER posix_memcmp(EIF_POINTER s1, EIF_POINTER s2, EIF_INTEGER size);
EIF_POINTER posix_memcpy(EIF_POINTER s1, EIF_POINTER s2, EIF_INTEGER size);
EIF_POINTER posix_memmove(EIF_POINTER s1, EIF_POINTER s2, EIF_INTEGER size);
EIF_POINTER posix_memset(EIF_POINTER s, EIF_INTEGER c, EIF_INTEGER size);
EIF_POINTER posix_strerror(int errnum);


#endif /* _C_STRING_H_ */
