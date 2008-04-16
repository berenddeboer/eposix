indexing

	description: "Standard C symbolic constants."

	usage: "All constants are placed in a separate class so they can be %
	%easily used in other classes by facility inheritance."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	STDC_CONSTANTS


feature -- Error codes

	EDOM: INTEGER is
		-- Math argument out of domain of function
		external "C"
		alias "const_edom"
		end

	ERANGE: INTEGER is
		-- Math result not representable
		external "C"
		alias "const_erange"
		end

	EMFILE: INTEGER is
			-- Too many open files
		external "C"
		alias "const_emfile"
		end


feature -- Standard streams

	stream_stdin: POINTER is
		external "C"
		end

	stream_stdout: POINTER is
		external "C"
		end

	stream_stderr: POINTER is
		external "C"
		end


feature -- Special characters

  const_EOF: INTEGER is
			-- signals EOF
		external "C"
		alias "const_eof"
		end


feature -- I/O buffering

  IOFBF: INTEGER is
			-- full buffering
		external "C"
		alias "const_iofbf"
		end

  IOLBF: INTEGER is
			-- line buffering
		external "C"
		alias "const_iolbf"
		end

  IONBF: INTEGER is
			-- no buffering
		external "C"
		alias "const_ionbf"
		end


feature -- file positioning

	SEEK_SET: INTEGER is
		external "C"
		alias "const_seek_set"
		end

	SEEK_CUR: INTEGER is
		external "C"
		alias "const_seek_cur"
		end

	SEEK_END: INTEGER is
		external "C"
		alias "const_seek_end"
		end


feature -- Signal related constants

	SIG_DFL: POINTER is
		external "C"
		alias "const_sig_dfl"
		end

	SIG_ERR: POINTER is
		external "C"
		alias "const_sig_err"
		end

	SIG_IGN: POINTER is
		external "C"
		alias "const_sig_ign"
		end


feature -- Signals

	SIGABRT: INTEGER is
		external "C"
		alias "const_sigabrt"
		end

	SIGFPE: INTEGER is
			-- erroneous arithmetic operation, such as zero divide or an
			-- operation resulting in overflow
		external "C"
		alias "const_sigfpe"
		end

	SIGILL: INTEGER is
			-- illegal instruction
		external "C"
		alias "const_sigill"
		end

	SIGINT: INTEGER is
			-- receipt of an interactive attention signal
		external "C"
		alias "const_sigint"
		end

	SIGSEGV: INTEGER is
			-- invalid access to storage
		external "C"
		alias "const_sigsegv"
		end

	SIGTERM: INTEGER is
			-- Request process to terminate; can be caught or ignored
		external "C"
		alias "const_sigterm"
		end


feature -- random numbers

	RAND_MAX: INTEGER is
			-- maximum value returned by the `random' function
		external "C"
		alias "const_rand_max"
		end


feature -- category constants

	LC_CTYPE: INTEGER is
		external "C"
		alias "const_lc_ctype"
		end

	LC_NUMERIC: INTEGER is
		external "C"
		alias "const_lc_numeric"
		end

	LC_TIME: INTEGER is
		external "C"
		alias "const_lc_time"
		end

	LC_COLLATE: INTEGER is
		external "C"
		alias "const_lc_collate"
		end

	LC_MONETARY: INTEGER is
		external "C"
		alias "const_lc_monetary"
		end

	LC_ALL: INTEGER is
		external "C"
		alias "const_lc_all"
		end


feature -- various

	CLOCKS_PER_SEC: INTEGER is
		external "C"
		alias "const_clocks_per_sec"
		end


feature -- exit codes

	EXIT_FAILURE: INTEGER is
			-- exit status when something has gone wrong
		external "C"
		alias "const_exit_failure"
		end

	EXIT_SUCCESS: INTEGER is
			-- exit status upon success
		external "C"
		alias "const_exit_success"
		end


end -- class STDC_CONSTANTS
