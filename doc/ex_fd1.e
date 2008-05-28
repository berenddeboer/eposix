class EX_FD1

create
   
   make
   
feature

   make is
      local
         fd: POSIX_FILE_DESCRIPTOR
      do
         create fd.open_read ("/etc/group")
         fd.read_string (64)
         print (fd.last_string)
         fd.close
      end
   
end
