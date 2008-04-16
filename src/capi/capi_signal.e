indexing

   description: "Class that covers Standard C signal.h."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   CAPI_SIGNAL


feature -- Standard C binding

   posix_raise (sig: INTEGER): INTEGER is
         -- Sends a signal
      require
         valid_signal: sig >= 0
      external "C"
      end
   
   posix_signal (sig: INTEGER; func: POINTER): POINTER is
         -- Specifies signal handling
      require
         valid_signal: sig >= 0
      external "C"
      end
   

end -- class CAPI_SIGNAL
