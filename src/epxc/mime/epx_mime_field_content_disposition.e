note

	description: "Field Content-Disposition"

	author: "Berend de Boer"


class

	EPX_MIME_FIELD_CONTENT_DISPOSITION


inherit

	EPX_MIME_FIELD_WITH_PARAMETERS

	EPX_MIME_PARAMETER_NAMES
		export
			{NONE} all
		end


create

	make,
	make_name


feature -- Initialization

	make (a_value: STRING)
			-- Initialize Content-Type.
		require
			value_not_empty: a_value /= Void and then not a_value.is_empty
		do
			make_parameters
			value := a_value
		end

	make_name (a_value: STRING; a_name: STRING)
			-- Initialize Content-Type, add the "name" parameter with
			-- value `a_name'.
		require
			value_not_empty: a_value /= Void and then not a_value.is_empty
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		local
			p: EPX_MIME_PARAMETER
		do
			make (a_value)
			create p.make (parameter_name_name, a_name)
			add_parameter (p)
		ensure
			has_parameter_name: parameters.has (parameter_name_name)
		end


feature -- Access

	name: STRING = "Content-Disposition"

	value: STRING
			-- Value of field.

	name_parameter: detachable EPX_MIME_PARAMETER
			-- Parameter with name "name" if exists, else Void.
		do
			parameters.search (parameter_name_name)
			if parameters.found then
				Result := parameters.found_item
			end
		ensure
			found_if_exists: parameters.has (parameter_name_name) = (attached Result)
		end


feature -- Change

	cleanup_filename_parameter
			-- If the Content-Disposition field has a filename parameter,
			-- strip any directory components.
		local
			filename: EPX_MIME_PARAMETER
			path: STDC_PATH
		do
			parameters.search (once_filename)
			if parameters.found then
				filename := parameters.found_item
				create path.make_from_string (filename.value)
				path.parse (Void)
				if attached path.basename as b then
					filename.set_value (b)
				end
			end
		end


feature {NONE} -- Once strings

	once_filename: STRING = "filename"


end
