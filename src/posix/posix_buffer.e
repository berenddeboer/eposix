indexing

   description: "Class that covers Posix dynamic memory routines."

   author: "Berend de Boer"
   date: "$Date: 2003/01/09 $"
   revision: "$Revision: #2 $"

class 

   POSIX_BUFFER

inherit
   
   STDC_BUFFER

   POSIX_BASE


creation
   
   allocate,
   allocate_and_clear,
   make_from_pointer


end -- class POSIX_BUFFER
