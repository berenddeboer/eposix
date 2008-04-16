/* Asynchronous support */

#include <unistd.h>

#if (_POSIX_VERSION >= 199506L)

#include "p_aio.h"

/* functions */

EIF_INTEGER posix_aio_read(EIF_POINTER aiocbp)
{
  return aio_read((struct aiocb *) aiocbp);
}

EIF_INTEGER posix_aio_write(EIF_POINTER aiocbp)
{
  return aio_write((struct aiocb *) aiocbp);
}

EIF_INTEGER posix_aio_error(EIF_POINTER aiocbp)
{
  return aio_error((struct aiocb *) aiocbp);
}

EIF_INTEGER posix_aio_return(EIF_POINTER aiocbp)
{
  return aio_return((struct aiocb *) aiocbp);
}

EIF_INTEGER posix_aio_cancel(EIF_INTEGER fildes, EIF_POINTER aiocbp)
{
  return aio_cancel(fildes, (struct aiocb *) aiocbp);
}

EIF_INTEGER posix_aio_suspend(EIF_POINTER list, EIF_INTEGER nent, EIF_POINTER timeout)
{
  return aio_suspend(list, nent, (struct timespec *) timeout);
}

EIF_INTEGER posix_aio_fsync(EIF_INTEGER op, EIF_POINTER aiocbp)
{
#ifdef HAVE_AIO_FSYNC
  return aio_fsync(op, (struct aiocb *) aiocbp);
#else
  /* or ignore? */
  return EINVAL;
#endif
}


/* struct aiocb */

EIF_INTEGER posix_aiocb_size()
{
   return (sizeof (struct aiocb));
}


EIF_INTEGER posix_aiocb_aio_fildes(struct aiocb *p)
{
  return p->aio_fildes;
}

EIF_INTEGER posix_aiocb_aio_lio_opcode(struct aiocb *p)
{
  return p->aio_lio_opcode;
}

EIF_INTEGER posix_aiocb_aio_reqprio(struct aiocb *p)
{
  return p->aio_reqprio;
}

volatile void * posix_aiocb_aio_buf(struct aiocb *p)
{
  return p->aio_buf;
}

EIF_INTEGER posix_aiocb_aio_nbytes(struct aiocb *p)
{
  return p->aio_nbytes;
}

EIF_POINTER posix_aiocb_aio_sigevent(struct aiocb *p)
{
  return (EIF_POINTER) &(p->aio_sigevent);
}

EIF_INTEGER posix_aiocb_aio_offset(struct aiocb *p)
{
  return p->aio_offset;
}


void posix_set_aiocb_aio_fildes(struct aiocb *p, EIF_INTEGER aio_fildes)
{
  p->aio_fildes = aio_fildes;
}

void posix_set_aiocb_aio_lio_opcode(struct aiocb *p, EIF_INTEGER aio_lio_opcode)
{
  p->aio_lio_opcode = aio_lio_opcode;
}

void posix_set_aiocb_aio_reqprio(struct aiocb *p, EIF_INTEGER aio_reqprio)
{
  p->aio_reqprio = aio_reqprio;
}

void posix_set_aiocb_aio_buf(struct aiocb *p, EIF_POINTER aio_buf)
{
  p->aio_buf = aio_buf;
}

void posix_set_aiocb_aio_nbytes(struct aiocb *p, EIF_INTEGER aio_nbytes)
{
  p->aio_nbytes = aio_nbytes;
}

void posix_set_aiocb_aio_offset(struct aiocb *p, EIF_INTEGER aio_offset)
{
  p->aio_offset = aio_offset;
}


/* constants */

EIF_INTEGER const_aio_canceled()
{
  return AIO_CANCELED;
}

EIF_INTEGER const_aio_notcanceled()
{
  return AIO_NOTCANCELED;
}

EIF_INTEGER const_aio_alldone()
{
  return AIO_ALLDONE;
}

EIF_INTEGER const_lio_read()
{
  return LIO_READ;
}

EIF_INTEGER const_lio_write()
{
  return LIO_WRITE;
}

EIF_INTEGER const_lio_nop()
{
  return LIO_NOP;
}

EIF_INTEGER const_lio_wait()
{
  return LIO_WAIT;
}

EIF_INTEGER const_lio_nowait()
{
  return LIO_NOWAIT;
}

#endif
