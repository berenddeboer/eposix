#include "w_direct.h"


EIF_INTEGER posix_chdir(EIF_POINTER path)
{
  return chdir(path);
}

EIF_INTEGER posix_chdrive(EIF_INTEGER drive)
{
  return _chdrive(drive);
}

EIF_POINTER posix_getcwd(EIF_POINTER buf, EIF_INTEGER size)
{
  return _getcwd(buf, size);
}

EIF_POINTER posix_getdcwd(EIF_INTEGER drive, EIF_POINTER buffer, EIF_INTEGER maxlen)
{
  return _getdcwd(drive, buffer, maxlen);
}

EIF_INTEGER posix_getdrive(void)
{
  return _getdrive();
}

EIF_INTEGER posix_mkdir(EIF_POINTER path)
{
  return mkdir(path);
}

EIF_INTEGER posix_rmdir(EIF_POINTER path)
{
  return rmdir(path);
}
