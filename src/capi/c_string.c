/*

C layer to string.h

*/


#include "c_string.h"

EIF_INTEGER posix_memcmp(EIF_POINTER s1, EIF_POINTER s2, EIF_INTEGER size)
{
  return memcmp (s1, s2, size);
}

EIF_POINTER posix_memcpy(EIF_POINTER s1, EIF_POINTER s2, EIF_INTEGER size)
{
  return memcpy(s1, s2, size);
}

EIF_POINTER posix_memmove(EIF_POINTER s1, EIF_POINTER s2, EIF_INTEGER size)
{
  return memmove(s1, s2, size);
}

EIF_POINTER posix_memset(EIF_POINTER s, EIF_INTEGER c, EIF_INTEGER size)
{
  return memset(s, c, size);
}

EIF_POINTER posix_strerror(int errnum)
{
  return strerror(errnum);
}
