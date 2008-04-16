#include "p_errno.h"


/* error numbers */

EIF_INTEGER const_e2big()
{
  return E2BIG;
}

EIF_INTEGER const_eacces()
{
  return EACCES;
}

EIF_INTEGER const_eagain()
{
  return EAGAIN;
}

EIF_INTEGER const_ebadf()
{
  return EBADF;
}

EIF_INTEGER const_ebadmsg()
{
#ifdef EBADMSG
  return EBADMSG;
#else
  return 0;
#endif
}

EIF_INTEGER const_ebusy()
{
  return EBUSY;
}

EIF_INTEGER const_ecanceled()
{
#ifdef ECANCELED
  return ECANCELED;
#else
  return 0; /* this constant is mandatory, but older cygwins don't have it */
#endif
}

EIF_INTEGER const_echild()
{
  return ECHILD;
}

EIF_INTEGER const_edeadlk()
{
  return EDEADLK;
}

EIF_INTEGER const_eexist()
{
  return EEXIST;
}

EIF_INTEGER const_efault()
{
  return EFAULT;
}

EIF_INTEGER const_efbig()
{
  return EFBIG;
}

EIF_INTEGER const_einprogress()
{
#ifdef EINPROGRESS
  return EINPROGRESS;
#else
  return 0;
#endif
}

EIF_INTEGER const_eintr()
{
  return EINTR;
}

EIF_INTEGER const_einval()
{
  return EINVAL;
}

EIF_INTEGER const_eio()
{
  return EIO;
}

EIF_INTEGER const_eisdir()
{
  return EISDIR;
}

EIF_INTEGER const_emlink()
{
  return EMLINK;
}

EIF_INTEGER const_emsgsize()
{
  return EMSGSIZE;
}

EIF_INTEGER const_enametoolong()
{
  return ENAMETOOLONG;
}

EIF_INTEGER const_enfile()
{
  return ENFILE;
}

EIF_INTEGER const_enodev()
{
  return ENODEV;
}

EIF_INTEGER const_enoent()
{
  return ENOENT;
}

EIF_INTEGER const_enoexec()
{
  return ENOEXEC;
}

EIF_INTEGER const_enolck()
{
  return ENOLCK;
}

EIF_INTEGER const_enomem()
{
  return ENOMEM;
}

EIF_INTEGER const_enospc()
{
  return ENOSPC;
}

EIF_INTEGER const_enosys()
{
  return ENOSYS;
}

EIF_INTEGER const_enotdir()
{
  return ENOTDIR;
}

EIF_INTEGER const_enotempty()
{
  return ENOTEMPTY;
}

EIF_INTEGER const_enotsup()
{
  return ENOTSUP;
}

EIF_INTEGER const_enotty()
{
  return ENOTTY;
}

EIF_INTEGER const_enxio()
{
  return ENXIO;
}

EIF_INTEGER const_eperm()
{
  return EPERM;
}

EIF_INTEGER const_epipe()
{
  return EPIPE;
}

EIF_INTEGER const_erofs()
{
  return EROFS;
}

EIF_INTEGER const_espipe()
{
  return ESPIPE;
}

EIF_INTEGER const_esrch()
{
  return ESRCH;
}

EIF_INTEGER const_etimedout()
{
  return ETIMEDOUT;
}

EIF_INTEGER const_exdev()
{
  return EXDEV;
}
