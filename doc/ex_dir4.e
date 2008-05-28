class EX_DIR4

inherit
   
   POSIX_FILE_SYSTEM
  
create
   
   make
   
feature

   make is
      local
         stat: POSIX_STATUS
      do
         stat := status ("/etc/passwd")
         print ("size: ")         
         print (stat.size.out)
         print (".%N")
         print ("uid: ")         
         print (stat.permissions.uid)
         print (".%N")         
      end
   
end
