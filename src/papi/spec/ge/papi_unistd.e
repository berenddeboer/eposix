indexing

	description: "Class that covers Posix unistd.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	PAPI_UNISTD


feature -- C binding miscellaneous

	posix_alarm (a_seconds: INTEGER): INTEGER is
			-- Schedules an alarm.

		external "C blocking"



		end

	posix_environ: POINTER is
			-- The list of environment variables passed to this program
		external "C"
		end

	posix_execvp (file: POINTER; argv: POINTER): INTEGER is
			-- Executes a program.

		external "C blocking"



		ensure
			-- only_return_on_error: Result = -1
		end

	posix__exit (a_status: INTEGER) is
			-- Cause program termination without calling exit handlers
			-- defined with `atexit'.
			-- `a_status' is returned to its parent.
		external "C"
		end

	posix_fork: INTEGER is
			-- Create a process.

		external "C blocking"



		end

	posix_getlogin: POINTER is
			-- User name
		external "C"
		end

	posix_pause: INTEGER is
			-- Wait for signal.

		external "C blocking"



		end

	posix_sleep (seconds: INTEGER): INTEGER is
			-- Delay process execution.

		external "C blocking"



		end


feature -- functions with path as argument

	posix_access (a_path: POINTER; amode: INTEGER): INTEGER is
			-- Tests for file accessibility
		require
			valid_path: a_path /= default_pointer

		external "C blocking"



		end

	posix_chdir (a_path: POINTER): INTEGER is
			-- Changes the current working directory
		require
			valid_path: a_path /= default_pointer

		external "C blocking"



		end

	posix_chown (a_path: POINTER; a_owner, a_group: INTEGER): INTEGER is
			-- Changes the owner and/or group of a file
		require
			valid_path: a_path /= default_pointer

		external "C blocking"



		end

	posix_getcwd (a_buf: POINTER; a_size: INTEGER): POINTER is
			-- Gets current working directory
		require
			valid_buf: a_buf /= default_pointer
			valid_size: a_size >= 0
		external "C"
		end

	posix_link (existing, new: POINTER): INTEGER is
			-- Creates a link to a file

		external "C blocking"



		end

	posix_rmdir (a_path: POINTER): INTEGER is
			-- Removes a directory
		require
			valid_path: a_path /= default_pointer

		external "C blocking"



		end

	posix_unlink (a_path: POINTER): INTEGER is
			-- Removes a directory entry
		require
			valid_path: a_path /= default_pointer

		external "C blocking"



		end


