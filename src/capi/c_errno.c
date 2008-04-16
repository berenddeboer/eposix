/*

C layer to posix errno variable.

*/


#include "c_errno.h"


EIF_INTEGER const_edom()
{
  return EDOM;
}

EIF_INTEGER const_emfile()
{
#ifdef EMFILE
  return EMFILE;
#else
  return 0
#endif
}

EIF_INTEGER const_erange()
{
  return ERANGE;
}


void posix_clear_errno()
{
  errno = 0;
}

EIF_INTEGER posix_errno()
{
  return errno;
}

void posix_set_errno(EIF_INTEGER new_value)
{
  errno = new_value;
}
