#include "w_io.h"

EIF_INTEGER posix_access(EIF_POINTER path, EIF_INTEGER mode)
{
  return _access (path, mode);
}

EIF_INTEGER posix_close(EIF_INTEGER fildes)
{
  return close(fildes);
}

EIF_INTEGER posix_create(EIF_POINTER path, EIF_INTEGER oflag, EIF_INTEGER mode)
{
  return open(path, oflag, mode);
}

EIF_INTEGER posix_dup(EIF_INTEGER fildes)
{
  return dup(fildes);
}

EIF_INTEGER posix_dup2(EIF_INTEGER fildes, EIF_INTEGER fildes2)
{
  return dup2(fildes, fildes2);
}

EIF_BOOLEAN posix_isatty(EIF_INTEGER handle)
{
  return isatty(handle);
}

EIF_INTEGER posix_lseek(EIF_INTEGER fildes, EIF_INTEGER offset, EIF_INTEGER whence)
{
  return lseek(fildes, offset, whence);
}

EIF_INTEGER posix_open(EIF_POINTER path, EIF_INTEGER oflag)
{
  return open(path, oflag);
}

EIF_INTEGER posix_read(EIF_INTEGER fildes, EIF_POINTER buf, EIF_INTEGER nbyte)
{
  return read(fildes, buf, nbyte);
}

EIF_INTEGER posix_setmode (EIF_INTEGER handle, EIF_INTEGER mode)
{
  return setmode(handle, mode);
}

EIF_INTEGER posix_write(EIF_INTEGER fildes, EIF_POINTER buf, EIF_INTEGER nbyte)
{
  return write(fildes, buf, nbyte);
} 
