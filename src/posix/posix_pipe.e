indexing

   description: "Class that covers Posix pipe."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class

   POSIX_PIPE


inherit

   EPX_PIPE
      redefine
         fdin,
         fdout
      end


create

   make


feature -- the pipe

   fdin: POSIX_FILE_DESCRIPTOR

   fdout: POSIX_FILE_DESCRIPTOR


end
