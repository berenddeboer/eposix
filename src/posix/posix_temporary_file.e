indexing

   description: "Creates a temporary file that is removed when closed %
   %or when the program terminates."

   author: "Berend de Boer"
   date: "$Date: 2003/01/09 $";
   revision: "$Revision: #2 $"

class
   
   POSIX_TEMPORARY_FILE

   
inherit 

   POSIX_FILE

   STDC_TEMPORARY_FILE


creation

   make


end -- class POSIX_TEMPORARY_FILE
