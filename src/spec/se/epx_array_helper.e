indexing

	description: "Converts arrays to pointers."
	thanks: "The mico/E team for the idea. Also code taken from %
	%kl_external_routines."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_ARRAY_HELPER

inherit

	ABSTRACT_ARRAY_HELPER


feature -- SmallEiffel specific conversions

	integer_array_to_pointer (a: ARRAY [INTEGER]): POINTER is
		do
			Result := a.to_external
		end

	pointer_array_to_pointer (a: ARRAY [POINTER]): POINTER is
			-- convert to void **
		do
			Result := a.to_external
		end


end
