indexing

	description: "Class that describes a single ULM field."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	ULM_FIELD

create

	make

feature -- Initialization

	make (a_name, a_value: STRING) is
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
			value_not_empty: a_value /= Void and then not a_value.is_empty
		do
			name := a_name
			value := a_value
		ensure
			name_set: name.is_equal (a_name)
			value_set: value.is_equal (a_value)
		end

feature -- State

	name: STRING
			-- One or more fieldtags, seperated by dots.

	value: STRING
			-- fieldvalue. According to the ULM spec it may be empty, but
			-- as that doesn't seem to serve many purposes, we won't
			-- allow that.

feature -- Commands

	set_value (a_value: STRING) is
		require
			value_not_empty: a_value /= Void and then not a_value.is_empty
		do
			value := a_value
		ensure
			value_set: value.is_equal (a_value)
		end

invariant

	name_not_empty: name /= Void and then not name.is_empty
	value_not_empty: value /= Void and then not value.is_empty

end
