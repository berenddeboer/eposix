/*

Access to Posix sys/wait.h header

*/


#ifndef _P_WAIT_H_
#define _P_WAIT_H_


#include "p_defs.h"
#include <sys/wait.h>
#include "../supportc/eiffel.h"


/* functions */

EIF_INTEGER posix_wait(EIF_POINTER statloc);
EIF_INTEGER posix_waitpid(EIF_INTEGER pid, EIF_POINTER statloc, EIF_INTEGER options);


/* statloc evaluation macro's */

EIF_INTEGER posix_wexitstatus(EIF_INTEGER stat_value);
EIF_BOOLEAN posix_wifexited(EIF_INTEGER stat_value);
EIF_BOOLEAN posix_wifsignaled(EIF_INTEGER stat_value);
EIF_INTEGER posix_wifstopped(EIF_INTEGER stat_value);
EIF_BOOLEAN posix_wstopsig(EIF_INTEGER stat_value);
EIF_BOOLEAN posix_wtermsig(EIF_INTEGER stat_value);


/* options to waitpid */

EIF_INTEGER const_wnohang();
EIF_INTEGER const_wuntraced();


#endif /* _P_WAIT_H_ */
