indexing

	description: "A single MIME parameter as it occurs in a MIME header field."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	EPX_MIME_PARAMETER


inherit

	ANY

	EPX_MIME_PARAMETER_NAMES
		export
			{NONE} all;
			{ANY} is_valid_parameter_name
		end


create

	make


feature {NONE} -- Initialization

	make (a_name, a_value: STRING) is
		require
			valid_name: is_valid_parameter_name (a_name.as_lower)
			valid_value: a_value /= Void
		do
			name := a_name
			name.to_lower
			value := a_value
		end


feature -- Output

	append_to_string (s: STRING) is
			-- Stream contents of MIME structure to a STRING.
		require
			s_not_void: s /= Void
		do
			s.append_string (once_semicolon_space)
			s.append_string (name)
			s.append_character ('=')
			s.append_character ('%"')
			s.append_string (value)
			s.append_character ('%"')
		end


feature -- Access

	name: STRING
			-- Name of MIME field;
			-- Name is lowercase only, makes looking for names much
			-- easier.

	value: STRING
			-- Parameter value


feature -- Change

	set_value (a_value: STRING) is
			-- Set `value'.
		do
			value := a_value
		end


feature {NONE} -- Once strings

	once_semicolon_space: STRING is "; "


invariant

	valid_name: is_valid_parameter_name (name)
	valid_value: value /= Void and then not value.has ('%"')

end
