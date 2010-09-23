indexing

	description: "Creates a temporary file that is removed when closed %
	%or when the program terminates."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $";
	revision: "$Revision: #3 $"

class

	POSIX_TEMPORARY_FILE


inherit

	POSIX_FILE
		rename
			make as old_make
		end

	STDC_TEMPORARY_FILE


create

	make


end -- class POSIX_TEMPORARY_FILE
