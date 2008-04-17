/*

Support for calling Eiffel object when C exit handling occurs.

*/

#ifndef _C_EXIT_HANDLING_H_
#define _C_EXIT_HANDLING_H_

#include "stdlib.h"
#include "../supportc/eiffel.h"


/* exit handling */

void epx_clear_exit_switch();
void epx_set_exit_switch (EIF_POINTER object, EIF_POINTER address);

#endif /* _C_EXIT_HANDLING_H_ */
