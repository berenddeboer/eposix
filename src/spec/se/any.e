indexing

	description: "Fix SmartEiffel name clashes with my names as %
	%SmartEiffel has way to much stuff in its GENERAL class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	ANY

inherit

	PLATFORM
		undefine
			remove_file
		end

end -- ANY
