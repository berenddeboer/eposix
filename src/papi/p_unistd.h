/*

Access to Posix unistd.h header

*/


#ifndef _P_UNISTD_H_
#define _P_UNISTD_H_


#include "p_defs.h"

/* must declare environ in case I want to have access to it */
extern char **environ;

#include <sys/types.h>
#include <unistd.h>
#include "../supportc/eiffel.h"


/* miscellaneous */

EIF_INTEGER posix_alarm(EIF_INTEGER seconds);
EIF_POINTER posix_environ();
EIF_INTEGER posix_execvp(EIF_POINTER file, EIF_POINTER argv);
void posix__exit(EIF_INTEGER status);
EIF_INTEGER posix_fork();
EIF_POINTER posix_getlogin();
EIF_INTEGER posix_pause();
EIF_INTEGER posix_sleep(EIF_INTEGER seconds);
EIF_INTEGER posix_sysconf(EIF_INTEGER name);

/* functions with have a path as argument */

EIF_INTEGER posix_access(EIF_POINTER path, EIF_INTEGER amode);
EIF_INTEGER posix_chdir(EIF_POINTER path);
EIF_INTEGER posix_chown(EIF_POINTER path, EIF_INTEGER owner, EIF_INTEGER group);
EIF_POINTER posix_getcwd(EIF_POINTER buf, EIF_INTEGER size);
EIF_INTEGER posix_link(EIF_POINTER existing, EIF_POINTER new);
EIF_INTEGER posix_pathconf(EIF_POINTER path, EIF_INTEGER name);
EIF_INTEGER posix_rmdir(EIF_POINTER path);
EIF_INTEGER posix_unlink(EIF_POINTER path);

/* functions which have a file descriptor as argument */

EIF_INTEGER posix_close(EIF_INTEGER fildes);
EIF_INTEGER posix_dup(EIF_INTEGER fildes);
EIF_INTEGER posix_dup2(EIF_INTEGER fildes, EIF_INTEGER fildes2);
EIF_INTEGER posix_fdatasync(EIF_INTEGER fildes);
EIF_INTEGER posix_fpathconf(EIF_INTEGER fildes, EIF_INTEGER name);
EIF_INTEGER posix_fsync(EIF_INTEGER fildes);
EIF_BOOLEAN posix_isatty(EIF_INTEGER fildes);
EIF_INTEGER posix_lseek(EIF_INTEGER fildes, EIF_INTEGER offset, EIF_INTEGER whence);
EIF_INTEGER posix_pipe(EIF_POINTER fildes);
EIF_INTEGER posix_read(EIF_INTEGER fildes, EIF_POINTER buf, EIF_INTEGER nbyte);
EIF_POINTER posix_ttyname(EIF_INTEGER fildes);
EIF_INTEGER posix_write(EIF_INTEGER fildes, EIF_POINTER buf, EIF_INTEGER nbyte);

/* process id */

EIF_INTEGER posix_getpid();
EIF_INTEGER posix_getppid();

/* user and group id's */

EIF_INTEGER posix_getegid();
EIF_INTEGER posix_geteuid();
EIF_INTEGER posix_getgid();
EIF_INTEGER posix_getgroups(EIF_INTEGER gidsetsize, EIF_POINTER grouplist);
EIF_INTEGER posix_getpgrp();
EIF_INTEGER posix_getuid();

EIF_INTEGER posix_setgid(EIF_INTEGER gid);
EIF_INTEGER posix_setpgid(EIF_INTEGER pid, EIF_INTEGER pgid);
EIF_INTEGER posix_setsid();
EIF_INTEGER posix_setuid(EIF_INTEGER uid);

EIF_INTEGER posix_group_item(gid_t grouplist[], EIF_INTEGER item);

/* sysconf constants */

EIF_INTEGER posix_sc_arg_max();
EIF_INTEGER posix_sc_child_max();
EIF_INTEGER posix_sc_clk_tck();
EIF_INTEGER posix_sc_ngroups_max();
EIF_INTEGER posix_sc_stream_max();
EIF_INTEGER posix_sc_tzname_max();
EIF_INTEGER posix_sc_open_max();
EIF_INTEGER posix_sc_pagesize();
EIF_INTEGER posix_sc_job_control();
EIF_INTEGER posix_sc_saved_ids();
EIF_INTEGER posix_sc_version();


/* fpathconf constants */

EIF_INTEGER const_pc_link_max();
EIF_INTEGER const_pc_max_canon();
EIF_INTEGER const_pc_max_input();
EIF_INTEGER const_pc_name_max();
EIF_INTEGER const_pc_path_max();
EIF_INTEGER const_pc_pipe_buf();
EIF_INTEGER const_pc_chown_restricted();
EIF_INTEGER const_pc_no_trunc();
EIF_INTEGER const_pc_vdisable();

/* accessibility constants */

EIF_INTEGER const_f_ok();
EIF_INTEGER const_r_ok();
EIF_INTEGER const_w_ok();
EIF_INTEGER const_x_ok();

/* capability constants */

EIF_BOOLEAN posix_asynchronous_io();
EIF_BOOLEAN def_fsync();
EIF_BOOLEAN posix_mapped_files();
EIF_BOOLEAN posix_memlock();
EIF_BOOLEAN posix_memlock_range();
EIF_BOOLEAN posix_memory_protection();
EIF_BOOLEAN posix_message_passing();
EIF_BOOLEAN posix_priority_scheduling();
EIF_BOOLEAN posix_semaphores();
EIF_BOOLEAN posix_shared_memory_objects();
EIF_BOOLEAN def_synchronized_io();
EIF_BOOLEAN posix_timers();
EIF_BOOLEAN posix_threads();

/* standard file descriptors */

EIF_INTEGER const_stderr_fileno();
EIF_INTEGER const_stdin_fileno();
EIF_INTEGER const_stdout_fileno();


#endif /* _P_UNISTD_H_ */
