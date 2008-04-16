indexing

	description: "Fix SmartEiffel name clashes with my names as %
	%SmartEiffel has way to much stuff in its GENERAL class."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #3 $"

class

	ANY

inherit

	PLATFORM
		undefine
			remove_file
		end

end -- ANY
