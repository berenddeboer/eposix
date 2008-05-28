class EX_ERROR1

inherit

   POSIX_CURRENT_PROCESS

create

   make

feature

   make is
      local
         fd: POSIX_FILE_DESCRIPTOR
      do
         fd := attempt_create_file
      end

   attempt_create_file: POSIX_FILE_DESCRIPTOR is
      local
         attempt: INTEGER
         still_exists: BOOLEAN
      do
         create Result.create_with_mode ("myfile", O_CREAT+O_TRUNC+O_EXCL, 0)
      rescue
         still_exists := errno.value = EEXIST
         attempt := attempt + 1
         if still_exists and then attempt <= 3 then
            sleep (1)
            retry
         end
      end

end
