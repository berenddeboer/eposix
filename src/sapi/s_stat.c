#include "s_stat.h"


/* functions */

EIF_INTEGER posix_lstat(EIF_POINTER path, EIF_POINTER buf)
{
  return lstat(path, (struct stat *) buf);
}


/* file type */

EIF_BOOLEAN posix_s_islnk (EIF_INTEGER m)
{
  return (S_ISLNK(m));
}


/* stat struct members */

EIF_INTEGER posix_st_blkcnt(struct stat *buf)
{
#ifdef HAVE_STRUCT_STAT_ST_BLOCKS
  return (buf->st_blocks);
#else
  return 0;
#endif
}

EIF_INTEGER posix_st_blksize(struct stat *buf)
{
#ifdef HAVE_STRUCT_STAT_ST_BLKSIZE
  return (buf->st_blksize);
#else
  return 0;
#endif
}
