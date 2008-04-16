#include "p_signal.h"

/* functions */

EIF_INTEGER posix_kill(EIF_INTEGER pid, EIF_INTEGER sig)
{
  return kill(pid, sig);
}

EIF_INTEGER posix_sigaction(int sig, EIF_POINTER act, EIF_POINTER oact)
{
  return sigaction(sig, (struct sigaction *) act, (struct sigaction *) oact);
}

EIF_INTEGER posix_sigaddset (EIF_POINTER set, EIF_INTEGER signo)
{
  return sigaddset ((sigset_t *) set, signo);
}

EIF_INTEGER posix_sigdelset (EIF_POINTER set, EIF_INTEGER signo)
{
  return sigdelset ((sigset_t *) set, signo);
}

EIF_INTEGER posix_sigemptyset (EIF_POINTER set)
{
  return sigemptyset((sigset_t *) set);
}

EIF_INTEGER posix_sigfillset (EIF_POINTER set)
{
  return sigfillset((sigset_t *) set);
}

EIF_INTEGER posix_sigismember (EIF_POINTER set, EIF_INTEGER signo)
{
  return sigismember((sigset_t *) set, signo);
}

EIF_INTEGER posix_sigpending (EIF_POINTER set)
{
  return sigpending((sigset_t *) set);
}

EIF_INTEGER posix_sigprocmask (EIF_INTEGER how, EIF_POINTER new_set, EIF_POINTER old_set)
{
  return sigprocmask (how, (sigset_t *) new_set, (sigset_t *) old_set);
}

EIF_INTEGER posix_sigsuspend (EIF_POINTER set)
{
  return sigsuspend((sigset_t *) set);
}


/* constants */

EIF_INTEGER const_sa_nocldstop()
{
  return SA_NOCLDSTOP;
}


EIF_INTEGER const_sigalrm()
{
  return SIGALRM;
}

EIF_INTEGER const_sighup()
{
  return SIGHUP;
}

EIF_INTEGER const_sigkill()
{
  return SIGKILL;
}

EIF_INTEGER const_sigpipe()
{
  return SIGPIPE;
}

EIF_INTEGER const_sigquit()
{
  return SIGQUIT;
}

EIF_INTEGER const_sigchld()
{
  return SIGCHLD;
}

EIF_INTEGER const_sigcont()
{
  return SIGCONT;
}

EIF_INTEGER const_sigstop()
{
  return SIGSTOP;
}

EIF_INTEGER const_sigtstp()
{
  return SIGTSTP;
}

EIF_INTEGER const_sigttin()
{
  return SIGTTIN;
}

EIF_INTEGER const_sigttou()
{
  return SIGTTOU;
}



/* struct sigaction */

EIF_INTEGER posix_sigaction_size()
{
  return (sizeof (struct sigaction));
}


EIF_POINTER posix_sa_handler(struct sigaction *act)
{
  return (EIF_POINTER) (act->sa_handler);
}

EIF_POINTER posix_sa_mask(struct sigaction *act)
{
  return (EIF_POINTER) (&(act->sa_mask));
}

EIF_INTEGER posix_sa_flags(struct sigaction *act)
{
  return (act->sa_flags);
}


void posix_set_sa_handler(struct sigaction *act, EIF_POINTER handler)
{
  act->sa_handler = handler;
}

void posix_set_sa_flags(struct sigaction *act, EIF_INTEGER flags)
{
  act->sa_flags = flags;
}


/* sigset */

EIF_INTEGER posix_sigset_size()
{
  return (sizeof (sigset_t));
}


/* sigprocmask how values */

EIF_INTEGER const_sig_block()
{
  return SIG_BLOCK;
}

EIF_INTEGER const_sig_unblock()
{
  return SIG_UNBLOCK;
}

EIF_INTEGER const_sig_setmask()
{
  return SIG_SETMASK;
}


#if (_POSIX_VERSION >= 199506L)

/* struct sigevent */

EIF_INTEGER posix_sigevent_size()
{
   return (sizeof (struct sigevent));
}

EIF_INTEGER posix_sigevent_sigev_notify(struct sigevent *p)
{
  return p->sigev_notify;
}

EIF_INTEGER posix_sigevent_sigev_signo(struct sigevent *p)
{
  return p->sigev_signo;
}


void posix_set_sigevent_sigev_notify(struct sigevent *p, EIF_INTEGER notify)
{
  p->sigev_notify = notify;
}

void posix_set_sigevent_sigev_signo(struct sigevent *p, EIF_INTEGER signo)
{
  p->sigev_signo = signo;
}

/* notify values */

EIF_INTEGER const_sigev_none()
{
  return SIGEV_NONE;
}

EIF_INTEGER const_sigev_signal()
{
  return SIGEV_SIGNAL;
}

EIF_INTEGER const_sigev_thread()
{
#ifdef SIGEV_THREAD
  return SIGEV_THREAD;
#else
  return 0;
#endif
}

#endif

