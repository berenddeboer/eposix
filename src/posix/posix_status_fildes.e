indexing

   description: "Class that gets Posix stat structure through fstat call."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class

   POSIX_STATUS_FILDES


inherit

   POSIX_STATUS

   ABSTRACT_STATUS_FILDES
      redefine
         refresh
      end


create {EPX_FILE_DESCRIPTOR}

   make


feature -- stat members

   permissions: POSIX_PERMISSIONS is
         -- file permissions
      do
         if my_permissions = Void then
            create {POSIX_PERMISSIONS_FILDES} my_permissions.make (Current)
         end
         Result := my_permissions
      end


feature -- state change commands

   refresh is
         -- Refresh the cached status information
      do
         precursor
         if my_permissions /= Void then
            my_permissions.update_from_status
         end
      end


feature {NONE} -- state

   my_permissions: POSIX_PERMISSIONS


feature {NONE} -- abstract API

   abstract_fstat (fildes: INTEGER; a_stat: POINTER): INTEGER is
         -- Gets information about a file
      do
         Result := posix_fstat (fildes, a_stat)
      end


end -- class POSIX_STATUS_FILDES
