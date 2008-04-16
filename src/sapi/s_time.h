/*

C layer to SUS extensions to the SUSv3 sys/time.h header

*/

#ifndef _S_TIME_H_
#define _S_TIME_H_

#include "s_defs.h"
#include <sys/time.h>

/* We really need time.h, but if not TIME_WITH_SYS_TIME I suppose the
   clock_XXXX functions won't work anyway. */
#ifdef TIME_WITH_SYS_TIME
#include <time.h>
#endif

/* return ENOSYS for BeOS for nanosleep and such */
#ifndef HAVE_STRUCT_TIMESPEC_TV_NSEC
#include <errno.h>
#endif
#ifdef __CYGWIN__
#include <errno.h>
#endif

#include "../supportc/eiffel.h"


/* various */

EIF_INTEGER posix_clock_getres(EIF_INTEGER clock_id, EIF_POINTER res);
EIF_INTEGER posix_clock_gettime(EIF_INTEGER clock_id, EIF_POINTER tp);
EIF_INTEGER posix_clock_settime(EIF_INTEGER clock_id, EIF_POINTER tp);
EIF_INTEGER posix_gettimeofday(EIF_POINTER tp);
EIF_INTEGER posix_nanosleep(EIF_POINTER rqtp, EIF_POINTER rmtp);


/* helper */

EIF_BOOLEAN posix_have_realtime_clock();


/* struct timeval */

EIF_INTEGER posix_timeval_size();

EIF_INTEGER posix_timeval_tv_sec(struct timeval *p);
EIF_INTEGER posix_timeval_tv_usec(struct timeval *p);

void posix_set_timeval_tv_sec(struct timeval *p, EIF_INTEGER tv_sec);
void posix_set_timeval_tv_usec(struct timeval *p, EIF_INTEGER tv_usec);


/* struct timespec */

/* BeOS doesn't have timespec, so hack my way around it */

#ifndef HAVE_STRUCT_TIMESPEC_TV_NSEC
struct timespec
  {
    time_t tv_sec;		/* Seconds.  */
    long int tv_nsec;		/* Nanoseconds.  */
  };
#endif

EIF_INTEGER posix_timespec_size();

EIF_INTEGER posix_timespec_tv_sec(struct timespec *p);
EIF_INTEGER posix_timespec_tv_nsec(struct timespec *p);

void posix_set_timespec_tv_sec(struct timespec *p, EIF_INTEGER tv_sec);
void posix_set_timespec_tv_nsec(struct timespec *p, EIF_INTEGER tv_nsec);


/* available clocks */

EIF_INTEGER const_clock_realtime();
EIF_INTEGER const_clock_monotonic();
EIF_INTEGER const_clock_process_cputime_id();
EIF_INTEGER const_clock_thread_cputime_id();


#endif /* _S_TIME_H_ */
