class EX_FD3

inherit
   
   POSIX_CURRENT_PROCESS

create
   
   make
   
feature

   make is
      do
         print ("Password: ")
         stdout.flush
         
         -- turn off echo
         fd_stdin.terminal.set_echo_input (False)
         fd_stdin.terminal.apply_flush

         -- read password
         fd_stdin.read_string (256)
         
         -- turn echo back on
         fd_stdin.terminal.set_echo_input (True)
         fd_stdin.terminal.apply_now

         print ("%NYour password was: ")
         print (fd_stdin.last_string)
      end
   
end
