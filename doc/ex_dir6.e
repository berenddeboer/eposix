class EX_DIR6

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
            dir.set_extension_filter (".e")
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
