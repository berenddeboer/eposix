/*

Access to Standard C signal.h header

*/

#ifndef _C_SIGNAL_H_
#define _C_SIGNAL_H_


#include "../supportc/eiffel.h"
#include <signal.h>


/* functions */

EIF_POINTER posix_signal(EIF_INTEGER sig, void (*func)(int));
EIF_INTEGER posix_raise(EIF_INTEGER sig);


/* constants */

EIF_POINTER const_sig_dfl();
EIF_POINTER const_sig_err();
EIF_POINTER const_sig_ign();

EIF_INTEGER const_sigabrt();
EIF_INTEGER const_sigfpe();
EIF_INTEGER const_sigill();
EIF_INTEGER const_sigint();
EIF_INTEGER const_sigsegv();
EIF_INTEGER const_sigterm();


#endif /* _C_SIGNAL_H_ */
