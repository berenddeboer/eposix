/*

Support for calling Eiffel object when C signal occurs.

*/

#ifndef _C_SIGNAL_HANDLING_H_
#define _C_SIGNAL_HANDLING_H_

#include "eiffel.h"


/* signal handling */

void epx_clear_signal_switch();
void epx_set_signal_switch (EIF_OBJECT a_switch);
EIF_POINTER epx_signal_handler();


#endif /* _C_SIGNAL_HANDLING_H_ */
