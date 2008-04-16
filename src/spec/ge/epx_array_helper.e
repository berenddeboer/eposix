indexing

	description: "Converts arrays to pointers."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_ARRAY_HELPER


inherit

	ABSTRACT_ARRAY_HELPER


feature -- GEC specific conversions

	integer_array_to_pointer (a: ARRAY [INTEGER]): POINTER is
		local
			c_any: ANY
		do
			c_any := a.to_c
			if c_any /= Void then
				Result := $c_any
			end
		end

	pointer_array_to_pointer (a: ARRAY [POINTER]): POINTER is
			-- Convert to void **.
		local
			c_any: ANY
		do
			c_any := a.to_c
			if c_any /= Void then
				Result := $c_any
			end
		end


end
