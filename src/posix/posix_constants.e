indexing

	description: "Posix symbolic constants"

	usage: "Inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


class

	POSIX_CONSTANTS


inherit

	STDC_CONSTANTS


feature -- Error codes

	E2BIG: INTEGER is
			-- Arg list too long
		external "C"
		alias "const_e2big"
		end

	EACCES: INTEGER is
			-- Permission denied
		external "C"
		alias "const_eacces"
		end

	EAGAIN, EWOULDBLOCK: INTEGER is
			-- Resource temporarily unavailable
		external "C"
		alias "const_eagain"
		end

	EBADF: INTEGER is
			-- Bad file descriptor
		external "C"
		alias "const_ebadf"
		end

	EBUSY: INTEGER is
			-- Resource busy
		external "C"
		alias "const_ebusy"
		end

	ECANCELED: INTEGER is
			-- Operation canceled
		external "C"
		alias "const_ecanceled"
		end

	ECHILD: INTEGER is
			-- No child processes
		external "C"
		alias "const_echild"
		end

	EDEADLK: INTEGER is
			-- Resource deadlock avoided
		external "C"
		alias "const_edeadlk"
		end

	EEXIST: INTEGER is
			-- File exists
		external "C"
		alias "const_eexist"
		end

	EFAULT: INTEGER is
			-- Bad address
		external "C"
		alias "const_efault"
		end

	EFBIG: INTEGER is
			-- File too large
		external "C"
		alias "const_efbig"
		end

	EINPROGRESS: INTEGER is
			-- Operation in progress
		external "C"
		alias "const_einprogress"
		end

	EINTR: INTEGER is
			-- Interrupted function call
		external "C"
		alias "const_eintr"
		end

	EINVAL: INTEGER is
			-- Invalid argument
		external "C"
		alias "const_einval"
		end

	EIO: INTEGER is
			-- Input/output error
		external "C"
		alias "const_eio"
		end

	EISDIR: INTEGER is
			-- Is a directory
		external "C"
		alias "const_eisdir"
		end

	EMLINK: INTEGER is
			-- Too many links
		external "C"
		alias "const_emlink"
		end

	EMSGSIZE: INTEGER is
			-- Inappropriate message buffer length
		external "C"
		alias "const_emsgsize"
		end

	ENAMETOOLONG: INTEGER is
			-- Filename too long
		external "C"
		alias "const_enametoolong"
		end

	ENFILE: INTEGER is
			-- Too many open files in system
		external "C"
		alias "const_enfile"
		end

	ENODEV: INTEGER is
			-- No such device
		external "C"
		alias "const_enodev"
		end

	ENOENT: INTEGER is
			-- No such file or directory
		external "C"
		alias "const_enoent"
		end

	ENOEXEC: INTEGER is
			-- Exec format error
		external "C"
		alias "const_enoexec"
		end

	ENOLCK: INTEGER is
			-- No locks available
		external "C"
		alias "const_enolck"
		end

	ENOMEM: INTEGER is
			-- Not enough space
		external "C"
		alias "const_enomem"
		end

	ENOSPC: INTEGER is
			-- There is no free space remaining on the device
		external "C"
		alias "const_enospc"
		end

	ENOSYS: INTEGER is
			-- Function not implemented
		external "C"
		alias "const_enosys"
		end

	ENOTDIR: INTEGER is
			-- Not a directory
		external "C"
		alias "const_enotdir"
		end

	ENOTEMPTY: INTEGER is
			-- Directory not empty
		external "C"
		alias "const_enotempty"
		end

	ENOTSUP: INTEGER is
			-- Not supported
		external "C"
		alias "const_enotsup"
		end

	ENOTTY: INTEGER is
			-- Inappropriate I/O control operation
		external "C"
		alias "const_enotty"
		end

	ENXIO: INTEGER is
			-- No such device or address
		external "C"
		alias "const_enxio"
		end

	EPERM: INTEGER is
			-- Operation not permitted
		external "C"
		alias "const_eperm"
		end

	EPIPE: INTEGER is
			-- Broken pipe
		external "C"
		alias "const_epipe"
		end

	EROFS: INTEGER is
			-- Read-only file system
		external "C"
		alias "const_erofs"
		end

	ESPIPE: INTEGER is
			-- Invalid seek;
			-- An lseek() function was issued on a pipe or FIFO.
		external "C"
		alias "const_espipe"
		end

	ESRCH: INTEGER is
			-- No such process
		external "C"
		alias "const_esrch"
		end

	ETIMEDOUT: INTEGER is
			-- Operation timed out
		external "C"
		alias "const_etimedout"
		end

	EXDEV: INTEGER is
			-- Improper link;
			-- A link to a file on another file system was attempted.
		external "C"
		alias "const_exdev"
		end


