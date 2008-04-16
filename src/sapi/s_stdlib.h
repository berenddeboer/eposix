/*

Access to Single Unix Specification additions to stdlib.h

*/

#ifndef _S_STDLIB_H_
#define _S_STDLIB_H_

#include "s_defs.h"
#include <stdlib.h>
#include "../supportc/eiffel.h"


EIF_INTEGER posix_mkstemp(EIF_POINTER template);
EIF_INTEGER posix_putenv(EIF_POINTER string);
EIF_POINTER posix_realpath(EIF_POINTER path, EIF_POINTER resolved_path);


#endif /* _S_STDLIB_H_ */
