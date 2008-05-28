indexing

   description: "Class that covers Posix dynamic memory routines."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   POSIX_BUFFER

inherit
   
   STDC_BUFFER

   POSIX_BASE


create
   
   allocate,
   allocate_and_clear,
   make_from_pointer


end -- class POSIX_BUFFER
