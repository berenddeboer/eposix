indexing

   description: "Class that covers Windows stdlib.h."

   author: "Berend de Boer"
   date: "$Date: 2003/01/09 $"
   revision: "$Revision: #2 $"

class 

   WAPI_STDLIB

   
feature {NONE} -- C binding

   posix_fmode: INTEGER is
      external "C"
      end
   
   posix_set_fmode(a_value: INTEGER) is
      external "C"
      end
   

end -- class WAPI_STDLIB
