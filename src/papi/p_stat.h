/*

Access to POSIX sys/stat.h

*/


#ifndef _P_STAT_H_
#define _P_STAT_H_

#include "p_defs.h"
#include <config.h>
#include <sys/types.h>
#include <errno.h>
#include <sys/stat.h>
#include "../supportc/eiffel.h"


/* functions */

EIF_INTEGER posix_chmod(EIF_POINTER path, EIF_INTEGER mode);
EIF_INTEGER posix_fstat(EIF_INTEGER fildes, EIF_POINTER buf);
EIF_INTEGER posix_mkdir(EIF_POINTER path, EIF_INTEGER mode);
EIF_INTEGER posix_mkfifo(EIF_POINTER path, EIF_INTEGER mode);
EIF_INTEGER posix_stat(EIF_POINTER path, EIF_POINTER buf);
EIF_INTEGER posix_umask(EIF_INTEGER cmask);


/* constants */

EIF_INTEGER const_s_irgrp();
EIF_INTEGER const_s_iroth();
EIF_INTEGER const_s_irusr();

EIF_INTEGER const_s_isgid();
EIF_INTEGER const_s_isuid();

EIF_INTEGER const_s_iwgrp();
EIF_INTEGER const_s_iwoth();
EIF_INTEGER const_s_iwusr();

EIF_INTEGER const_s_ixusr();
EIF_INTEGER const_s_ixgrp();
EIF_INTEGER const_s_ixoth();

/* stat structure */

EIF_INTEGER posix_st_atime (struct stat *buf);
EIF_INTEGER posix_st_ctime (struct stat *buf);
EIF_INTEGER posix_st_dev (struct stat *buf);
EIF_INTEGER posix_st_gid (struct stat *buf);
EIF_INTEGER posix_st_ino (struct stat *buf);
EIF_INTEGER posix_st_mode (struct stat *buf);
EIF_INTEGER posix_st_mtime (struct stat *buf);
EIF_INTEGER posix_st_nlink (struct stat *buf);
EIF_INTEGER posix_st_size (struct stat *buf);
EIF_INTEGER posix_st_uid (struct stat *buf);

EIF_INTEGER posix_stat_size();


/* file type */

EIF_BOOLEAN posix_s_isblk (EIF_INTEGER m);
EIF_BOOLEAN posix_s_ischr (EIF_INTEGER m);
EIF_BOOLEAN posix_s_isdir (EIF_INTEGER m);
EIF_BOOLEAN posix_s_isfifo (EIF_INTEGER m);
EIF_BOOLEAN posix_s_isreg (EIF_INTEGER m);


#endif /* _P_STAT_H_ */
