#include "p_mman.h"


#ifdef HAVE_MMAP

/* functions */

EIF_POINTER posix_mmap(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER prot, EIF_INTEGER flags, EIF_INTEGER fildes, EIF_INTEGER off)
{
  return mmap(addr, len, prot, flags, fildes, off);
}

EIF_INTEGER posix_mlock(EIF_POINTER addr, EIF_INTEGER len)
{
  return mlock(addr, len);
}

EIF_INTEGER posix_munlock(EIF_POINTER addr, EIF_INTEGER len)
{
  return munlock(addr, len);
}

EIF_INTEGER posix_mprotect(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER prot)
{
  return mprotect(addr, len, prot);
}

EIF_INTEGER posix_msync(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER flags)
{
  return msync(addr, len, flags);
}

EIF_INTEGER posix_munmap(EIF_POINTER addr, EIF_INTEGER len)
{
  return munmap(addr, len);
}


/* shared memory */

EIF_INTEGER posix_shm_open(EIF_POINTER name, EIF_INTEGER oflag, EIF_INTEGER mode)
{
  return shm_open (name, oflag, mode);
}

EIF_INTEGER posix_shm_unlink(EIF_POINTER name)
{
  return shm_unlink (name);
}


/* constants */

EIF_POINTER const_map_failed()
{
#ifdef MAP_FAILED
  return MAP_FAILED;
#else
  return 0; /* really no idea what to return here */
#endif
}


EIF_INTEGER const_prot_read()
{
  return PROT_READ;
}

EIF_INTEGER const_prot_write()
{
  return PROT_WRITE;
}

EIF_INTEGER const_prot_exec()
{
  return PROT_EXEC;
}

EIF_INTEGER const_prot_none()
{
  return PROT_NONE;
}


EIF_INTEGER const_map_shared()
{
  return MAP_SHARED;
}

EIF_INTEGER const_map_private()
{
  return MAP_PRIVATE;
}

EIF_INTEGER const_map_fixed()
{
  /* FreeBSD 5.3 does seem to have MAP_FIXED as optional, so return 0 for now. */
#ifdef MAP_FIXED
  return MAP_FIXED;
#else
  return 0;
#endif
}

#endif
