/*

C layer to Standard C time routines

*/

#include "c_time.h"


EIF_POINTER posix_asctime(EIF_POINTER timeptr)
{
  return ((EIF_POINTER) asctime((struct tm *) timeptr));
}


EIF_INTEGER posix_clock()
{
  return clock();
}


EIF_DOUBLE  posix_difftime(time_t time1, time_t time0)
{
  return difftime(time1, time0);
}


EIF_POINTER posix_gmtime(EIF_INTEGER timer)
{
  return ((EIF_POINTER) gmtime((time_t *) &timer));
}


EIF_POINTER posix_localtime(EIF_INTEGER timer)
{
  return ((EIF_POINTER) localtime((time_t *) &timer));
}


EIF_INTEGER posix_mktime(EIF_POINTER timeptr)
{
  return mktime((struct tm *) timeptr);
}


EIF_INTEGER posix_strftime(EIF_POINTER s, EIF_INTEGER maxsize, EIF_POINTER format, EIF_POINTER timeptr)
{
  return strftime (s, maxsize, format, (struct tm *) timeptr);
}


EIF_INTEGER posix_time()
{
  return time(NULL);
}


EIF_INTEGER posix_tm_size()
{
  return (sizeof (struct tm));
}


EIF_INTEGER posix_tm_hour(struct tm *t)
{
  return (t->tm_hour);
}

EIF_INTEGER posix_tm_mday(struct tm *t)
{
  return (t->tm_mday);
}

EIF_INTEGER posix_tm_min(struct tm *t)
{
  return (t->tm_min);
}

EIF_INTEGER posix_tm_mon(struct tm *t)
{
  return (t->tm_mon);
}

EIF_INTEGER posix_tm_sec(struct tm *t)
{
  return (t->tm_sec);
}

EIF_INTEGER posix_tm_yday(struct tm *t)
{
  return (t->tm_yday);
}

EIF_INTEGER posix_tm_year(struct tm *t)
{
  return (t->tm_year);
}

EIF_INTEGER posix_tm_wday(struct tm *t)
{
  return (t->tm_wday);
}

EIF_INTEGER posix_tm_isdst(struct tm *t)
{
  return (t->tm_isdst);
}


void posix_set_tm_date(struct tm *t, EIF_INTEGER year, EIF_INTEGER mon, EIF_INTEGER mday)
{
  t->tm_year = year;
  t->tm_mon = mon;
  t->tm_mday = mday;
}

void posix_set_tm_time(struct tm *t, EIF_INTEGER hour, EIF_INTEGER min, EIF_INTEGER sec)
{
  t->tm_hour = hour;
  t->tm_min = min;
  t->tm_sec = sec;
}

void posix_set_tm_isdst (struct tm *t, EIF_INTEGER isdst)
{
  t->tm_isdst = isdst;
}


/* constants */

EIF_INTEGER const_clocks_per_sec()
{
  return CLOCKS_PER_SEC;
}
