class EX_ERROR2
   
inherit
   
   STDC_SECURITY_ACCESSOR

create

   make

feature
   
   make is
      local
         fd: POSIX_FILE_DESCRIPTOR
      do
         security.error_handling.disable_exceptions
         create fd.create_write ("myfile")
         if fd.errno.first_value = 0 then
            fd.put_string ("1%N")
            fd.put_string ("2%N")
            fd.close
         else
            fd.errno.clear_first
         end
      end
   
end
