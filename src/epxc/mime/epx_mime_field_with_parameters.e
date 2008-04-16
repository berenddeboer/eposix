indexing

	description: "Base for structured fields with parameters."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	EPX_MIME_FIELD_WITH_PARAMETERS


inherit

	EPX_MIME_STRUCTURED_FIELD
		redefine
			append_to_string
		end

	EPX_MIME_PARAMETER_NAMES
		export
			{NONE} all;
			{ANY} is_valid_parameter_name
		end


feature {NONE} -- Initialization

	make_parameters is
			-- Initialize MIME field that has optional parameters.
		local
			equality_tester: UC_STRING_EQUALITY_TESTER
		do
			create parameters.make (16)
			create equality_tester
			parameters.set_key_equality_tester (equality_tester)
		end


feature -- Output

	append_to_string (s: STRING) is
			-- Stream contents of MIME structure to a STRING.
		do
			s.append_string (name)
			s.append_string (once_space_colon)
			s.append_string (value)
			from
				parameters.start
			until
				parameters.after
			loop
				parameters.item_for_iteration.append_to_string (s)
				parameters.forth
			end
			s.append_string (once_crlf)
		end


feature -- State

	parameters: DS_HASH_TABLE [EPX_MIME_PARAMETER, STRING]
			-- Optional list of parameters for this field


feature -- Parameter change

	add_parameter (a_parameter: EPX_MIME_PARAMETER) is
			-- Append `a_parameter' to `parameters'.
		require
			a_parameter_not_void: a_parameter /= Void
			parameter_not_exists: not parameters.has (a_parameter.name)
		do
			parameters.put (a_parameter, a_parameter.name)
		ensure
			parameter_added: parameters.has (a_parameter.name)
			parameter_is_last: parameters.last =  a_parameter
		end

	set_parameter (a_name, a_value: STRING) is
			-- Add parameter with name `a_name' if it does not exist, or
			-- else set the value of the existing parameter to `a_value'.
		require
			valid_name: is_valid_parameter_name (a_name.as_lower)
			valid_value: a_value /= Void
		local
			parameter: EPX_MIME_PARAMETER
		do
			parameters.search (a_name)
			if parameters.found then
				parameter := parameters.found_item
				parameter.set_value (a_value)
			else
				create parameter.make (a_name, a_value)
				add_parameter (parameter)
			end
		ensure
			parameter_exists: parameters.has (a_name)
		end


feature {NONE} -- Implementation

	is_every_parameter_in_parameters: BOOLEAN is
			-- Does every parameter in `parameters' have a name that can
			-- be found in `parameters'?
		local
			cursor: DS_LINEAR_CURSOR [EPX_MIME_PARAMETER]
		do
			from
				Result := True
				cursor := parameters.new_cursor
				cursor.start
			until
				not Result or else cursor.after
			loop
				Result :=
					parameters.has (cursor.item.name)
				cursor.forth
			end
		end


invariant

	parameters_not_void: parameters /= Void
	parameters_valid: is_every_parameter_in_parameters

end
