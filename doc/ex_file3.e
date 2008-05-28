class EX_FILE3
   
inherit
   
   POSIX_FILE_SYSTEM

create
   
   make
   
feature

   make is
      local
         file: POSIX_BINARY_FILE
      do
         create file.create_write (expand_path ("$HOME/myfile.tmp"))
         file.put_string ("hello world.%N")
         file.close
      end
   
end