feature -- standard file numbers

	STDERR_FILENO: INTEGER is
		external "C"
		alias "const_stderr_fileno"
		end

	STDIN_FILENO: INTEGER is
		external "C"
		alias "const_stdin_fileno"
		end

	STDOUT_FILENO: INTEGER is
		external "C"
		alias "const_stdout_fileno"
		end


feature -- posix open symbolic constants

	O_APPEND: INTEGER is
			-- Set the file offset to the end-of-file prior to each write
		external "C"
		alias "const_o_append"
		end

	O_CREAT: INTEGER is
			-- If the file does not exist, allow it to be created. This
			-- flag indicates that the mode argument is present in the
			-- call to open.
		external "C"
		alias "const_o_creat"
		end

	O_DSYNC: INTEGER is
			-- Write according to synchronized i/o data integrity completion
		external "C"
		alias "const_o_dsync"
		end

	O_EXCL, O_EXCLUSIVE: INTEGER is
			-- Open fails if the file already exists
		external "C"
		alias "const_o_excl"
		end

	O_NOCTTY: INTEGER is
			-- prevents terminal from becoming the controlling terminal
			-- for this process
		external "C"
		alias "const_o_noctty"
		end

	O_NONBLOCK: INTEGER is
			-- Do not wait for device or file to be ready or available
		external "C"
		alias "const_o_nonblock"
		end

	O_RDONLY: INTEGER is
			-- Open for reading only
		external "C"
		alias "const_o_rdonly"
		end

	O_RDWR: INTEGER is
			-- Open fo reading and writing
		external "C"
		alias "const_o_rdwr"
		end

	O_RSYNC: INTEGER is
			-- Synchronized read i/o operations
		external "C"
		alias "const_o_rsync"
		end

	O_SYNC: INTEGER is
			-- Write according to synchronized i/o file integrity completion
		external "C"
		alias "const_o_sync"
		end

	O_TRUNC: INTEGER is
			-- Use only on ordinary files opened for writing. It causes
			-- the file to be truncated to zero length.
		external "C"
		alias "const_o_trunc"
		end

	O_WRONLY: INTEGER is
			-- Open for writing only
		external "C"
		alias "const_o_wronly"
		end


feature -- posix permission symbolic constants

	S_IRUSR, S_IREAD: INTEGER is
		external "C"
		alias "const_s_irusr"
		end

	S_IWUSR, S_IWRITE: INTEGER is
		external "C"
		alias "const_s_iwusr"
		end

	S_IXUSR, S_IEXEC: INTEGER is
		external "C"
		alias "const_s_ixusr"
		end

	S_IRGRP: INTEGER is
		external "C"
		alias "const_s_irgrp"
		end

	S_IWGRP: INTEGER is
		external "C"
		alias "const_s_iwgrp"
		end

	S_IXGRP: INTEGER is
		external "C"
		alias "const_s_ixgrp"
		end

	S_IROTH: INTEGER is
		external "C"
		alias "const_s_iroth"
		end

	S_IWOTH: INTEGER is
		external "C"
		alias "const_s_iwoth"
		end

	S_IXOTH: INTEGER is
		external "C"
		alias "const_s_ixoth"
		end

	S_ISUID: INTEGER is
		external "C"
		alias "const_s_isuid"
		end

	S_ISGID: INTEGER is
		external "C"
		alias "const_s_isgid"
		end


feature -- Posix accessibility constants

	F_OK: INTEGER is
		external "C"
		alias "const_f_ok"
		end

	R_OK: INTEGER is
		external "C"
		alias "const_r_ok"
		end

	W_OK: INTEGER is
		external "C"
		alias "const_w_ok"
		end

	X_OK: INTEGER is
		external "C"
		alias "const_x_ok"
		end


