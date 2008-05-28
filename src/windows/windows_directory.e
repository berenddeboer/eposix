indexing

	description: "Class that covers a Windows directory. Main use is to be %
	%able to loop through a single directory."

	author: "Marcio Marchini"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

class

	WINDOWS_DIRECTORY

inherit

	WINDOWS_BASE

	EPX_DIRECTORY
		undefine
			raise_posix_error
		end


create

	make

end
