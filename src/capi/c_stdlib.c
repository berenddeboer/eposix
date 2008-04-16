#include "c_stdlib.h"

/* dynamic memory */

EIF_POINTER posix_calloc(EIF_INTEGER nmemb, EIF_INTEGER size)
{
  return calloc(nmemb, size);
}


void posix_free(EIF_POINTER ptr)
{
  free(ptr);
}


EIF_POINTER posix_malloc(EIF_INTEGER size)
{
  return malloc(size);
}


EIF_POINTER posix_realloc(EIF_POINTER ptr, EIF_INTEGER size)
{
  return realloc(ptr, size);
}


/* miscellaneous */

void posix_abort()
{
  abort();
}

void posix_exit(EIF_INTEGER status)
{
  exit(status);
}

EIF_POINTER posix_getenv(EIF_POINTER name)
{
  return getenv(name);
}

EIF_INTEGER posix_system(EIF_POINTER command)
{
  return system(command);
}


/* pseudo-random numbers */

EIF_INTEGER const_rand_max()
{
  return RAND_MAX;
}

EIF_INTEGER posix_rand()
{
  return rand();
}

void posix_srand (EIF_INTEGER seed)
{
  srand(seed);
}


/* constants */

EIF_INTEGER const_exit_failure()
{
  return EXIT_FAILURE;
}

EIF_INTEGER const_exit_success()
{
  return EXIT_SUCCESS;
}
