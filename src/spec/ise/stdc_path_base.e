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


feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is the path name equal to `other'?
		local
			s1,
			s2: STRING
		do
			if other = Current then
				Result := True
			elseif other.count = count then
				create s1.make_from_string (Current)
				create s2.make_from_string (other)
				Result := s1.is_equal (s2)
			end
		end

end
