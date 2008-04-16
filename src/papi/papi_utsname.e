indexing

   description: "Class that covers Posix sys/utsname.h."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   PAPI_UTSNAME

   
feature {NONE} -- POSIX C interface
   
   posix_uname (name: POINTER): INTEGER is
         -- Gets system name
      require
         valid_name: name /= default_pointer
      external "C"
      end

   posix_uname_machine (name: POINTER): POINTER is
         -- Gets system name
      external "C"
      end

   posix_uname_nodename (name: POINTER): POINTER is
         -- Gets system name
      external "C"
      end

   posix_uname_release (name: POINTER): POINTER is
         -- Gets system name
      external "C"
      end

   posix_uname_sysname (name: POINTER): POINTER is
         -- Gets system name
      external "C"
      end

   posix_uname_version (name: POINTER): POINTER is
         -- Gets system name
      external "C"
      end
   
   posix_utsname_size: INTEGER is
         -- size of struct utsname
      external "C"
      end


end -- class PAPI_UTSNAME
