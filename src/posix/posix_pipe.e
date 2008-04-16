indexing

   description: "Class that covers Posix pipe."

   author: "Berend de Boer"
   date: "$Date: 2002/02/06 $"
   revision: "$Revision: #2 $"

class

   POSIX_PIPE


inherit

   EPX_PIPE
      redefine
         fdin,
         fdout
      end


creation

   make


feature -- the pipe

   fdin: POSIX_FILE_DESCRIPTOR

   fdout: POSIX_FILE_DESCRIPTOR


end
