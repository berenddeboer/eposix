indexing

	description: "Base class for STDC_PATH. As inheriting from STRING is non-portable, this base class is compiler specific"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	STDC_PATH_BASE


inherit

	STRING
		rename
			make_from_string as org_make_from_string
		redefine
			is_equal
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		undefine
			copy,
			is_equal,
			out
		end


feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is the path name equal to `other'?
		do
			if other = Current then
				Result := True
			else
				Result := STRING_.same_string (Current, other)
			end
		end

end
