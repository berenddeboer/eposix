class EX_MODEM

inherit
   
   POSIX_CURRENT_PROCESS
   
create
   
   make

feature
   
   make is
      local
         modem: POSIX_FILE_DESCRIPTOR
         term: POSIX_TERMIOS
      do
         -- assume there is a /dev/modem device
         create modem.open_read_write ("/dev/modem")
         term := modem.terminal
         term.flush_input
         print ("Input speed: ")
         print (term.speed_to_baud_rate (term.input_speed))
         print ("%N")
         print ("Output speed: ")
         print (term.speed_to_baud_rate (term.output_speed))
         print ("%N")
         
         term.set_input_speed (B9600)
         term.set_output_speed (B9600)
         term.set_receive (True)
         term.set_echo_input (False)
         term.set_echo_new_line (False)
         term.set_input_control (True)
         term.apply_flush
            
         -- expect modem to echo commands
         modem.put_string ("AT%N")
         modem.read_string (64)
         print ("Command: ")
         print (modem.last_string)
         modem.read_string (64)
         print ("Response (expect ok): ")
         print (modem.last_string)
         modem.put_string ("ATI0%N")
         modem.read_string (64)
         print ("Command: ")
         print (modem.last_string)
         modem.read_string (64)
         print ("Response: ")
         print (modem.last_string)
         modem.close
      end
   
end
