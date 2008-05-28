class EX_DIR3

inherit
   
   POSIX_FILE_SYSTEM
  
create
   
   make
   
feature

   make is
      local
         dir: POSIX_DIRECTORY
      do
         from
            dir := browse_directory (".")
            dir.start
         until
            dir.exhausted
         loop
            print (dir.item)
            print ("%N")
            dir.forth
         end
         dir.close
      end
   
end
