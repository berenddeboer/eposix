dnl Process this file with autoconf to produce a configure script
AC_INIT(eposix, 3.2.1)
AC_CONFIG_SRCDIR(src/supportc/c_support.c)
AC_CONFIG_AUX_DIR(config)
AC_DISABLE_SHARED
AM_INIT_AUTOMAKE
AM_CONFIG_HEADER(src/supportc/config.h)
AC_CONFIG_MACRO_DIR([m4])

#
# Checks for programs.
#
AC_PROG_INSTALL
AC_PROG_CC
AC_C_CONST
AC_PROG_LIBTOOL


# check for eposix variable, should point to this directory
if test "x$EPOSIX" = "x"; then
  AC_MSG_ERROR(The EPOSIX environment variable is undefined)
fi
if test "$EPOSIX/configure" != "`pwd`/configure"; then
  EXPECTED_DIR=`pwd`
  AC_MSG_ERROR(The EPOSIX environment variable does not point to the directory from which you run configure (expected $EXPECTED_DIR, but got $EPOSIX))
fi

# We need Gobo as well.
AC_PROG_GOBO

# Optional OS flag
AC_ARG_WITH(os,
 [  --with-os=os What OS specific APIs do you want use? linux (lowercase!)],
 EPOSIX_OS=$withval, EPOSIX_OS=)

# Depending on OS, we set conditionals to link in OS specific code
AM_CONDITIONAL(LINUX, test "x$EPOSIX_OS" = "xlinux")


# Optional multi-threaded flag
# --enable-multi-thread
AC_ARG_ENABLE(threads,
	AC_HELP_STRING([--enable-threads],[enable multi-threading
	(default=no)]),
	[ multithread="${enableval}" ], [ multithread=no ] )
AC_SUBST(OPTIONAL_MULTITHREAD_FLAG)
if test "x$multithread" = "xyes"
then
  # Only support ISE here...
  OPTIONAL_MULTITHREAD_FLAG="-DEIF_THREADS -DEIF_POSIX_THREADS"
fi
AM_CONDITIONAL(THREADS, test "x$multithread" = "xyes")

#
# Checks for libraries.
#


#
# Checks for header files.
#
# If a test is commented out this means autoscan has detected it,
# but I've not written a test/workaround for it.
# And even if it isn't commented out, I might not have written a
# test/workaround. Systems that don't have this really standard stuff
# are getting rare I assume.
# src/capi
AC_HEADER_STDC
AC_CHECK_HEADERS([locale.h stdlib.h string.h sys/time.h])
# src/papi
AC_HEADER_DIRENT
AC_HEADER_SYS_WAIT
# Not everyone seems to have semaphore.h
AC_CHECK_HEADERS([fcntl.h limits.h locale.h semaphore.h termios.h unistd.h utime.h])
# src/sapi
# sys/un.h is for BeOS, check for Unix socket support
# netinet/ip.h isn't in susv3 but still useful
AC_CHECK_HEADERS([arpa/inet.h netdb.h netinet/in.h netinet/in_systm.h netinet/ip.h stdlib.h sys/select.h sys/socket.h sys/time.h sys/un.h syslog.h unistd.h stropts.h sys/ioctl.h])
#
# Checks for typedefs, structures, and compiler characteristics.
#
# src/capi
AC_STRUCT_TM
# src/papi
AC_TYPE_UID_T
AC_C_VOLATILE
# src/sapi
AC_TYPE_SIZE_T
AC_CHECK_MEMBERS([struct stat.st_blksize])
AC_CHECK_MEMBERS([struct timespec.tv_nsec])
AC_STRUCT_ST_BLOCKS
AC_HEADER_TIME

#
# Checks for library functions.
#
# if a test is commented out this means autoscan has detected it,
# but I've not written a test/workaround for it.
# src/capi
AC_FUNC_MALLOC
AC_FUNC_MKTIME
AC_FUNC_REALLOC
AC_FUNC_SETVBUF_REVERSED
AC_TYPE_SIGNAL
AC_FUNC_STRFTIME
AC_CHECK_FUNCS([atexit localeconv memmove memset setlocale strerror])
# src/papi
AC_FUNC_CHOWN
AC_FUNC_CLOSEDIR_VOID
#AC_FUNC_FORK
AC_FUNC_GETGROUPS
AC_FUNC_GETPGRP
AC_FUNC_MMAP
AC_FUNC_STAT
AC_FUNC_UTIME_NULL
AC_CHECK_FUNCS([aio_fsync alarm dup2 fdatasync getcwd mkdir mkfifo munmap pathconf rmdir uname utime])
# src/sapi
AC_FUNC_LSTAT
AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK
# getservbyport not available on BeOS?
# configure for clock_getres clock_gettime clock_settime on Linux fails
# seems I have to set _POSIX_SOURCE or so before I see them.
AC_CHECK_FUNCS([getcwd gethostbyaddr gethostbyname gethostname getservbyport gettimeofday inet_ntoa memmove putenv realpath socket usleep])


#
# Automake
#
AC_OUTPUT( \
  Makefile
  doc/Makefile \
  ise_precompile/Makefile \
  src/Makefile \
  src/supportc/Makefile \
  src/capi/Makefile \
  src/standardc/Makefile \
  src/epxc/Makefile \
  src/epxc/imap4/Makefile \
  src/epxc/ldap/Makefile \
  src/epxc/mime/Makefile \
  src/papi/Makefile \
  src/posix/Makefile \
  src/sapi/Makefile \
  src/sus/Makefile \
  src/wapi/Makefile \
  src/windows/Makefile \
  src/epxw/Makefile \
  src/spec/Makefile \
  src/spec/lapi/Makefile \
  test_suite/Makefile)

# Final output

AC_MSG_RESULT([Eiffel vendor           : $GOBO_EIFFEL])
AC_MSG_RESULT([Eiffel compiler         : $EC])
AC_MSG_RESULT([multi-threading support : $multithread])
