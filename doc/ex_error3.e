class EX_ERROR3
   
inherit
   
   POSIX_CURRENT_PROCESS
   
   EXCEPTIONS

create

   make

feature
   
   make is
      local
         fd: POSIX_FILE_DESCRIPTOR
      do
         security.error_handling.disable_exceptions
         fd := attempt_create_file
      end
   
   attempt_create_file: POSIX_FILE_DESCRIPTOR is
      require
         manual_error: not security.error_handling.exceptions_enabled
      local
         attempt: INTEGER
         still_exists: BOOLEAN
      do
         from
            attempt := 1
            still_exists := True
         until
            not still_exists or else attempt > 3 
         loop            
            create Result.create_with_mode ("myfile", O_CREAT+O_TRUNC+O_EXCL, 0)
            still_exists := errno.first_value = EEXIST
            if still_exists then
               sleep (1)
               attempt := attempt + 1
            end
         end
         if still_exists then
            raise ("failed to create file")
         end
      end
         
end
