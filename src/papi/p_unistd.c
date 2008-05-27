#include "p_unistd.h"


/* miscellaneous */

EIF_INTEGER posix_alarm(EIF_INTEGER seconds)
{
  return alarm(seconds);
}

EIF_POINTER posix_environ()
{
  return (environ);
}

EIF_INTEGER posix_execvp(EIF_POINTER file, EIF_POINTER argv)
{
  return execvp(file, (void *) argv);
}

void posix__exit(EIF_INTEGER status)
{
  _exit(status);
}

EIF_INTEGER posix_fork()
{
#if defined(EIFFEL_VENDOR_ISE) && defined(EIF_THREADS)
  return eif_thread_fork();
#else
  return fork();
#endif
}

EIF_POINTER posix_getlogin()
{
  return getlogin();
}

EIF_INTEGER posix_pause()
{
  return pause();
}

EIF_INTEGER posix_sleep(EIF_INTEGER seconds)
{
  return sleep(seconds);
}

EIF_INTEGER posix_sysconf(EIF_INTEGER name)
{
  return sysconf(name);
}


/* functions with have a path as argument */

EIF_INTEGER posix_access(EIF_POINTER path, EIF_INTEGER amode)
{
  return access(path, amode);
}

EIF_INTEGER posix_chdir(EIF_POINTER path)
{
  return chdir(path);
}

EIF_INTEGER posix_chown(EIF_POINTER path, EIF_INTEGER owner, EIF_INTEGER group)
{
  return chown(path, owner, group);
}

EIF_POINTER posix_getcwd(EIF_POINTER buf, EIF_INTEGER size)
{
  return getcwd(buf, size);
}

EIF_INTEGER posix_link(EIF_POINTER existing, EIF_POINTER new)
{
  return link(existing, new);
}

EIF_INTEGER posix_pathconf(EIF_POINTER path, EIF_INTEGER name)
{
  return pathconf(path, name);
}

EIF_INTEGER posix_rmdir(EIF_POINTER path)
{
  return rmdir(path);
}

EIF_INTEGER posix_unlink(EIF_POINTER path)
{
  return unlink(path);
}


/* functions which have a file descriptor as argument */

EIF_INTEGER posix_close(EIF_INTEGER fildes)
{
  return close(fildes);
}

EIF_INTEGER posix_dup(EIF_INTEGER fildes)
{
  return dup(fildes);
}

EIF_INTEGER posix_dup2(EIF_INTEGER fildes, EIF_INTEGER fildes2)
{
  return dup2(fildes, fildes2);
}

EIF_INTEGER posix_fdatasync(EIF_INTEGER fildes)
{
#ifdef HAVE_FDATASYNC
  return fdatasync(fildes);
#else
  return fsync(fildes);
#endif
}

EIF_INTEGER posix_fpathconf(EIF_INTEGER fildes, EIF_INTEGER name)
{
  return fpathconf(fildes, name);
}

EIF_INTEGER posix_fsync(EIF_INTEGER fildes)
{
  return fsync(fildes);
}

EIF_BOOLEAN posix_isatty(EIF_INTEGER fildes)
{
  return isatty(fildes);
}

EIF_INTEGER posix_lseek(EIF_INTEGER fildes, EIF_INTEGER offset, EIF_INTEGER whence)
{
  return lseek(fildes, offset, whence);
}

EIF_INTEGER posix_pipe(EIF_POINTER fildes)
{
  return pipe((void *)fildes);
}

EIF_INTEGER posix_read(EIF_INTEGER fildes, EIF_POINTER buf, EIF_INTEGER nbyte)
{
  return read(fildes, buf, nbyte);
}

EIF_POINTER posix_ttyname(EIF_INTEGER fildes)
{
  return ttyname(fildes);
}

EIF_INTEGER posix_write(EIF_INTEGER fildes, EIF_POINTER buf, EIF_INTEGER nbyte)
{
  return write(fildes, buf, nbyte);
}


/* process id */

EIF_INTEGER posix_getpid()
{
  return getpid();
}

EIF_INTEGER posix_getppid()
{
  return getppid();
}


/* user and group id's */

EIF_INTEGER posix_getegid()
{
  return getegid();
}

EIF_INTEGER posix_geteuid()
{
  return geteuid();
}

EIF_INTEGER posix_getgid()
{
  return getgid();
}

EIF_INTEGER posix_getgroups(EIF_INTEGER gidsetsize, EIF_POINTER grouplist)
{
  return getgroups(gidsetsize, (void *) grouplist);
}

EIF_INTEGER posix_getpgrp()
{
  return getpgrp();
}

EIF_INTEGER posix_getuid()
{
  return getuid();
}

EIF_INTEGER posix_setgid(EIF_INTEGER gid)
{
  return setgid(gid);
}

EIF_INTEGER posix_setpgid(EIF_INTEGER pid, EIF_INTEGER pgid)
{
  return setpgid(pid, pgid);
}

