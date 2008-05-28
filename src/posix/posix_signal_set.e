indexing

   description: "Class that covers a set of POSIX signals."
   
   idea: "Interface based on EiffelBase SET."
   
   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   POSIX_SIGNAL_SET
   
inherit

   POSIX_BASE
   
   PAPI_SIGNAL

   
create
   
   make_empty,
   make_full,
   make_pending

   
feature -- creation, make a set
   
   make_empty is
         -- make an initially empty signal set
      do
         assure_have_set
         safe_call (posix_sigemptyset (set.ptr))
      end

   
   make_full is
         -- make a set where all signals are enabled
      do
         assure_have_set
         safe_call (posix_sigfillset (set.ptr))
      end
   
   make_pending is
         -- this signal set will be the set of signals that are blocked 
         -- and pending
      do
         assure_have_set
         safe_call (posix_sigpending (set.ptr))
      end

   
feature -- change a set
   
   extend, put (signo: INTEGER) is
         -- add signal to set
      do
         safe_call (posix_sigaddset (set.ptr, signo))
      ensure
         is_member: has (signo)
      end

   prune (signo: INTEGER) is
         -- remove the signal from the set
      do
         safe_call (posix_sigdelset (set.ptr, signo))
      ensure
         is_not_member: not has (signo)
      end
   
   wipe_out is
         -- remove all items
      do
         make_empty
      end

   
feature -- commands to do something with set
   
   add_to_blocked_signals is
         -- Add the signals to the set of blocked signals
      do
         safe_call (posix_sigprocmask (SIG_BLOCK, set.ptr, default_pointer))
      end
   
   remove_from_blocked_signals is
         -- Remove the signals from the set of blocked signals
      do
         safe_call (posix_sigprocmask (SIG_UNBLOCK, set.ptr, default_pointer))
      end
   
   set_blocked_signals is
         -- Set the set of blocked signals to this set
      do
         safe_call (posix_sigprocmask (SIG_SETMASK, set.ptr, default_pointer))
      end
   
   suspend is
         -- Suspend process, until delivery of a signal whose action
         -- is either to execute a signal-catching function or to
         -- terminate the process
      local
         r: INTEGER
      do
         r := posix_sigsuspend (set.ptr)
      end
   

feature -- queries
   
   has (signo: INTEGER): BOOLEAN is
         -- is signal `signo' in the set
      local
         r: INTEGER
      do
         r := posix_sigismember (set.ptr, signo)
         safe_call (r)
         Result :=  r = 1
      end

   
feature {NONE} -- private state
   
   set: POSIX_BUFFER
   
   assure_have_set is
      do
         if set = Void then
            create set.allocate_and_clear (posix_sigset_size)
         end
      ensure
         have_set: set /= Void                   
      end
   

invariant
   
   have_set: set /= Void

end -- class POSIX_SIGNAL_SET

