note

   description: "Class that covers POSIX termios.h header."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   PAPI_TERMIOS


feature {NONE} -- POSIX C binding
   
   posix_cfgetispeed (termios_p: POINTER): INTEGER
         -- returns terminal input baud rate
      external "C"
      end
   
   posix_cfgetospeed (termios_p: POINTER): INTEGER
         -- returns terminal output baud rate
      external "C"
      end

   posix_cfsetispeed (termios_p: POINTER; a_speed: INTEGER): INTEGER
         -- sets terminal input baud rate
      external "C"
      end
   
   posix_cfsetospeed (termios_p: POINTER; a_speed: INTEGER): INTEGER
         -- sets terminal output baud rate
      external "C"
      end

   posix_tcflush (a_fildes: INTEGER; a_option: INTEGER): INTEGER
         -- discards terminal data
      external "C"
      end
   
   posix_tcgetattr (a_fildes: INTEGER; termios_p: POINTER): INTEGER
      -- Gets terminal attributes
      external "C"
      end

   posix_tcsetattr (a_fildes: INTEGER; a_options: INTEGER; termios_p: POINTER): INTEGER
      -- Sets terminal attributes
      external "C"
      end

   posix_termios_size: INTEGER
         -- size of struct termios
      external "C"
      end
   
   posix_termios_iflag (termios_p: POINTER): INTEGER
      external "C"
      end
   
   posix_termios_oflag (termios_p: POINTER): INTEGER
      external "C"
      end
   
   posix_termios_cflag (termios_p: POINTER): INTEGER
      external "C"
      end
   
   posix_termios_lflag (termios_p: POINTER): INTEGER
      external "C"
      end

   posix_set_termios_iflag (termios_p: POINTER; lflag: INTEGER)
      external "C"
      end
   
   posix_set_termios_oflag (termios_p: POINTER; lflag: INTEGER)
      external "C"
      end
   
   posix_set_termios_cflag (termios_p: POINTER; lflag: INTEGER)
      external "C"
      end
   
   posix_set_termios_lflag (termios_p: POINTER; lflag: INTEGER)
      external "C"
      end


feature {NONE} -- tcflush constants

   TCIFLUSH: INTEGER
      external "C"
      alias "const_tciflush"
      end

   TCOFLUSH: INTEGER
      external "C"
      alias "const_tcoflush"
      end

   TCIOFLUSH: INTEGER
      external "C"
      alias "const_tcioflush"
      end


end -- class PAPI_TERMIOS
