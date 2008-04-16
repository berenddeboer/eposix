#include "s_time.h"

EIF_INTEGER posix_clock_getres(EIF_INTEGER clock_id, EIF_POINTER res)
{
#ifdef HAVE_STRUCT_TIMESPEC_TV_NSEC
  return clock_getres (clock_id, (struct timespec *) res);
#else
  return ENOSYS;
#endif
}

EIF_INTEGER posix_clock_gettime(EIF_INTEGER clock_id, EIF_POINTER tp)
{
#ifdef HAVE_STRUCT_TIMESPEC_TV_NSEC
  return clock_gettime (clock_id, (struct timespec *) tp);
#else
  return ENOSYS;
#endif
}

EIF_INTEGER posix_clock_settime(EIF_INTEGER clock_id, EIF_POINTER tp)
{
#ifdef HAVE_STRUCT_TIMESPEC_TV_NSEC
  /* cygwin doesn't clock_settime */
#ifndef __CYGWIN__
  return clock_settime (clock_id, (struct timespec *) tp);
#else
  return ENOSYS;
#endif
#else
  return ENOSYS;
#endif
}

EIF_INTEGER posix_gettimeofday(EIF_POINTER tp)
{
  return gettimeofday (tp, NULL);
}

EIF_INTEGER posix_nanosleep(EIF_POINTER rqtp, EIF_POINTER rmtp)
{
#ifdef HAVE_STRUCT_TIMESPEC_TV_NSEC
  return nanosleep ((struct timespec *) rqtp, (struct timespec *) rmtp);
#else
  return ENOSYS;
#endif
}


/* helper */

EIF_BOOLEAN posix_have_realtime_clock()
{
#ifdef CLOCK_REALTIME
  return 1;
#else
  return 0;
#endif
}


/* struct timeval */

EIF_INTEGER posix_timeval_size()
{
   return (sizeof (struct timeval));
}

EIF_INTEGER posix_timeval_tv_sec(struct timeval *p)
{
  return p->tv_sec;
}

EIF_INTEGER posix_timeval_tv_usec(struct timeval *p)
{
  return p->tv_usec;
}


void posix_set_timeval_tv_sec(struct timeval *p, EIF_INTEGER tv_sec)
{
  p->tv_sec = tv_sec;
}

void posix_set_timeval_tv_usec(struct timeval *p, EIF_INTEGER tv_usec)
{
  p->tv_usec = tv_usec;
}


/* struct timespec */

EIF_INTEGER posix_timespec_size()
{
   return (sizeof (struct timespec));
}

EIF_INTEGER posix_timespec_tv_sec(struct timespec *p)
{
  return p->tv_sec;
}

EIF_INTEGER posix_timespec_tv_nsec(struct timespec *p)
{
  return p->tv_nsec;
}


void posix_set_timespec_tv_sec(struct timespec *p, EIF_INTEGER tv_sec)
{
  p->tv_sec = (time_t) tv_sec;
}

void posix_set_timespec_tv_nsec(struct timespec *p, EIF_INTEGER tv_nsec)
{
  p->tv_nsec = (long) tv_nsec;
}


/* available clocks */

EIF_INTEGER const_clock_realtime()
{
#ifdef CLOCK_REALTIME
  return CLOCK_REALTIME;
#else
  return -1;
#endif
}

EIF_INTEGER const_clock_monotonic()
{
#ifdef CLOCK_MONOTONIC
  return CLOCK_MONOTONIC;
#else
  return -1;
#endif
}

EIF_INTEGER const_clock_process_cputime_id()
{
#ifdef CLOCK_PROCESS_CPUTIME_ID
  return CLOCK_PROCESS_CPUTIME_ID;
#else
  return -1;
#endif
}

EIF_INTEGER const_clock_thread_cputime_id()
{
#ifdef CLOCK_THREAD_CPUTIME_ID
  return CLOCK_THREAD_CPUTIME_ID;
#else
  return -1;
#endif
}
