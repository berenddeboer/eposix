indexing

   description: "Class that covers Windows file descriptor code."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class

   WINDOWS_FILE_DESCRIPTOR


inherit

   WINDOWS_BASE

   EPX_FILE_DESCRIPTOR


create

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
