indexing

	description: "Class that covers a Windows directory. Main use is to be %
	%able to loop through a single directory."

	author: "Marcio Marchini"
	date: "$Date: 2006/05/30 $"
	revision: "$Revision: #6 $"

class

	WINDOWS_DIRECTORY

inherit

	WINDOWS_BASE

	EPX_DIRECTORY
		undefine
			raise_posix_error
		end


creation

	make

end
