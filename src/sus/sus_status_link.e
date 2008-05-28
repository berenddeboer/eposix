indexing

   description: "Class that gets Single Unix Spec stat structure through%
   %lstat call."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   SUS_STATUS_LINK
   

inherit
   
   SUS_STATUS_PATH
      redefine
         abstract_stat
      end
   

create {SUS_FILE_SYSTEM}
   
   make
   
   
feature {NONE} -- abstract API
   
   abstract_stat (a_path: POINTER; a_stat: POINTER): INTEGER is
         -- Gets information about a file
      do
         Result := posix_lstat (a_path, a_stat)
      end
   
   
end
