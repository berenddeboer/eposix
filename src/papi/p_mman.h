/*

Access to POSIX mman.h header

*/

#ifndef _P_MMAN_H_
#define _P_MMAN_H_


#include "p_defs.h"

#ifdef HAVE_MMAP

#include <sys/types.h>
#include <sys/mman.h>
#include "../supportc/eiffel.h"

/* functions */

EIF_POINTER posix_mmap(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER prot, EIF_INTEGER flags, EIF_INTEGER fildes, EIF_INTEGER off);
EIF_INTEGER posix_mlock(EIF_POINTER addr, EIF_INTEGER len);
EIF_INTEGER posix_munlock(EIF_POINTER addr, EIF_INTEGER len);
EIF_INTEGER posix_mprotect(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER prot);
EIF_INTEGER posix_msync(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER flags);
EIF_INTEGER posix_munmap(EIF_POINTER addr, EIF_INTEGER len);


/* shared memory */

EIF_INTEGER posix_shm_open(EIF_POINTER name, EIF_INTEGER oflag, EIF_INTEGER mode);
EIF_INTEGER posix_shm_unlink(EIF_POINTER name);


/* constants */

EIF_POINTER const_map_failed();

EIF_INTEGER const_prot_read();
EIF_INTEGER const_prot_write();
EIF_INTEGER const_prot_exec();
EIF_INTEGER const_prot_none();

EIF_INTEGER const_map_shared();
EIF_INTEGER const_map_private();
EIF_INTEGER const_map_fixed();

#endif /* HAVE_MMAP */

#endif /* _P_MMAN_H_ */
