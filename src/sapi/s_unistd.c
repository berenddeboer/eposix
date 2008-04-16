#include "s_unistd.h"


/* filesystem related */

EIF_INTEGER posix_symlink (EIF_POINTER oldpath, EIF_POINTER newpath)
{
  return symlink(oldpath, newpath);
}


/* network related */

EIF_INTEGER posix_gethostname(EIF_POINTER name, EIF_INTEGER namelen)
{
  return gethostname(name, namelen);
}
