class FORK_CHILD

inherit

   POSIX_FORK_ROOT
   
feature
   
   execute is
      local
         writer: POSIX_TEXT_FILE
      do
         create writer.open_append ("berend.tmp")
         writer.put_string ("first%N")
         writer.put_string ("stop%N")
         writer.close
         
         -- we give the reader some time to process these messages
         sleep (10)
      end

end
