/*

C layer to Posix semaphore routines in semaphore.h.

*/

#ifndef _P_SEMAPHORE_H_
#define _P_SEMAPHORE_H_


#include "p_defs.h"

#ifdef HAVE_SEMAPHORE_H

#include <semaphore.h>
#include <unistd.h>
#ifdef HAVE_LIMITS_H
#include <limits.h>
#endif
#include "../supportc/eiffel.h"


EIF_INTEGER posix_sem_close (EIF_POINTER sem);
EIF_INTEGER posix_sem_destroy (EIF_POINTER sem);
EIF_INTEGER posix_sem_getvalue(EIF_POINTER sem, EIF_POINTER sval);
EIF_INTEGER posix_sem_init (EIF_POINTER sem, EIF_BOOLEAN pshared, EIF_INTEGER value);
EIF_POINTER posix_sem_open (EIF_POINTER name, EIF_INTEGER oflag, EIF_INTEGER mode, EIF_INTEGER value);
EIF_INTEGER posix_sem_post (EIF_POINTER sem);
EIF_INTEGER posix_sem_trywait (EIF_POINTER sem);
EIF_INTEGER posix_sem_wait (EIF_POINTER sem);

EIF_INTEGER posix_sem_t_size();


/* semaphore related constants */

EIF_POINTER const_sem_failed();
EIF_INTEGER const_sem_value_max();

#endif

#endif /* _P_SEMAPHORE_H_ */
