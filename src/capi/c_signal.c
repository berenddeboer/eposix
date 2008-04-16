#include "c_signal.h"

/* functions */

EIF_POINTER posix_signal(EIF_INTEGER sig, void (*func)(int))
{
  return (EIF_POINTER) signal(sig, func);
}

EIF_INTEGER posix_raise(EIF_INTEGER sig)
{
  return raise(sig);
}


/* constants */

EIF_POINTER const_sig_dfl()
{
  return (EIF_POINTER) SIG_DFL;
}

EIF_POINTER const_sig_err()
{
  return (EIF_POINTER) SIG_ERR;
}

EIF_POINTER const_sig_ign()
{
  return (EIF_POINTER) SIG_IGN;
}


EIF_INTEGER const_sigabrt()
{
  return SIGABRT;
}

EIF_INTEGER const_sigfpe()
{
  return SIGFPE;
}

EIF_INTEGER const_sigill()
{
  return SIGILL;
}

EIF_INTEGER const_sigint()
{
  return SIGINT;
}

EIF_INTEGER const_sigsegv()
{
  return SIGSEGV;
}

EIF_INTEGER const_sigterm()
{
  return SIGTERM;
}
