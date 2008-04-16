#include "s_stropts.h"


/* functions */

EIF_INTEGER posix_ioctl(EIF_INTEGER fildes, EIF_INTEGER request, EIF_POINTER arg)
{
  return ioctl(fildes, request, arg);
}
