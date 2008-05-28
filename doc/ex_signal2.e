class EX_SIGNAL2

inherit

   POSIX_CURRENT_PROCESS

   POSIX_CONSTANTS

   POSIX_SIGNAL_HANDLER

create

   make

feature

   make is
      local
         signal: POSIX_SIGNAL
      do
         create signal.make (SIGCHLD)
         signal.set_handler (Current)
         signal.apply

         -- spawn child processes here
         -- you don't have to wait for them
      end

   signalled (signal_value: INTEGER) is
      do
         wait
      end

end
