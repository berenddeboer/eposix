/*

C layer to Posix asynchronous input and output routines in aio.h.

*/

#ifndef _P_AIO_H_
#define _P_AIO_H_

#include "p_defs.h"
#include <errno.h>
#include <aio.h>
#include "../supportc/eiffel.h"

/* functions */

EIF_INTEGER posix_aio_read(EIF_POINTER aiocbp);
EIF_INTEGER posix_aio_write(EIF_POINTER aiocbp);
EIF_INTEGER posix_aio_error(EIF_POINTER aiocbp);
EIF_INTEGER posix_aio_return(EIF_POINTER aiocbp);
EIF_INTEGER posix_aio_cancel(EIF_INTEGER fildes, EIF_POINTER aiocbp);
EIF_INTEGER posix_aio_suspend(EIF_POINTER list, EIF_INTEGER nent, EIF_POINTER timeout);
EIF_INTEGER posix_aio_fsync(EIF_INTEGER op, EIF_POINTER aiocbp);


/* struct aiocb */

EIF_INTEGER posix_aiocb_size();

EIF_INTEGER posix_aiocb_aio_fildes(struct aiocb *p);
EIF_INTEGER posix_aiocb_aio_lio_opcode(struct aiocb *p);
EIF_INTEGER posix_aiocb_aio_reqprio(struct aiocb *p);
volatile void * posix_aiocb_aio_buf(struct aiocb *p);
EIF_INTEGER posix_aiocb_aio_nbytes(struct aiocb *p);
EIF_POINTER posix_aiocb_aio_sigevent(struct aiocb *p);
EIF_INTEGER posix_aiocb_aio_offset(struct aiocb *p);

void posix_set_aiocb_aio_fildes(struct aiocb *p, EIF_INTEGER aio_fildes);
void posix_set_aiocb_aio_lio_opcode(struct aiocb *p, EIF_INTEGER aio_lio_opcode);
void posix_set_aiocb_aio_reqprio(struct aiocb *p, EIF_INTEGER aio_reqprio);
void posix_set_aiocb_aio_buf(struct aiocb *p, EIF_POINTER aio_buf);
void posix_set_aiocb_aio_nbytes(struct aiocb *p, EIF_INTEGER aio_nbytes);
void posix_set_aiocb_aio_offset(struct aiocb *p, EIF_INTEGER aio_offset);


/* constants */

EIF_INTEGER const_aio_canceled();
EIF_INTEGER const_aio_notcanceled();
EIF_INTEGER const_aio_alldone();
EIF_INTEGER const_lio_read();
EIF_INTEGER const_lio_write();
EIF_INTEGER const_lio_nop();
EIF_INTEGER const_lio_wait();
EIF_INTEGER const_lio_nowait();


#endif /* _P_AIO_H_ */