feature -- Posix signal constants

	SA_NOCLDSTOP: INTEGER is
		external "C"
		alias "const_sa_nocldstop"
		end

	SIGHUP, SIGNAL_HANGUP: INTEGER is
			-- hangup detected on controlling terminal or death of
			-- controlling process
		external "C"
		alias "const_sighup"
		end

	SIGALRM, SIGNAL_ALARM: INTEGER is
			-- Timeout signal, such as initiated by the alarm() function
			-- or see POSIX_TIMED_COMMAND
		external "C"
		alias "const_sigalrm"
		end

	SIGCHLD, SIGNAL_CHILD: INTEGER is
			-- Child process terminated or stopped
		external "C"
		alias "const_sigchld"
		end

	SIGKILL, SIGNAL_KILL: INTEGER is
			-- Termination signal (cannot be caught or ignored)
		external "C"
		alias "const_sigkill"
		end

	SIGPIPE, SIGNAL_PIPE: INTEGER is
			-- Write on a pipe with no readers
		external "C"
		alias "const_sigpipe"
		end

	SIGQUIT, SIGNAL_QUIT: INTEGER is
			-- Interactive termination signal
		external "C"
		alias "const_sigalrm"
		end

	SIGCONT, SIGNAL_CONTINUE: INTEGER is
			-- Continue if stopped
		external "C"
		alias "const_sigcont"
		end

	SIGSTOP, SIGNAL_STOP: INTEGER is
			-- Stop signal, cannot be caught or ignored
		external "C"
		alias "const_sigstop"
		end

	SIGTSTP, SIGNAL_INTERACTIVE_STOP: INTEGER is
			-- Interactive stop signal
		external "C"
		alias "const_sigtstp"
		end

	SIGTTIN, SIGNAL_TERMINAL_IN: INTEGER is
			-- Read from control terminal attempted by a member of a
			-- background process group
		external "C"
		alias "const_sigttin"
		end

	SIGTTOU, SIGNAL_TERMINAL_OUT: INTEGER is
			-- Write to control terminal attempted by a member of a
			-- background process group
		external "C"
		alias "const_sigttou"
		end


feature -- sigprocmask how values

	SIG_BLOCK: INTEGER is
		external "C"
		alias "const_sig_block"
		end

	SIG_UNBLOCK: INTEGER is
		external "C"
		alias "const_sig_unblock"
		end

	SIG_SETMASK: INTEGER is
		external "C"
		alias "const_sig_setmask"
		end

feature -- Posix pathconf constants

	PC_NAME_MAX: INTEGER is
			-- The maximum length of a filename for this directory
		external "C"
		alias "const_pc_name_max"
		end


feature -- terminal i/o local mode flags

	ISIG: INTEGER is
		external "C"
		alias "const_isig"
		end

	ICANON: INTEGER is
		external "C"
		alias "const_icanon"
		end

	ECHO: INTEGER is
			-- If set, input characters are echoed back to the terminal
		external "C"
		alias "const_echo"
		end

	ECHOE: INTEGER is
		external "C"
		alias "const_echoe"
		end

	ECHOK: INTEGER is
		external "C"
		alias "const_echok"
		end

	ECHONL: INTEGER is
		external "C"
		alias "const_echonl"
		end

	NOFLSH: INTEGER is
		external "C"
		alias "const_noflsh"
		end

	TOSTOP: INTEGER is
		external "C"
		alias "const_tostop"
		end

	IEXTEN: INTEGER is
		external "C"
		alias "const_iexten"
		end


feature -- set terminal settings options

	Tcsanow: INTEGER is
		external "C"
		alias "const_tcsanow"
		end

	Tcsadrain: INTEGER is
		external "C"
		alias "const_tcsadrain"
		end

	Tcsaflush: INTEGER is
		external "C"
		alias "const_tcsaflush"
		end


feature -- Semaphore constants

	SEM_VALUE_MAX: INTEGER is
			-- Valid maximum initial value for a semaphore.
		do
			-- Because value is UINT, it can be something negative, in that
			-- case map it to Eiffel's max int.
			Result := DO_SEM_VALUE_MAX
			if Result < 0 then
				Result := 2147483647
			end
		ensure
			sem_value_max_not_negative: Result >= 0
		end


feature {NONE} -- Semaphore constants, internal

	DO_SEM_VALUE_MAX: INTEGER is
			-- Valid maximum initial value for a semaphore.
		external "C"
		alias "const_sem_value_max"
		end


