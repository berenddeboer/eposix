class EX_ASYNC1

create
   
   make
   
feature

   make is
      local
         fd: POSIX_FILE_DESCRIPTOR
         request: POSIX_ASYNC_IO_REQUEST
      do
         create fd.create_read_write ("test.tmp")
         create request.make (fd)
         request.set_offset (0)
         request.put_string ("hello world.")
         request.wait_for
         fd.close
      end
   
end
