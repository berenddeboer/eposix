indexing

	description: "Character utilities such as converting integers to%
	%characters and vice versa."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

class

	ABSTRACT_CHARACTER_HELPER

obsolete

		"2006-03-22: use KL_INTEGER_ROUTINES.to_character instead"

inherit

	KL_IMPORTED_INTEGER_ROUTINES

feature -- Contracts for platform specific CHARACTER_HELPER

	frozen from_integer (code: INTEGER): CHARACTER is
		require
			valid_code: code >= 0 and code <= 255
		do
			Result := INTEGER_.to_character (code)
		end


end
