indexing

	description: "Field with no discernible structure in its content"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	EPX_MIME_UNSTRUCTURED_FIELD


inherit

	EPX_MIME_FIELD


create

	make


feature {NONE} -- Initialization

	make (a_name, a_value: STRING) is
			-- Initialize unstructured field.
		require
			valid_name: is_valid_mime_name (a_name)
			value_not_void: a_value /= Void
		do
			name := a_name
			value := a_value
		end


feature -- Access

	name: STRING
			-- Name of MIME field;
			-- Names are case-insensitive.

	value: STRING
			-- Contents of this field


feature -- Change

	set_value (a_value: STRING) is
		require
			valid_value: is_valid_field_body (a_value)
		do
			value := a_value
		ensure
			value_set: value.is_equal (a_value)
		end


end