feature -- C binding file descriptor routines

	posix_close (fildes: INTEGER): INTEGER is
			-- Closes a a file

		external "C blocking"



		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_dup (fildes: INTEGER): INTEGER is
			-- Duplicates an open file descriptor
		external "C"
		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_dup2 (fildes, fildes2: INTEGER): INTEGER is
			-- Duplicates an open file descriptor
		external "C"
		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_fdatasync (fildes: INTEGER): INTEGER is
			-- Synchronize the data of a file

		external "C blocking"



		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_fsync (fildes: INTEGER): INTEGER is
			-- Synchronize the state of a file

		external "C blocking"



		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_fpathconf (fildes: INTEGER; name: INTEGER): INTEGER is
			-- Gets configuration variable for an open file
		external "C"
		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_isatty (fildes: INTEGER): BOOLEAN is
			-- Determines if a file descriptor is associated with a terminal
		external "C"
		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_lseek (fildes: INTEGER; offset, whence: INTEGER): INTEGER is
			-- Repositions read/write file offset
		external "C"
		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_pipe(fildes: POINTER): INTEGER is
			-- Creates an interprocess channel

		external "C blocking"



		end

	posix_read (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Reads from a file
		require
			valid_fd: fildes >= 0

		external "C blocking"



		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_ttyname (fildes: INTEGER): POINTER is
			-- Determines a terminal pathname
		external "C"
		end

	posix_write (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Reads from a file
		require
			valid_fd: fildes >= 0

		external "C blocking"



		ensure
			-- Result = -1 implies errno.is_not_ok
		end


feature -- user and group id's

	posix_getegid: INTEGER is
			-- Gets effective group ID
		external "C"
		end

	posix_geteuid: INTEGER is
			-- Gets effective user ID
		external "C"
		end

	posix_getgid: INTEGER is
			-- Gets real group ID
		external "C"
		end

	posix_getgroups (gidsetsize: INTEGER; grouplist: POINTER): INTEGER is
			-- Gets supplementary group IDs
		require
			valid_size: gidsetsize >= 0
			valid_grouplist: gidsetsize > 0 implies grouplist /= default_pointer
		external "C"
		end

	posix_getpgrp: INTEGER is
			-- Gets process group ID
		external "C"
		end

	posix_getpid: INTEGER is
			-- Gets process ID
		external "C"
		end

	posix_getppid: INTEGER is
			-- Gets parent process ID
		external "C"
		end

	posix_getuid: INTEGER is
			-- Gets real user ID
		external "C"
		end

	posix_group_item (a_grouplist: POINTER; a_item: INTEGER): INTEGER is
			-- Gets a gid from a list returned by `getgroups'
		require
			valid_list: a_grouplist /= default_pointer
			valid_item: a_item >= 0
		external "C"
		end

	posix_setgid(gid: INTEGER): INTEGER is
			-- Sets group ID
		external "C"
		end

	posix_setpgid(pid, pgid: INTEGER): INTEGER is
			-- Sets process group ID for job control
		external "C"
		end

	posix_setsid: INTEGER is
			-- Creates a session and sets the process group ID
		external "C"
		end

	posix_setuid(uid: INTEGER): INTEGER is
			-- Sets user ID
		external "C"
		end


feature -- sysconf, note that -1 will be returned in case functionality is not supported

	posix_sc_arg_max: INTEGER is
			-- The length of the arguments for the exec() function
		external "C"
		end

	posix_sc_child_max: INTEGER is
			-- The number of simultaneous processes per real user ID
		external "C"
		end

	posix_sc_clk_tck: INTEGER is
			-- The number of clock ticks per second
		external "C"
		end

	posix_sc_ngroups_max: INTEGER is
			-- The number of simultaneous supplementary group IDs
		external "C"
		end

	posix_sc_stream_max: INTEGER is
			-- The maximum number of streams that one process can have
			-- open at one time.
		external "C"
		end

	posix_sc_tzname_max: INTEGER is
			-- The maximum number of bytes in a timezone name.
		external "C"
		end

	posix_sc_open_max: INTEGER is
			-- The maximum number of files that one process can have
			-- open at one time.
		external "C"
		end

	posix_sc_pagesize: INTEGER is
			-- granularity in bytes of memory mapping and process memory locking
		external "C"
		end

	posix_sc_job_control: INTEGER is
			-- Job control functions are supported.
		external "C"
		end

	posix_sc_saved_ids: INTEGER is
			-- Each process has a saved set-user-ID and a saved set-group-ID
		external "C"
		end

	posix_sc_version: INTEGER is
			-- Indicates the 4-digit year and 2-digit month that the
			-- standard was approved.
		external "C"
		end


feature -- capability constants

	posix_asynchronous_io: BOOLEAN is
			-- True if _POSIX_ASYNCHRONOUS_IO is defined
		external "C"
		end

	def_fsync: BOOLEAN is
			-- True if _POSIX_FSYNC is defined
		external "C"
		end

	posix_mapped_files: BOOLEAN is
			-- True if _POSIX_MAPPED_FILES is defined
		external "C"
		end

	posix_memlock: BOOLEAN is
			-- True if _POSIX_MEMLOCK is defined
		external "C"
		end

	posix_memlock_range: BOOLEAN is
			-- True if _POSIX_MEMLOCK_RANGE is defined
		external "C"
		end

	posix_memory_protection: BOOLEAN is
			-- True if _POSIX_MEMORY_PROTECTION is defined
		external "C"
		end

	posix_message_passing: BOOLEAN is
			-- True if _POSIX_MESSAGE_PASSING is defined
		external "C"
		end

	posix_priority_scheduling: BOOLEAN is
			-- True if _POSIX_PRIORITY_SCHEDULING is defined
		external "C"
		end

	posix_semaphores: BOOLEAN is
			-- True if _POSIX_SEMAPHORES is defined
		external "C"
		end

	posix_shared_memory_objects: BOOLEAN is
			-- True if _POSIX_SHARED_MEMORY_OBJECTS is defined
		external "C"
		end

	def_synchronized_io: BOOLEAN is
			-- True if _POSIX_SYNCHRONIZED_IO is defined
		external "C"
		end

	posix_timers: BOOLEAN is
			-- True if _POSIX_TIMERS is defined
		external "C"
		end

	posix_threads: BOOLEAN is
			-- True if _POSIX_THREADS is defined
		external "C"
		end


end -- class PAPI_UNISTD
