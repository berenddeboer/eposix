class EX_DIR1

inherit
   
   POSIX_FILE_SYSTEM

create
   
   make
   
feature

   make is
      do
         change_directory (expand_path ("~"))
         make_directory ("qqtest.xyz.tmp")
         remove_directory ("qqtest.xyz.tmp")
      end
   
end
