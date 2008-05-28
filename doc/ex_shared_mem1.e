class EX_SHARED_MEM1

inherit

   POSIX_SYSTEM

   POSIX_CURRENT_PROCESS

   POSIX_FILE_SYSTEM

create

   make

feature

   make is
      local
         fd: POSIX_SHARED_MEMORY
      do
         if not supports_shared_memory_objects then
            stderr.puts ("Shared memory objects not supported.%N")
            exit_with_failure
         end

         create fd.create_read_write ("/test.berend")
         fd.put_string ("Hello world.%N")
         fd.close
         unlink_shared_memory_object ("/test.berend")
      end

end

