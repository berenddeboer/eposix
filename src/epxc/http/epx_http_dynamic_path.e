indexing

	description: "urlReplacement path."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	EPX_HTTP_DYNAMIC_PATH


inherit

	ANY

	EPX_URL_ENCODING
		export
			{NONE} all
		end


create

	make,
	make_from_url


feature {NONE} -- Initialization

	make (a_path: RX_PCRE_REGULAR_EXPRESSION; a_resource: EPX_HTTP_SERVLET) is
			-- Initialize.
		require
			path_not_void: a_path /= Void
			path_compiled: a_path.is_compiled
			resource_not_void: a_resource /= Void
		do
			path := a_path
			resource := a_resource
		ensure
			path_set: path = a_path
			resource_set: resource = a_resource
		end

	make_from_url (a_path: STRING; a_resource: EPX_HTTP_SERVLET) is
			-- Initialize path by compiling the URL replacement path into
			-- a regular expression and calling `make'.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
			path_is_absolute: a_path.item (1) = '/'
			resource_not_void: a_resource /= Void
			field_names_unique: has_unique_field_names (a_path)
		local
			regexp: RX_PCRE_REGULAR_EXPRESSION
		do
			create regexp.make
			regexp.compile (replacement_url_to_regepx (a_path))
			regexp.optimize
			make (regexp, a_resource)
		end


feature -- Status

	has_unique_field_names (a_path: STRING): BOOLEAN is
			-- Does dynamic `a_path' not contain duplicate field-names?
		do
			-- @@BdB: still have to write this. I now raise an exception
			-- in `replacement_url_to_regepx'.
			Result := True
		end


feature -- Access

	path: RX_PCRE_REGULAR_EXPRESSION
			-- The regular expression for the paths this resource can handle.

	resource: EPX_HTTP_SERVLET
			-- The actual resource.


feature -- Path matching

	fields: DS_LINKED_LIST [EPX_KEY_VALUE]

	matches (a_path: STRING): BOOLEAN is
			-- Does `path' match `a_path'?
			-- If matched, `fields' is filled with the names and values
			-- extracted from the path.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
			path_is_absolute: a_path.item (1) = '/'
		local
			i: INTEGER
			value: EPX_KEY_VALUE
		do
			path.match (a_path)
			Result := path.has_matched and then parts.count = path.match_count - 1
			if Result then
				create fields.make
				from
					i := 1
					parts.start
				until
					i >= path.match_count
				loop
					create value.make (parts.item_for_iteration, unescape_string (path.captured_substring (i)))
					fields.put_last (value)
					i := i + 1
					parts.forth
				end
			else
				fields := Void
			end
		ensure
			fields_not_void: Result = (fields /= Void)
		end


feature {NONE} -- URL replacement path parsing

	parts: DS_SET [STRING]
			-- The field names of the dynamic parts in the path.

	replacement_url_to_regepx (a_path: STRING): STRING is
			-- Replace the (..) parts in `a_path' by the regular
			-- expression `once_replacement_regepx'.
			-- The string between (..) is considered to be a field name
			-- and added to `parts'.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
		local
			p, q, prev_q: INTEGER
			part_name: STRING
			exceptions: expanded EXCEPTIONS
		do
			-- Probably not a robust implementation...
			create {DS_HASH_SET [STRING]} parts.make (8)
			from
				prev_q := 1
				p := a_path.index_of ('(', 1)
				create Result.make (a_path.count)
				Result.append_character ('^')
			invariant
				p /= 0 implies p > q
			until
				p = 0
			loop
				prev_q := q
				q := a_path.index_of (')', p+1)
				if q /= 0 then
					if prev_q + 1 < p then
						Result.append_string (a_path.substring (prev_q + 1, p-1))
					end
					part_name := a_path.substring (p+1, q - 1)
					if parts.has (part_name) then
						exceptions.raise ("Part name " + part_name + " is not unique")
					end
					parts.put_last (part_name)
					Result.append_string (once_replacement_regexp)
					p := a_path.index_of ('(', q + 1)
				else
					p := 0
				end
			end
			if q < a_path.count then
				Result.append_string (a_path.substring (q + 1, a_path.count))
			end
			Result.append_character ('$')
		ensure
			replacement_url_to_regepx_not_empty: Result /= Void and then not Result.is_empty
		end


feature {NONE} -- Once STRINGs, Eiffel's worst feature

	once_replacement_regexp: STRING is "([^/]+)"


invariant

	path_not_void: path /= Void
	resource_not_void: resource /= Void

end
