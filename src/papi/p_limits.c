#include "p_limits.h"


/* constants */

EIF_INTEGER const_max_input()
{
#ifndef MAX_INPUT
  return _POSIX_MAX_INPUT;
#else
  return MAX_INPUT;
#endif
}

EIF_INTEGER const_name_max()
{
#ifndef NAME_MAX
  return _POSIX_NAME_MAX;
#else
  return NAME_MAX;
#endif
}

EIF_INTEGER const_path_max()
{
#ifndef PATH_MAX
  return _POSIX_PATH_MAX;
#else
  return PATH_MAX;
#endif
}

EIF_INTEGER const_pipe_buf()
{
#ifdef PIPE_BUF
  return PIPE_BUF;
#else
  return _POSIX_PIPE_BUF;
#endif
}

EIF_INTEGER const_ssize_max()
{
  return SSIZE_MAX;
}

EIF_INTEGER const_stream_max()
{
#ifdef STREAM_MAX
  return STREAM_MAX;
#else
#ifdef FOPEN_MAX
  return FOPEN_MAX;
#else
#ifdef _POSIX_STREAM_MAX
  return _POSIX_STREAM_MAX;
#else
  return 8;
#endif
#endif
#endif
}
