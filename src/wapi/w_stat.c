#include "w_stat.h"

/* functions */

EIF_INTEGER posix_fstat(EIF_INTEGER fildes, EIF_POINTER buf)
{
  return fstat(fildes, (void *) buf);
}

EIF_INTEGER posix_stat(EIF_POINTER path, EIF_POINTER buf)
{
  return stat(path, (void *) buf);
}


/* stat structure */

EIF_INTEGER posix_st_atime (struct stat *buf)
{
  return (buf->st_atime);
}

EIF_INTEGER posix_st_ctime (struct stat *buf)
{
  return (buf->st_ctime);
}

EIF_INTEGER posix_st_dev (struct stat *buf)
{
  return (buf->st_dev);
}

EIF_INTEGER posix_st_mode (struct stat *buf)
{
  return (buf->st_mode);
}

EIF_INTEGER posix_st_mtime (struct stat *buf)
{
  return (buf->st_mtime);
}

EIF_INTEGER posix_st_nlink (struct stat *buf)
{
  return (buf->st_nlink);
}

EIF_INTEGER posix_st_rdev (struct stat *buf)
{
  return (buf->st_rdev);
}

EIF_INTEGER posix_st_size (struct stat *buf)
{
  return (buf->st_size);
}


EIF_INTEGER posix_stat_size()
{
  return (sizeof(struct stat));
}


/* file type */

EIF_BOOLEAN posix_s_ischr (EIF_INTEGER m)
{
  return ((m & _S_IFCHR) != 0);
}

EIF_BOOLEAN posix_s_isdir (EIF_INTEGER m)
{
  return ((m & _S_IFDIR) != 0);
}

EIF_BOOLEAN posix_s_isfifo (EIF_INTEGER m)
{
  return ((m & _S_IFIFO) != 0);
}

EIF_BOOLEAN posix_s_isreg (EIF_INTEGER m)
{
  return ((m & _S_IFREG) != 0);
}


/* constants */

EIF_INTEGER const_s_iexec()
{
  return S_IEXEC;
}

EIF_INTEGER const_s_iread()
{
  return S_IREAD;
}

EIF_INTEGER const_s_iwrite()
{
  return S_IWRITE;
}
