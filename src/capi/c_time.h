/*

C layer to Standard C time.h header

assumes sizeof(time_t) > sizeof(EIF_INTEGER)
assumes sizeof(clock_t) > sizeof(EIF_INTEGER)

due to my lack of C skills I was not able to check this at compile
time. If some kind soul can help me with this??

*/

#ifndef _C_TIME_H_
#define _C_TIME_H_

#if HAVE_CONFIG_H
#include <config.h>
#endif

#include "../supportc/eiffel.h"

#ifdef TM_IN_SYS_TIME
#include <sys/time.h>
#else
#include <time.h>
#endif



EIF_POINTER posix_asctime(EIF_POINTER timeptr);
EIF_INTEGER posix_clock();
EIF_DOUBLE posix_difftime(EIF_INTEGER time1, EIF_INTEGER time0);
EIF_POINTER posix_gmtime(EIF_INTEGER timer);
EIF_POINTER posix_localtime(EIF_INTEGER timer);
EIF_INTEGER posix_mktime(EIF_POINTER timeptr);
EIF_INTEGER posix_strftime(EIF_POINTER s, EIF_INTEGER maxsize, EIF_POINTER format, EIF_POINTER timeptr);
EIF_INTEGER posix_time();

EIF_INTEGER posix_tm_size();

EIF_INTEGER posix_tm_hour(struct tm *t);
EIF_INTEGER posix_tm_mday(struct tm *t);
EIF_INTEGER posix_tm_min(struct tm *t);
EIF_INTEGER posix_tm_mon(struct tm *t);
EIF_INTEGER posix_tm_sec(struct tm *t);
EIF_INTEGER posix_tm_yday(struct tm *t);
EIF_INTEGER posix_tm_year(struct tm *t);
EIF_INTEGER posix_tm_wday(struct tm *t);
EIF_INTEGER posix_tm_isdst(struct tm *t);

void posix_set_tm_date(struct tm *t, EIF_INTEGER year, EIF_INTEGER mon, EIF_INTEGER mday);
void posix_set_tm_time(struct tm *t, EIF_INTEGER hour, EIF_INTEGER min, EIF_INTEGER sec);
void posix_set_tm_isdst (struct tm *t, EIF_INTEGER isdst);


/* constants */

EIF_INTEGER const_clocks_per_sec();


#endif /* _C_TIME_H_ */
