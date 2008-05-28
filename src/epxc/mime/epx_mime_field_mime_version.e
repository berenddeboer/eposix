indexing

	description: "Field MIME-Version"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_MIME_FIELD_MIME_VERSION


inherit

	EPX_MIME_STRUCTURED_FIELD


create

	make



feature -- Initialization

	make (a_major_number, a_minor_number: INTEGER) is
		require
			major_number_positive: a_major_number >= 0
			minor_number_positive: a_minor_number >= 0
		do
			major_number := a_major_number
			minor_number := a_minor_number
		end


feature -- Access

	major_number,
	minor_number: INTEGER
			-- MIME version.

	name: STRING is "MIME-Version"

	value: STRING is
			-- Value of field.
		do
			Result := major_number.out + "." + minor_number.out
		end

invariant

	major_number_positive: major_number >= 0
	minor_number_positive: minor_number >= 0

end
