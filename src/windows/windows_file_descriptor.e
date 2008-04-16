indexing

   description: "Class that covers Windows file descriptor code."

   author: "Berend de Boer"
   date: "$Date: 2002/02/06 $"
   revision: "$Revision: #2 $"

class

   WINDOWS_FILE_DESCRIPTOR


inherit

   WINDOWS_BASE

   EPX_FILE_DESCRIPTOR


creation

   open,
   open_read,
   open_write,
   open_read_write,
   open_truncate,
   create_read_write,
   create_write,
   create_with_mode,
   make_as_duplicate,
   attach_to_fd


end
