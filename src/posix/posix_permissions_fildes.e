indexing

   description: "Class that covers the Posix file permission."
   usage: "You can set the permissions, call apply to make them permanent."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   POSIX_PERMISSIONS_FILDES

inherit

   POSIX_PERMISSIONS
      redefine
         status
      end


create

   make


feature {ABSTRACT_FILE_DESCRIPTOR} -- creation
   
   make (a_status: POSIX_STATUS_FILDES) is
      do
         status := a_status
         update_from_status
      end


feature {NONE}   

   
   apply_mode is
         -- make mode change permanent
      do
         -- no way to do this with a file descriptor??
      end

   apply_owner_and_group is
         -- make owner and group change permanent
      do
         -- no way to do this with a file descriptor??
      end


feature {NONE}

   status: POSIX_STATUS_FILDES
         -- used to be able to refresh itself
   

end -- class POSIX_PERMISSIONS_FILDES
