/*

Support for calling Eiffel object when C signal occurs.

*/

#ifndef _C_EXIT_HANDLING_H_
#define _C_EXIT_HANDLING_H_

#include "stdlib.h"
#include "eiffel.h"


/* signal handling */

void epx_clear_exit_switch();
void epx_set_exit_switch (EIF_OBJECT a_switch);


#endif /* _C_EXIT_HANDLING_H_ */
