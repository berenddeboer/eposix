#include "w_stdlib.h"

EIF_INTEGER posix_fmode()
{
  return _fmode;
}

void posix_set_fmode(EIF_INTEGER value)
{
  _fmode = value;
}