feature -- terminal baud rates

	B0: INTEGER is
		external "C"
		alias "const_b0"
		end

	B50: INTEGER is
		external "C"
		alias "const_b50"
		end

	B75: INTEGER is
		external "C"
		alias "const_b75"
		end

	B110: INTEGER is
		external "C"
		alias "const_b110"
		end

	B134: INTEGER is
		external "C"
		alias "const_b134"
		end

	B150: INTEGER is
		external "C"
		alias "const_b150"
		end

	B200: INTEGER is
		external "C"
		alias "const_b200"
		end

	B300: INTEGER is
		external "C"
		alias "const_b300"
		end

	B600: INTEGER is
		external "C"
		alias "const_b600"
		end

	B1200: INTEGER is
		external "C"
		alias "const_b1200"
		end

	B1800: INTEGER is
		external "C"
		alias "const_b1800"
		end

	B2400: INTEGER is
		external "C"
		alias "const_b2400"
		end

	B4800: INTEGER is
		external "C"
		alias "const_b4800"
		end

	B9600: INTEGER is
		external "C"
		alias "const_b9600"
		end

	B19200: INTEGER is
		external "C"
		alias "const_b19200"
		end

	B38400: INTEGER is
		external "C"
		alias "const_b38400"
		end

	B57600: INTEGER is
		external "C"
		alias "const_b57600"
		end

	B115200: INTEGER is
		external "C"
		alias "const_b115200"
		end

	B230400: INTEGER is
		external "C"
		alias "const_b230400"
		end


feature -- terminal i/o control mode constants

	CSIZE: INTEGER is
		external "C"
		alias "const_csize"
		end

	CS5: INTEGER is
		external "C"
		alias "const_cs5"
		end

	CS6: INTEGER is
		external "C"
		alias "const_cs6"
		end

	CS7: INTEGER is
		external "C"
		alias "const_cs7"
		end

	CS8: INTEGER is
		external "C"
		alias "const_cs8"
		end

	CSTOPB: INTEGER is
		external "C"
		alias "const_cstopb"
		end

	CREAD: INTEGER is
		external "C"
		alias "const_cread"
		end

	PARENB: INTEGER is
		external "C"
		alias "const_parenb"
		end

	PARODD: INTEGER is
		external "C"
		alias "const_parodd"
		end

	HUPCL: INTEGER is
		external "C"
		alias "const_hupcl"
		end

	CLOCAL: INTEGER is
		external "C"
		alias "const_clocal"
		end


feature -- terminal i/o input control flags

	IGNBRK: INTEGER is
		external "C"
		alias "const_ignbrk"
		end

	BRKINT: INTEGER is
		external "C"
		alias "const_brkint"
		end

	IGNPAR: INTEGER is
		external "C"
		alias "const_ignpar"
		end

	PARMRK: INTEGER is
		external "C"
		alias "const_parmrk"
		end

	INPCK: INTEGER is
		external "C"
		alias "const_inpck"
		end

	ISTRIP: INTEGER is
		external "C"
		alias "const_istrip"
		end

	INLCR: INTEGER is
		external "C"
		alias "const_inlcr"
		end

	IGNCR: INTEGER is
		external "C"
		alias "const_igncr"
		end

	ICRNL: INTEGER is
		external "C"
		alias "const_icrnl"
		end

	IXON: INTEGER is
		external "C"
		alias "const_ixon"
		end

	IXOFF: INTEGER is
		external "C"
		alias "const_ixoff"
		end


feature -- category constants

	LC_MESSAGES: INTEGER is
		external "C"
		alias "const_lc_messages"
		end


feature -- pathname variable values

	MAX_INPUT: INTEGER is
			-- Minimum number of bytes for which space will be available
			-- in a terminal input queue; therefore, the maximum number
			-- of bytes a portable application may required to be typed
			-- as input before eading them
		external "C"
		alias "const_path_max"
		end

	NAME_MAX: INTEGER is
			-- Maximum number of bytes in a file name
		external "C"
		alias "const_path_max"
		end

	PATH_MAX: INTEGER is
			-- Maximum number of bytes in a pathname
		external "C"
		alias "const_path_max"
		end

	PIPE_BUF: INTEGER is
			-- Maximum number of bytes that can be written atomically
			-- when writing to a pipe.
		external "C"
		alias "const_pipe_buf"
		end


feature -- invariant values

	SSIZE_MAX: INTEGER is
			-- The maximum value that can be stored in an object of type ssize_t
		external "C"
		alias "const_ssize_max"
		end


feature -- Other limits

	STREAM_MAX: INTEGER is
			-- The number of streams that one process can have open at
			-- one time. If defined, it has the same value as {FOPEN_MAX}.
		external "C"
		alias "const_stream_max"
		end


end
