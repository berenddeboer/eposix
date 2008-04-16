#include "p_utime.h"

EIF_INTEGER posix_utime(EIF_POINTER path, EIF_INTEGER actime, EIF_INTEGER modtime)
{
  struct utimbuf times;
  if ( (actime == -1) || (modtime == -1) )
    {
      return utime (path, NULL);
    }
  else
    {
      times.actime = actime;
      times.modtime = modtime;
      return utime (path, &times);
    }
}
