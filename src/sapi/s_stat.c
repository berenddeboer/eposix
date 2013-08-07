#include "s_stat.h"


/* functions */

EIF_INTEGER posix_fstatvfs(EIF_INTEGER fildes, EIF_POINTER buf)
{
  return fstatvfs(fildes, (struct statvfs *) buf);
}

EIF_INTEGER posix_lstat(EIF_POINTER path, EIF_POINTER buf)
{
  return lstat(path, (struct stat *) buf);
}

EIF_INTEGER posix_statvfs(EIF_POINTER path, EIF_POINTER buf)
{
  return statvfs(path, (struct statvfs *) buf);
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


/* struct statvfs */

EIF_INTEGER posix_statvfs_size()
{
   return (sizeof (struct statvfs));
}

EIF_INTEGER_64 posix_statvfs_f_bsize(struct statvfs *p)
{
  return p->f_bsize;
}

EIF_INTEGER_64 posix_statvfs_f_frsize(struct statvfs *p)
{
  return p->f_frsize;
}

EIF_INTEGER_64 posix_statvfs_f_blocks(struct statvfs *p)
{
  return (EIF_INTEGER_64) p->f_blocks;
}

EIF_INTEGER_64 posix_statvfs_f_bfree(struct statvfs *p)
{
  return (EIF_INTEGER_64) p->f_bfree;
}

EIF_INTEGER_64 posix_statvfs_f_bavail(struct statvfs *p)
{
  return (EIF_INTEGER_64) p->f_bavail;
}

EIF_INTEGER_64 posix_statvfs_f_files(struct statvfs *p)
{
  return (EIF_INTEGER_64) p->f_files;
}

EIF_INTEGER_64 posix_statvfs_f_ffree(struct statvfs *p)
{
  return (EIF_INTEGER_64) p->f_ffree;
}

EIF_INTEGER_64 posix_statvfs_f_favail(struct statvfs *p)
{
  return (EIF_INTEGER_64) p->f_favail;
}

EIF_INTEGER_64 posix_statvfs_f_fsid(struct statvfs *p)
{
  return p->f_fsid;
}

EIF_INTEGER_64 posix_statvfs_f_flag(struct statvfs *p)
{
  return p->f_flag;
}

EIF_INTEGER_64 posix_statvfs_f_namemax(struct statvfs *p)
{
  return p->f_namemax;
}


void posix_set_statvfs_f_bsize(struct statvfs *p, EIF_INTEGER_64 f_bsize)
{
  p->f_bsize = f_bsize;
}

void posix_set_statvfs_f_frsize(struct statvfs *p, EIF_INTEGER_64 f_frsize)
{
  p->f_frsize = f_frsize;
}

void posix_set_statvfs_f_blocks(struct statvfs *p, EIF_INTEGER_64 f_blocks)
{
  p->f_blocks = (fsblkcnt_t) f_blocks;
}

void posix_set_statvfs_f_bfree(struct statvfs *p, EIF_INTEGER_64 f_bfree)
{
  p->f_bfree = (fsblkcnt_t) f_bfree;
}

void posix_set_statvfs_f_bavail(struct statvfs *p, EIF_INTEGER_64 f_bavail)
{
  p->f_bavail = (fsblkcnt_t) f_bavail;
}

void posix_set_statvfs_f_files(struct statvfs *p, EIF_INTEGER_64 f_files)
{
  p->f_files = (fsfilcnt_t) f_files;
}

void posix_set_statvfs_f_ffree(struct statvfs *p, EIF_INTEGER_64 f_ffree)
{
  p->f_ffree = (fsfilcnt_t) f_ffree;
}

void posix_set_statvfs_f_favail(struct statvfs *p, EIF_INTEGER_64 f_favail)
{
  p->f_favail = (fsfilcnt_t) f_favail;
}

void posix_set_statvfs_f_fsid(struct statvfs *p, EIF_INTEGER_64 f_fsid)
{
  p->f_fsid = f_fsid;
}

void posix_set_statvfs_f_flag(struct statvfs *p, EIF_INTEGER_64 f_flag)
{
  p->f_flag = f_flag;
}

void posix_set_statvfs_f_namemax(struct statvfs *p, EIF_INTEGER_64 f_namemax)
{
  p->f_namemax = f_namemax;
}
