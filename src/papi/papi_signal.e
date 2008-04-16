indexing

   description: "Class that covers Posix signal.h."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class

   PAPI_SIGNAL


feature {NONE} -- C binding functions

   posix_kill (a_pid: INTEGER; sig: INTEGER): INTEGER is
         -- Sends a signal to a process
      external "C"
      end


feature {NONE} -- C binding for signal set functions

   posix_sigaddset (a_set: POINTER; signo: INTEGER): INTEGER is
         -- Adds a signal to a signal set
      require
         valid_set: a_set /= default_pointer
      external "C"
      end

   posix_sigdelset (a_set: POINTER; signo: INTEGER): INTEGER is
         -- Removes a signal from a signal set
      require
         valid_set: a_set /= default_pointer
      external "C"
      end

   posix_sigemptyset (a_set: POINTER): INTEGER is
         -- Creates an empty signal set
      require
         valid_set: a_set /= default_pointer
      external "C"
      end

   posix_sigfillset (a_set: POINTER): INTEGER is
         -- Creates a full set of signals
      require
         valid_set: a_set /= default_pointer
      external "C"
      end

   posix_sigismember (a_set: POINTER; signo: INTEGER): INTEGER is
         -- Tests a signal set for a selected member
      require
         valid_set: a_set /= default_pointer
      external "C"
      end

   posix_sigpending (a_set: POINTER): INTEGER is
         -- Examines pending signals
      require
         valid_set: a_set /= default_pointer
      external "C"
      end

   posix_sigprocmask (how: INTEGER; new_set, old_set: POINTER): INTEGER is
         -- Examines and changes blocked signals
      require
         valid_set: new_set /= default_pointer
      external "C"
      end

   posix_sigsuspend (set: POINTER): INTEGER is
         -- Waits for a signal
      require
         valid_set: set /= default_pointer
      external "C"
      end

   posix_sigset_size: INTEGER is
      external "C"
      end


feature {NONE} -- struct sigaction

   posix_sa_flags (act: POINTER): INTEGER is
         -- Get struct sigaction member
      external "C"
      end

   posix_sa_handler (act: POINTER): POINTER is
         -- Get struct sigaction member
      external "C"
      end

   posix_set_sa_flags (act: POINTER; a_flags: INTEGER) is
         -- Set struct sigaction member
      external "C"
      end

   posix_set_sa_handler (act: POINTER; a_handler: POINTER) is
         -- Set struct sigaction member
      external "C"
      end

   posix_sigaction(sig: INTEGER; act, oact: POINTER): INTEGER is
         -- Examines and changes signal action
      external "C"
      end

   posix_sigaction_size: INTEGER is
         -- Size of struct sigaction
      external "C"
      end


feature {NONE} -- C binding for members of sigevent

   posix_sigevent_size: INTEGER is
      external "C"
      end

   posix_sigevent_sigev_notify (a_sigevent: POINTER): INTEGER is
      external "C"
      end

   posix_sigevent_sigev_signo (a_sigevent: POINTER): INTEGER is
      external "C"
      end

   posix_set_sigevent_sigev_notify (a_sigevent: POINTER; sigev_notify: INTEGER) is
      external "C"
      end

   posix_set_sigevent_sigev_signo (a_sigevent: POINTER; sigev_signo: INTEGER) is
      external "C"
      end


feature {NONE} -- sigevent notify values

   SIGEV_NONE: INTEGER is
      external "C"
      alias "const_sigev_none"
      end

   SIGEV_SIGNAL: INTEGER is
      external "C"
      alias "const_sigev_signal"
      end

   SIGEV_THREAD: INTEGER is
      external "C"
      alias "const_sigev_thread"
      end


end -- class PAPI_SIGNAL
