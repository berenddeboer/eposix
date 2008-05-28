class 

   EX_FORK1

inherit
   
   POSIX_CURRENT_PROCESS
   
   POSIX_FILE_SYSTEM
   
create
   
   make

feature

   make is
      local
         reader: POSIX_TEXT_FILE
         stop_sign: BOOLEAN
         child: FORK_CHILD
      do
         -- necessary for SmallEiffel before -0.75 beta 7
         ignore_child_stop_signal
         
         unlink ("berend.tmp")
         create_fifo ("berend.tmp", S_IRUSR + S_IWUSR)
         create child
         fork (child)
         
         -- we will now block until file is opened for writing
         create reader.open_read ("berend.tmp")
         from
            stop_sign := False
         until
            stop_sign
         loop
            reader.read_string (128)
            print (reader.last_string)
            stop_sign := equal(reader.last_string, "stop%N")
         end
         reader.close
         
         -- now wait for the writer to terminate
         child.wait_for (True)
         
         unlink ("berend.tmp")
      end

end
