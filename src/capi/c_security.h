/*

Because certain Eiffel compilers don't allow calling of other
objects in the dispose method, any updating of variables in other objects
has to be done through C code.

Perhaps adopting an object might work as well, but I'm not sure of any
guarantee ragrding this, so I didn't try it.

*/

#ifndef _C_SECURITY_H_
#define _C_SECURITY_H_

#include "../supportc/eiffel.h"


EIF_INTEGER the_posix_open_files = 0;
EIF_INTEGER the_posix_allocated_memory = 0;

/* access */

EIF_INTEGER posix_open_files();
EIF_INTEGER posix_allocated_memory();


/* inc/dec functions */

void posix_decrease_open_files();
void posix_decrease_allocated_memory(EIF_INTEGER amount);
void posix_increase_open_files();
void posix_increase_allocated_memory(EIF_INTEGER amount);


#endif /* _C_SECURITY_H_ */
