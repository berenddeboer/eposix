indexing

   description: "Class that covers POSIX sys/types.h header."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   PAPI_TYPES


feature {NONE} -- POSIX C binding
   
   posix_gid_t_size: INTEGER is
         -- size of gid_t
      external "C"
      end


end -- class PAPI_TYPES

