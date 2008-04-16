#include "c_security.h"

/* access */

EIF_INTEGER posix_open_files()
{
  return the_posix_open_files;
}

EIF_INTEGER posix_allocated_memory()
{
  return the_posix_allocated_memory;
}


/* inc/dec functions */

void posix_decrease_open_files()
{
  the_posix_open_files -= 1;
}

void posix_decrease_allocated_memory(EIF_INTEGER amount)
{
  the_posix_allocated_memory -= amount;
}

void posix_increase_open_files()
{
  the_posix_open_files += 1;
}

void posix_increase_allocated_memory(EIF_INTEGER amount)
{
  the_posix_allocated_memory += amount;
}
