class EX_FD4

create
   
   make
   
feature

   make is
      local
         some_lock,
         lock: POSIX_LOCK
         fd: POSIX_FILE_DESCRIPTOR
      do
         create fd.create_read_write ("test.tmp")
         fd.put_string ("Test")

         create lock.make
         lock.set_allow_read
         lock.set_start (2)
         lock.set_length (1)
         some_lock := fd.get_lock (lock)
         if some_lock /= Void then
            print ("There is already a lock?%N")
         end
         
         -- create exclusive lock
         lock.set_allow_none
         lock.set_start (0)
         lock.set_length (4)
         fd.set_lock (lock)
         
         fd.close
      end
   
end
