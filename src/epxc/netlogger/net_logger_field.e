indexing

	description: "Class that describes a single field in a NetLogger log line."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	NET_LOGGER_FIELD


inherit

	ANY

	NET_LOGGER_ROUTINES


create

	make


feature {NONE} -- Initialization

	make (a_name, a_value: STRING) is
		require
			name_valid: is_valid_name (a_name)
			value_valid: is_valid_value (a_value)
		do
			name := a_name
			value := a_value
		ensure
			name_set: name.is_equal (a_name)
			void_or_not: ((a_value = Void) = (value = Void))
			value_set: void /= Void implies value.is_equal (a_value)
		end


feature -- Access

	name: STRING
			-- Event attribute name

	value: STRING
			-- Event attribute value


feature -- Change

	set_value (a_value: STRING) is
		require
			value_not_empty: a_value /= Void and then not a_value.is_empty
		do
			value := a_value
		ensure
			value_set: value.is_equal (a_value)
		end


invariant

	name_valid: is_valid_name (name)
	value_valid: is_valid_value (value)

end
