/*

Access to Windows sys/stat.h

*/

#define _POSIX_SOURCE 1

#ifndef _W_STAT_H_
#define _W_STAT_H_


#include "../supportc/eiffel.h"
#include <sys/types.h>
#include <sys/stat.h>


/* functions */

EIF_INTEGER posix_fstat(EIF_INTEGER fildes, EIF_POINTER buf);
EIF_INTEGER posix_stat(EIF_POINTER path, EIF_POINTER buf);


/* stat structure */

EIF_INTEGER posix_st_atime (struct stat *buf);
EIF_INTEGER posix_st_ctime (struct stat *buf);
EIF_INTEGER posix_st_dev (struct stat *buf);
EIF_INTEGER posix_st_mode (struct stat *buf);
EIF_INTEGER posix_st_mtime (struct stat *buf);
EIF_INTEGER posix_st_nlink (struct stat *buf);
EIF_INTEGER posix_st_rdev (struct stat *buf);
EIF_INTEGER posix_st_size (struct stat *buf);

EIF_INTEGER posix_stat_size();


/* file type */

EIF_BOOLEAN posix_s_ischr (EIF_INTEGER m);
EIF_BOOLEAN posix_s_isdir (EIF_INTEGER m);
EIF_BOOLEAN posix_s_isfifo (EIF_INTEGER m);
EIF_BOOLEAN posix_s_isreg (EIF_INTEGER m);

/* constants */

EIF_INTEGER const_s_iexec();
EIF_INTEGER const_s_iread();
EIF_INTEGER const_s_iwrite();


#endif /* _W_STAT_H_ */