EIF_INTEGER posix_setsid()
{
  return setsid();
}

EIF_INTEGER posix_setuid(EIF_INTEGER uid)
{
  return setuid(uid);
}

EIF_INTEGER posix_group_item(gid_t grouplist[], EIF_INTEGER item)
{
  return (grouplist[item]);
}


/* sysconf constants */

EIF_INTEGER posix_sc_arg_max()
{
  return sysconf(_SC_ARG_MAX);
}

EIF_INTEGER posix_sc_child_max()
{
  return sysconf(_SC_CHILD_MAX);
}

EIF_INTEGER posix_sc_clk_tck()
{
  return sysconf(_SC_CLK_TCK);
}

EIF_INTEGER posix_sc_ngroups_max()
{
  return sysconf(_SC_NGROUPS_MAX);
}

EIF_INTEGER posix_sc_stream_max()
{
#ifdef _SC_STREAM_MAX
  return sysconf(_SC_STREAM_MAX);
#else
  return _POSIX_STREAM_MAX;
#endif
}

EIF_INTEGER posix_sc_tzname_max()
{
#ifdef _SC_TZNAME_MAX
  return sysconf(_SC_TZNAME_MAX);
#else
  return _POSIX_TZNAME_MAX;
#endif
}

EIF_INTEGER posix_sc_open_max()
{
  return sysconf(_SC_OPEN_MAX);
}

EIF_INTEGER posix_sc_pagesize()
{
#ifdef _SC_PAGESIZE
  return sysconf(_SC_PAGESIZE);
#else
  return 0;
#endif
}

EIF_INTEGER posix_sc_job_control()
{
  return sysconf(_SC_JOB_CONTROL);
}

EIF_INTEGER posix_sc_saved_ids()
{
  return sysconf(_SC_SAVED_IDS);
}

EIF_INTEGER posix_sc_version()
{
  return sysconf(_SC_VERSION);
}


/* fpathconf constants */

EIF_INTEGER const_pc_link_max()
{
  return _PC_LINK_MAX;
}

EIF_INTEGER const_pc_max_canon()
{
  return _PC_MAX_CANON;
}

EIF_INTEGER const_pc_max_input()
{
  return _PC_MAX_INPUT;
}

EIF_INTEGER const_pc_name_max()
{
  return _PC_NAME_MAX;
}

EIF_INTEGER const_pc_path_max()
{
  return _PC_PATH_MAX;
}

EIF_INTEGER const_pc_pipe_buf()
{
  return _PC_PIPE_BUF;
}

EIF_INTEGER const_pc_chown_restricted()
{
  return _PC_CHOWN_RESTRICTED;
}

EIF_INTEGER const_pc_no_trunc()
{
  return _PC_NO_TRUNC;
}

EIF_INTEGER const_pc_vdisable()
{
  return _PC_VDISABLE;
}


/* accessibility constants */

EIF_INTEGER const_f_ok()
{
  return F_OK;
}

EIF_INTEGER const_r_ok()
{
  return R_OK;
}

EIF_INTEGER const_w_ok()
{
  return W_OK;
}

EIF_INTEGER const_x_ok()
{
  return X_OK;
}


/* capability constants */

EIF_BOOLEAN posix_asynchronous_io()
{
#ifdef _POSIX_ASYNCHRONOUS_IO
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_mapped_files()
{
#ifdef _POSIX_MAPPED_FILES
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN def_fsync()
{
#ifdef _POSIX_FSYNC
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_memlock()
{
#ifdef _POSIX_MEMLOCK
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_memlock_range()
{
#ifdef _POSIX_MEMLOCK_RANGE
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_memory_protection()
{
#ifdef _POSIX_MEMORY_PROTECTION
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_message_passing()
{
#ifdef _POSIX_MESSAGE_PASSING
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_priority_scheduling()
{
#ifdef _POSIX_PRIORITY_SCHEDULING
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_semaphores()
{
#ifdef _POSIX_SEMAPHORES
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_shared_memory_objects()
{
#ifdef _POSIX_SHARED_MEMORY_OBJECTS
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN def_synchronized_io()
{
#ifdef _POSIX_SYNCHRONIZED_IO
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_timers()
{
#ifdef _POSIX_TIMERS
  return 1;
#else
  return 0;
#endif
}

EIF_BOOLEAN posix_threads()
{
#ifdef _POSIX_THREADS
  return 1;
#else
  return 0;
#endif
}


/* standard file descriptors */

EIF_INTEGER const_stderr_fileno()
{
#ifdef STDERR_FILENO
  return STDERR_FILENO;
#else
  return 2;
#endif
}

EIF_INTEGER const_stdin_fileno()
{
#ifdef STDIN_FILENO
  return STDIN_FILENO;
#else
  return 0;
#endif
}

EIF_INTEGER const_stdout_fileno()
{
#ifdef STDOUT_FILENO
  return STDOUT_FILENO;
#else
  return 1;
#endif
}
