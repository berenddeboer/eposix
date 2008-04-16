/*

C layer to Posix fcntl.h header

*/

#ifndef _P_FCNTL_H_
#define _P_FCNTL_H_

#include "p_defs.h"
#include <unistd.h>
#include <fcntl.h>
#include "../supportc/eiffel.h"


/* functions which have a file descriptor as argument */

EIF_INTEGER posix_create(EIF_POINTER path, EIF_INTEGER oflag, EIF_INTEGER mode);
EIF_INTEGER posix_fcntl(EIF_INTEGER fildes, EIF_INTEGER cmd);
EIF_INTEGER posix_fcntl_arg(EIF_INTEGER fildes, EIF_INTEGER cmd, EIF_INTEGER arg);
EIF_INTEGER posix_fcntl_lock(EIF_INTEGER fildes, EIF_INTEGER cmd, EIF_POINTER lock);
EIF_INTEGER posix_open(EIF_POINTER path, EIF_INTEGER oflag);


/* flock structure */

EIF_INTEGER posix_flock_size();

EIF_INTEGER posix_flock_type(struct flock *lock);
EIF_INTEGER posix_flock_whence(struct flock *lock);
EIF_INTEGER posix_flock_start(struct flock *lock);
EIF_INTEGER posix_flock_len(struct flock *lock);
EIF_INTEGER posix_flock_pid(struct flock *lock);

void posix_set_flock_type(struct flock *lock, EIF_INTEGER type);
void posix_set_flock_whence(struct flock *lock, EIF_INTEGER whence);
void posix_set_flock_start(struct flock *lock, EIF_INTEGER start);
void posix_set_flock_len(struct flock *lock, EIF_INTEGER len);


/* constants */

EIF_INTEGER const_o_append();
EIF_INTEGER const_o_creat();
EIF_INTEGER const_o_dsync();
EIF_INTEGER const_o_excl();
EIF_INTEGER const_o_noctty();
EIF_INTEGER const_o_nonblock();
EIF_INTEGER const_o_rdonly();
EIF_INTEGER const_o_rdwr();
EIF_INTEGER const_o_rsync();
EIF_INTEGER const_o_sync();
EIF_INTEGER const_o_trunc();
EIF_INTEGER const_o_wronly();

EIF_INTEGER const_f_rdlck();
EIF_INTEGER const_f_wrlck();
EIF_INTEGER const_f_unlck();

EIF_INTEGER const_f_dupfd();
EIF_INTEGER const_f_getfd();
EIF_INTEGER const_f_setfd();
EIF_INTEGER const_f_getfl();
EIF_INTEGER const_f_setfl();
EIF_INTEGER const_f_getlk();
EIF_INTEGER const_f_setlk();
EIF_INTEGER const_f_setlkw();

EIF_INTEGER const_fd_cloexec();

#endif /* _P_FCNTL_H_ */
