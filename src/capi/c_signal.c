#include "c_signal.h"

/* C functions */

EIF_POINTER posix_signal(EIF_INTEGER sig, void (*func)(int))
{
  return (EIF_POINTER) signal(sig, func);
}

EIF_INTEGER posix_raise(EIF_INTEGER sig)
{
  return raise(sig);
}


/* custom signal handlers */

int posix_custom_1_signalled = 0;
int posix_custom_2_signalled = 0;

void posix_sig_handler_1 (int signum) {
  posix_custom_1_signalled = 1;
}

void posix_sig_handler_2 (int signum) {
  posix_custom_2_signalled = 1;
}

void posix_enable_custom_signal_handler_1 (EIF_INTEGER sig) {
  posix_custom_1_signalled = 0;
#ifdef _WIN32
  signal (sig, posix_sig_handler_1);
#else
  int *ptr;
  struct sigaction new_action;
  new_action.sa_handler = posix_sig_handler_1;
  new_action.sa_flags = 0;
  sigaction(sig, &new_action, NULL);
#endif
}

EIF_BOOLEAN posix_is_custom_signal_handler_1_signalled (EIF_INTEGER sig) {
  int r;
  // Retrieve value, then reset it. That is not completely signal safe I think.
  // Not sure how to fix this properly. Need an atomitic reset.
  r = posix_custom_1_signalled;
  posix_custom_1_signalled = 0;
  return (EIF_BOOLEAN) r;
}


void posix_enable_custom_signal_handler_2 (EIF_INTEGER sig) {
  posix_custom_2_signalled = 0;
#ifdef _WIN32
  signal (sig, posix_sig_handler_2);
#else
  int *ptr;
  struct sigaction new_action;
  new_action.sa_handler = posix_sig_handler_2;
  new_action.sa_flags = 0;
  sigaction(sig, &new_action, NULL);
#endif
}

EIF_BOOLEAN posix_is_custom_signal_handler_2_signalled (EIF_INTEGER sig) {
  int r;
  // Retrieve value, then reset it. That is not completely signal safe I think.
  // Not sure how to fix this properly. Need an atomitic reset.
  r = posix_custom_2_signalled;
  posix_custom_2_signalled = 0;
  return (EIF_BOOLEAN) r;
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
