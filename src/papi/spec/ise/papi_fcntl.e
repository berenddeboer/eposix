indexing

	description: "Class that covers Posix fcntl.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	PAPI_FCNTL


feature {NONE} -- C binding functions

	posix_create (a_path: POINTER; oflag, mode: INTEGER): INTEGER is
			-- Creates a new file or rewrites an existing one
			-- does not call `creat' but `open'!

		external "C blocking"



		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_fcntl (fildes: INTEGER; cmd: INTEGER): INTEGER is
			-- Manipulates an open file descriptor

		external "C blocking"



		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_fcntl_arg (fildes, cmd, arg: INTEGER): INTEGER is
			-- `posix_fcntl' with 3rd argument

		external "C blocking"



		end

	posix_fcntl_lock (fildes, cmd: INTEGER; lock: POINTER): INTEGER is
			-- Set/get locks for an open file descriptor

		external "C blocking"



		end

	posix_open (a_path: POINTER; oflag: INTEGER): INTEGER is
			-- Opens a file

		external "C blocking"



		ensure
			-- Result = -1 implies errno.is_not_ok
		end


feature {NONE} -- constants

	F_RDLCK: INTEGER is
		external "C"
		alias "const_f_rdlck"
		end

	F_WRLCK: INTEGER is
		external "C"
		alias "const_f_wrlck"
		end

	F_UNLCK: INTEGER is
		external "C"
		alias "const_f_unlck"
		end


feature {NONE} -- C binding

	F_DUPFD: INTEGER is
		external "C"
		alias "const_f_dupfd"
		end

	F_GETFD: INTEGER is
		external "C"
		alias "const_f_getfd"
		end

	F_SETFD: INTEGER is
		external "C"
		alias "const_f_setfd"
		end

	F_GETFL: INTEGER is
		external "C"
		alias "const_f_getfl"
		end

	F_SETFL: INTEGER is
		external "C"
		alias "const_f_setfl"
		end

	F_GETLK: INTEGER is
		external "C"
		alias "const_f_getlk"
		end

	F_SETLK: INTEGER is
		external "C"
		alias "const_f_setlk"
		end

	F_SETLKW: INTEGER is
		external "C"
		alias "const_f_setlkw"
		end


feature {NONE}  -- file descriptor flags

	FD_CLOEXEC: INTEGER is
		external "C"
		alias "const_fd_cloexec"
		end


feature {NONE} -- flock structure

	posix_flock_size: INTEGER is
			-- size of flock struct
		external "C"
		end

	posix_flock_type (a_lock: POINTER): INTEGER is
		external "C"
		end

	posix_flock_whence (a_lock: POINTER): INTEGER is
		external "C"
		end

	posix_flock_start (a_lock: POINTER): INTEGER is
		external "C"
		end

	posix_flock_len (a_lock: POINTER): INTEGER is
		external "C"
		end

	posix_flock_pid (a_lock: POINTER): INTEGER is
		external "C"
		end

	posix_set_flock_type (a_lock: POINTER; a_type: INTEGER) is
		external "C"
		end

	posix_set_flock_whence (a_lock: POINTER; a_whence: INTEGER) is
		external "C"
		end

	posix_set_flock_start (a_lock: POINTER; a_start: INTEGER) is
		external "C"
		end

	posix_set_flock_len (a_lock: POINTER; a_len: INTEGER) is
		external "C"
		end


end -- class PAPI_FCNTL
