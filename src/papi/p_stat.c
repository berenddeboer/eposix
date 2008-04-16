#include "p_stat.h"

/* functions */

EIF_INTEGER posix_chmod(EIF_POINTER path, EIF_INTEGER mode)
{
  return chmod(path, mode);
}


EIF_INTEGER posix_fstat(EIF_INTEGER fildes, EIF_POINTER buf)
{
  return fstat(fildes, (void *)buf);
}


EIF_INTEGER posix_mkdir(EIF_POINTER path, EIF_INTEGER mode)
{
  return mkdir(path, mode);
}


EIF_INTEGER posix_mkfifo(EIF_POINTER path, EIF_INTEGER mode)
{
#ifdef HAVE_MKFIFO
  return mkfifo (path, mode);
#else
  errno = ENOSYS;
  return -1;
#endif
}


EIF_INTEGER posix_stat(EIF_POINTER path, EIF_POINTER buf)
{
  return stat(path, (void *)buf);
}


EIF_INTEGER posix_umask(EIF_INTEGER cmask)
{
  return umask (cmask);
}


/* constants */

EIF_INTEGER const_s_irgrp()
{
  return S_IRGRP;
}

EIF_INTEGER const_s_iroth()
{
  return S_IROTH;
}

EIF_INTEGER const_s_irusr()
{
  return S_IRUSR;
}


EIF_INTEGER const_s_isuid()
{
  return S_ISUID;
}

EIF_INTEGER const_s_isgid()
{
  return S_ISGID;
}


EIF_INTEGER const_s_iwgrp()
{
  return S_IWGRP;
}

EIF_INTEGER const_s_iwoth()
{
  return S_IWOTH;
}

EIF_INTEGER const_s_iwusr()
{
  return S_IWUSR;
}


EIF_INTEGER const_s_ixgrp()
{
  return S_IXGRP;
}

EIF_INTEGER const_s_ixoth()
{
  return S_IXOTH;
}

EIF_INTEGER const_s_ixusr()
{
#ifdef S_IXUSR
  return S_IXUSR;
#else
  return S_IEXEC;
#endif
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

EIF_INTEGER posix_st_gid (struct stat *buf)
{
  return (buf->st_gid);
}

EIF_INTEGER posix_st_ino (struct stat *buf)
{
  return (buf->st_ino);
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

EIF_INTEGER posix_st_size (struct stat *buf)
{
  return (buf->st_size);
}

EIF_INTEGER posix_st_uid (struct stat *buf)
{
  return (buf->st_uid);
}


EIF_INTEGER posix_stat_size()
{
  return (sizeof(struct stat));
}


/* file type */

EIF_BOOLEAN posix_s_isblk (EIF_INTEGER m)
{
  return (S_ISBLK(m));
}

EIF_BOOLEAN posix_s_ischr (EIF_INTEGER m)
{
  return (S_ISCHR(m));
}

EIF_BOOLEAN posix_s_isdir (EIF_INTEGER m)
{
  return (S_ISDIR(m));
}

EIF_BOOLEAN posix_s_isfifo (EIF_INTEGER m)
{
  return (S_ISFIFO(m));
}

EIF_BOOLEAN posix_s_isreg (EIF_INTEGER m)
{
  return (S_ISREG(m));
}

