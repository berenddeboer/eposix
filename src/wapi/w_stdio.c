#include "w_stdio.h"

EIF_POINTER posix_fdopen(EIF_INTEGER fildes, EIF_POINTER type)
{
  return ((EIF_POINTER) fdopen(fildes, type));
}

EIF_INTEGER posix_fileno(EIF_POINTER stream)
{
  return fileno((FILE *) stream);
}
