#include "p_fcntl.h"


/* functions which have a file descriptor as argument */

EIF_INTEGER posix_create(EIF_POINTER path, EIF_INTEGER oflag, EIF_INTEGER mode)
{
  return open(path, oflag, mode);
}

EIF_INTEGER posix_fcntl(EIF_INTEGER fildes, EIF_INTEGER cmd)
{
  return fcntl(fildes, cmd);
}

EIF_INTEGER posix_fcntl_arg(EIF_INTEGER fildes, EIF_INTEGER cmd, EIF_INTEGER arg)
{
  return fcntl(fildes, cmd, arg);
}

EIF_INTEGER posix_fcntl_lock(EIF_INTEGER fildes, EIF_INTEGER cmd, EIF_POINTER lock)
{
  return fcntl(fildes, cmd, lock);
}

EIF_INTEGER posix_open(EIF_POINTER path, EIF_INTEGER oflag)
{
  return open(path, oflag);
}


/* flock structure */

EIF_INTEGER posix_flock_size()
{
  return(sizeof(struct flock));
}

EIF_INTEGER posix_flock_type(struct flock *lock)
{
  return (lock->l_type);
}

EIF_INTEGER posix_flock_whence(struct flock *lock)
{
  return (lock->l_whence);
}

EIF_INTEGER posix_flock_start(struct flock *lock)
{
  return (lock->l_start);
}

EIF_INTEGER posix_flock_len(struct flock *lock)
{
  return (lock->l_len);
}

EIF_INTEGER posix_flock_pid(struct flock *lock)
{
  return (lock->l_pid);
}


void posix_set_flock_type(struct flock *lock, EIF_INTEGER type)
{
  lock->l_type = type;
}

void posix_set_flock_whence(struct flock *lock, EIF_INTEGER whence)
{
  lock->l_whence = whence;
}

void posix_set_flock_start(struct flock *lock, EIF_INTEGER start)
{
  lock->l_start = start;
}

void posix_set_flock_len(struct flock *lock, EIF_INTEGER len)
{
  lock->l_len = len;
}


/* constants */

EIF_INTEGER const_o_append()
{
  return O_APPEND;
}

EIF_INTEGER const_o_dsync()
{
#ifdef O_DSYNC
  return O_DSYNC;
#else
#ifdef O_SYNC
  return O_SYNC;
#else
  return 0;
#endif
#endif
}

EIF_INTEGER const_o_creat()
{
  return O_CREAT;
}

EIF_INTEGER const_o_excl()
{
  return O_EXCL;
}

EIF_INTEGER const_o_noctty()
{
  return O_NOCTTY;
}

EIF_INTEGER const_o_nonblock()
{
  return O_NONBLOCK;
}

EIF_INTEGER const_o_rdonly()
{
  return O_RDONLY;
}

EIF_INTEGER const_o_rdwr()
{
  return O_RDWR;
}

EIF_INTEGER const_o_rsync()
{
#ifdef O_RSYNC
  return O_RSYNC;
#else
  return 0;
#endif
}

EIF_INTEGER const_o_sync()
{
#ifdef O_SYNC
  return O_SYNC;
#else
  return 0;
#endif
}

EIF_INTEGER const_o_trunc()
{
  return O_TRUNC;
}

EIF_INTEGER const_o_wronly()
{
  return O_WRONLY;
}



EIF_INTEGER const_f_rdlck()
{
  return F_RDLCK;
}

EIF_INTEGER const_f_wrlck()
{
  return F_WRLCK;
}

EIF_INTEGER const_f_unlck()
{
  return F_UNLCK;
}


EIF_INTEGER const_f_dupfd()
{
  return F_DUPFD;
}

EIF_INTEGER const_f_getfd()
{
  return F_GETFD;
}

EIF_INTEGER const_f_setfd()
{
  return F_SETFD;
}

EIF_INTEGER const_f_getfl()
{
  return F_GETFL;
}

EIF_INTEGER const_f_setfl()
{
  return F_SETFL;
}

EIF_INTEGER const_f_getlk()
{
  return F_GETLK;
}

EIF_INTEGER const_f_setlk()
{
  return F_SETLK;
}

EIF_INTEGER const_f_setlkw()
{
  return F_SETLKW;
}

EIF_INTEGER const_fd_cloexec()
{
  return FD_CLOEXEC;
}
