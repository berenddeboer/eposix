/*

Access to Single Unix Spec sys/stat.h

*/


#ifndef _S_STAT_H_
#define _S_STAT_H_

#include "s_defs.h"
#include <sys/types.h>
#include <sys/stat.h>
#include "../supportc/eiffel.h"


/* functions */

EIF_INTEGER posix_lstat(EIF_POINTER path, EIF_POINTER buf);


/* file type */

EIF_BOOLEAN posix_s_islnk (EIF_INTEGER m);


/* stat struct members */

EIF_INTEGER posix_st_blkcnt(struct stat *buf);
EIF_INTEGER posix_st_blksize(struct stat *buf);


#endif /* _S_STAT_H_ */
