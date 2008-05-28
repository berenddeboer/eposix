class EX_DIR5

inherit
   
   STDC_FILE_SYSTEM
  
create
   
   make
   
feature

   make is
      do
         rename_to ("qqtest.abc.tmp", "qqtest.xyz.tmp")
         remove_file ("qqtest.xyz.tmp")
      end
   
end
