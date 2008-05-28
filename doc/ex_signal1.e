class EX_SIGNAL1
   
inherit

   POSIX_CURRENT_PROCESS
   
   POSIX_CONSTANTS

   POSIX_SIGNAL_HANDLER


create
   
   make
   

feature
   
   handled: BOOLEAN
   
   make is
      local
         signal: POSIX_SIGNAL
      do
         create signal.make (SIGINT)
         signal.set_handler (Current)
         signal.apply
         
         print ("Wait 30s or press Ctrl+C.%N")
         sleep (30)
         if handled then
            print ("Ctrl+C pressed.%N")
         else
            print ("Ctrl+C not pressed.%N")
         end
      end
   
   signalled (signal_value: INTEGER) is
      do
         handled := True
      end

end
