#include "p_wait.h"


/* functions */

EIF_INTEGER posix_wait(EIF_POINTER statloc)
{
  return wait((int *) statloc);
}


EIF_INTEGER posix_waitpid(EIF_INTEGER pid, EIF_POINTER statloc, EIF_INTEGER options)
{
  return waitpid(pid, (int *) statloc, options);
}


/* statloc evaluation macro's */

EIF_INTEGER posix_wexitstatus(EIF_INTEGER stat_value)
{
  return (WEXITSTATUS(stat_value));
}

EIF_BOOLEAN posix_wifexited(EIF_INTEGER stat_value)
{
  return (WIFEXITED(stat_value));
}

EIF_BOOLEAN posix_wifsignaled(EIF_INTEGER stat_value)
{
  return (WIFSIGNALED(stat_value));
}

EIF_INTEGER posix_wifstopped(EIF_INTEGER stat_value)
{
  return (WIFSTOPPED(stat_value));
}

EIF_BOOLEAN posix_wstopsig(EIF_INTEGER stat_value)
{
  return (WSTOPSIG(stat_value));
}

EIF_BOOLEAN posix_wtermsig(EIF_INTEGER stat_value)
{
  return (WTERMSIG(stat_value));
}


/* options to waitpid */

EIF_INTEGER const_wnohang()
{
  return WNOHANG;
}

EIF_INTEGER const_wuntraced()
{
  return WUNTRACED;
}
