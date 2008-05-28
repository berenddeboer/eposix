class EX_DIR2

inherit
   
   POSIX_FILE_SYSTEM
  
create
   
   make
   
feature

   make is
      local
         perm: POSIX_PERMISSIONS
      do
         print_info (is_existing ("/tmp"), "existing")
         print_info (is_executable ("/bin/ls"), "executable")
         print_info (is_readable ("/etc/passwd"), "readable")
         print_info (is_writable ("/etc/passwd"), "writable")
         print_info (is_modifiable ("/etc/passwd"), "readable and writable")
         
         perm := permissions("/etc/passwd")
         
         if perm.allow_group_read then
            print ("Group is allowed to read /etc/passwd.%N")
         else
            print ("Group is not allowed to read /etc/passwd.%N")
         end
         
         if perm.allow_anyone_read_write then
            print ("Anyone is allowed to read file.tmp.%N")
         else
            print ("Anyone is not allowed to read file.tmp.%N")
         end
         
      end

   print_info (ok: BOOLEAN; what: STRING) is
      do
         print ("is_")
         print (what)
         print (" returned ")
         print (ok)
         print (".%N")
      end
   
end
