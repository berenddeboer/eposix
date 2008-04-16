/*

C layer to posix semaphore routines.

*/

#include "p_semaphore.h"

#ifdef HAVE_SEMAPHORE_H

EIF_INTEGER posix_sem_close (EIF_POINTER sem)
{
  return sem_close(sem);
}

EIF_INTEGER posix_sem_destroy (EIF_POINTER sem)
{
  return sem_destroy(sem);
}


EIF_INTEGER posix_sem_getvalue(EIF_POINTER sem, EIF_POINTER sval)
{
  return sem_getvalue(sem, sval);
}


EIF_INTEGER posix_sem_init (EIF_POINTER sem, EIF_BOOLEAN pshared, EIF_INTEGER value)
{
  return sem_init(sem, pshared, value);
}


EIF_POINTER posix_sem_open (EIF_POINTER name, EIF_INTEGER oflag, EIF_INTEGER mode, EIF_INTEGER value)
{
  return sem_open(name, oflag, mode, value);
}


EIF_INTEGER posix_sem_post (EIF_POINTER sem)
{
  return sem_post(sem);
}


EIF_INTEGER posix_sem_trywait (EIF_POINTER sem)
{
  return sem_trywait(sem);
}


EIF_INTEGER posix_sem_wait (EIF_POINTER sem)
{
  return sem_wait(sem);
}


EIF_INTEGER posix_sem_t_size()
{
  return (sizeof(sem_t));
}


EIF_POINTER const_sem_failed()
{
  return SEM_FAILED;
}

EIF_INTEGER const_sem_value_max()
{
#ifdef SEM_VALUE_MAX
  return SEM_VALUE_MAX;
#else
  return INT_MAX;
#endif
}

#endif
