/*

C layer to Posix dirent.h header

*/

#ifndef _P_DIRENT_H_
#define _P_DIRENT_H_

#include "p_defs.h"

#ifdef HAVE_DIRENT_H
#include <dirent.h>
#else
#ifdef HAVE_SYS_NDIR_H
#include <sys/ndir.h>
#else
#ifdef HAVE_SYS_DIR_H
#include <sys/dir.h>
#else
#ifdef HAVE_NDIR_H
#include <ndir.h>
#endif
#endif
#endif
#endif

#include "../supportc/eiffel.h"


EIF_INTEGER posix_closedir(EIF_POINTER dirp);
EIF_POINTER posix_opendir(EIF_POINTER dirname);
EIF_POINTER posix_readdir(EIF_POINTER dirp);
void posix_rewinddir(EIF_POINTER dirp);

EIF_POINTER posix_d_name (struct dirent *dirent);

#endif /* _P_DIRENT_H_ */
