/*

Access to Single Unix Spec sys/stat.h

*/


#ifndef _S_STAT_H_
#define _S_STAT_H_

#include "s_defs.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/statvfs.h>
#include "../supportc/eiffel.h"


/* functions */

EIF_INTEGER posix_fstatvfs(EIF_INTEGER fildes, EIF_POINTER buf);
EIF_INTEGER posix_lstat(EIF_POINTER path, EIF_POINTER buf);
EIF_INTEGER posix_statvfs(EIF_POINTER path, EIF_POINTER buf);


/* file type */

EIF_BOOLEAN posix_s_islnk (EIF_INTEGER m);


/* stat struct members */

EIF_INTEGER posix_st_blkcnt(struct stat *buf);
EIF_INTEGER posix_st_blksize(struct stat *buf);

/* struct statvfs */

EIF_INTEGER posix_statvfs_size();

EIF_INTEGER_64 posix_statvfs_f_bsize(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_frsize(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_blocks(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_bfree(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_bavail(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_files(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_ffree(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_favail(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_fsid(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_flag(struct statvfs *p);
EIF_INTEGER_64 posix_statvfs_f_namemax(struct statvfs *p);

void posix_set_statvfs_f_bsize(struct statvfs *p, EIF_INTEGER_64 f_bsize);
void posix_set_statvfs_f_frsize(struct statvfs *p, EIF_INTEGER_64 f_frsize);
void posix_set_statvfs_f_blocks(struct statvfs *p, EIF_INTEGER_64 f_blocks);
void posix_set_statvfs_f_bfree(struct statvfs *p, EIF_INTEGER_64 f_bfree);
void posix_set_statvfs_f_bavail(struct statvfs *p, EIF_INTEGER_64 f_bavail);
void posix_set_statvfs_f_files(struct statvfs *p, EIF_INTEGER_64 f_files);
void posix_set_statvfs_f_ffree(struct statvfs *p, EIF_INTEGER_64 f_ffree);
void posix_set_statvfs_f_favail(struct statvfs *p, EIF_INTEGER_64 f_favail);
void posix_set_statvfs_f_fsid(struct statvfs *p, EIF_INTEGER_64 f_fsid);
void posix_set_statvfs_f_flag(struct statvfs *p, EIF_INTEGER_64 f_flag);
void posix_set_statvfs_f_namemax(struct statvfs *p, EIF_INTEGER_64 f_namemax);


#endif /* _S_STAT_H_ */
