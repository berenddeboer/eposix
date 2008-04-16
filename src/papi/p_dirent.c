#include "p_dirent.h"

EIF_INTEGER posix_closedir(EIF_POINTER dirp)
{
#ifdef CLOSEDIR_VOID
  closedir(dirp);
  return 0;
#else
  return closedir(dirp);
#endif
}


EIF_POINTER posix_opendir(EIF_POINTER dirname)
{
  return( (DIR *) opendir(dirname));
}


EIF_POINTER posix_readdir(EIF_POINTER dirp)
{
     return readdir(dirp);
}


void posix_rewinddir(EIF_POINTER dirp)
{
  rewinddir(dirp);
}


EIF_POINTER posix_d_name (struct dirent *dirent)
{
  return (dirent->d_name);
}
