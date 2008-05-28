indexing

	description: "Posix path, can be directory, file or link."

  author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class 

   POSIX_PATH

inherit
   
   STDC_PATH


create
   
   make,
   make_from_string,
   make_expand
   

end -- class POSIX_PATH
