/*

Access to Standard C stdlib.h

*/

#ifndef _C_STDLIB_H_
#define _C_STDLIB_H_


#include <stdlib.h>
#include "../supportc/eiffel.h"


/* dynamic memory */

EIF_POINTER posix_calloc(EIF_INTEGER nmemb, EIF_INTEGER size);
void posix_free(EIF_POINTER ptr);
EIF_POINTER posix_malloc(EIF_INTEGER size);
EIF_POINTER posix_realloc(EIF_POINTER ptr, EIF_INTEGER size);


/* miscellaneous */

void posix_abort();
void posix_exit(EIF_INTEGER status);
EIF_POINTER posix_getenv(EIF_POINTER name);
EIF_INTEGER posix_system(EIF_POINTER command);


/* pseudo-random numbers */

EIF_INTEGER const_rand_max();
EIF_INTEGER posix_rand();
void posix_srand (EIF_INTEGER seed);


/* constants */

EIF_INTEGER const_exit_failure();
EIF_INTEGER const_exit_success();


#endif /* _C_STDLIB_H_ */
