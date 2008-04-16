/*

Access to Posix extensions of signal.h header

*/


#ifndef _P_SIGNAL_H_
#define _P_SIGNAL_H_

#include "p_defs.h"
#include <unistd.h>
#include <signal.h>
#include "../supportc/eiffel.h"


/* functions */

EIF_INTEGER posix_kill(EIF_INTEGER pid, EIF_INTEGER sig);
EIF_INTEGER posix_sigaction(int sig, EIF_POINTER act, EIF_POINTER oact);

EIF_INTEGER posix_sigaddset (EIF_POINTER set, EIF_INTEGER signo);
EIF_INTEGER posix_sigdelset (EIF_POINTER set, EIF_INTEGER signo);
EIF_INTEGER posix_sigemptyset (EIF_POINTER set);
EIF_INTEGER posix_sigfillset (EIF_POINTER set);
EIF_INTEGER posix_sigismember (EIF_POINTER set, EIF_INTEGER signo);
EIF_INTEGER posix_sigpending (EIF_POINTER set);
EIF_INTEGER posix_sigprocmask (EIF_INTEGER how, EIF_POINTER new_set, EIF_POINTER old_set);
EIF_INTEGER posix_sigsuspend (EIF_POINTER set);


/* constants */

EIF_INTEGER const_sa_nocldstop();

EIF_INTEGER const_sigalrm();
EIF_INTEGER const_sighup();
EIF_INTEGER const_sigkill();
EIF_INTEGER const_sigpipe();
EIF_INTEGER const_sigquit();
EIF_INTEGER const_sigchld();
EIF_INTEGER const_sigcont();
EIF_INTEGER const_sigstop();
EIF_INTEGER const_sigtstp();
EIF_INTEGER const_sigttin();
EIF_INTEGER const_sigttou();


/* struct sigaction */

EIF_INTEGER posix_sigaction_size();

EIF_POINTER posix_sa_handler(struct sigaction *act);
EIF_POINTER posix_sa_mask(struct sigaction *act);
EIF_INTEGER posix_sa_flags(struct sigaction *act);

void posix_set_sa_handler(struct sigaction *act, EIF_POINTER handler);
void posix_set_sa_flags(struct sigaction *act, EIF_INTEGER flags);


/* sigset */

EIF_INTEGER posix_sigset_size();


/* sigprocmask how values */

EIF_INTEGER const_sig_block();
EIF_INTEGER const_sig_unblock();
EIF_INTEGER const_sig_setmask();


#if (_POSIX_VERSION >= 199506L)

/* struct sigevent */

EIF_INTEGER posix_sigevent_size();

EIF_INTEGER posix_sigevent_sigev_notify(struct sigevent *p);
EIF_INTEGER posix_sigevent_sigev_signo(struct sigevent *p);

void posix_set_sigevent_sigev_notify(struct sigevent *p, EIF_INTEGER notify);
void posix_set_sigevent_sigev_signo(struct sigevent *p, EIF_INTEGER signo);

/* notify values */

EIF_INTEGER const_sigev_none();
EIF_INTEGER const_sigev_signal();
EIF_INTEGER const_sigev_thread();

#endif


#endif /* _P_SIGNAL_H_ */
