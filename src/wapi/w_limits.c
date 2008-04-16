#include "w_limits.h"

EIF_INTEGER const_arg_max()
{
#ifdef ARG_MAX
  return ARG_MAX;
#else
  return 14500;
#endif
}

EIF_INTEGER const_open_max()
{
#ifdef OPEN_MAX
  return OPEN_MAX;
#else
  return 32;
#endif
}

EIF_INTEGER const_stream_max()
{
#ifdef STREAM_MAX
  return STREAM_MAX;
#else
  return 20;
#endif
}

EIF_INTEGER const_tzname_max()
{
#ifdef TZNAME_MAX
  return TZNAME_MAX;
#else
  return 10;
#endif
}
