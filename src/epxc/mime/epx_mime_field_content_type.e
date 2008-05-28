indexing

	description: "Field Content-Type"

	known_bugs:
	"1. Invariant that we have a boundary is not maintained, because we don't know the parameter when building this field. Client can send rubbish.%
	%2. No check if boundary has only chars defined in RFC 1521."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_MIME_FIELD_CONTENT_TYPE


inherit

	EPX_MIME_FIELD_WITH_PARAMETERS

	EPX_MIME_TYPE_NAMES
		export
			{NONE} all
		end


create

	make,
	make_multipart


feature -- Initialization

	make (a_type, a_subtype: STRING) is
			-- Initialize Content-Type MIME field and clear all parameters.
		require
			type_not_empty: a_type /= Void and then not a_type.is_empty
			subtype_not_empty: a_subtype /= Void and then not a_subtype.is_empty
		do
			type := a_type
			subtype := a_subtype
			make_parameters
		end

	make_multipart (a_subtype, a_boundary: STRING) is
			-- Initialize Content-Type.
		require
			subtype_not_empty: a_subtype /= Void and then not a_subtype.is_empty
			boundary_not_empty: a_boundary /= Void and then not a_boundary.is_empty
		local
			p: EPX_MIME_PARAMETER
		do
			make (mime_type_multipart, a_subtype)
			create p.make (parameter_name_boundary, a_boundary)
			add_parameter (p)
		ensure
			has_parameter_boundary: parameters.has (parameter_name_boundary)
			have_boundary: boundary /= Void and then not boundary.is_empty
		end


feature -- State

	boundary: STRING is
			-- Boundary, if Content-Type knows a boundary, else Void.
		do
			parameters.search (parameter_name_boundary)
			if parameters.found then
				Result := parameters.found_item.value
			end
		end

	is_multipart: BOOLEAN is
			-- Is this a multipart Content-Type?
		do
			Result := type.is_equal (mime_type_multipart)
		end

	name: STRING is "Content-Type"

	subtype: STRING
			-- More detail about `type'.

	type: STRING
			-- Major MIME type like `multipart' or `message'.

	value: STRING is
			-- Value of field.
		do
			create Result.make (type.count + 1 + subtype.count)
			Result.append_string (type)
			Result.append_character ('/')
			Result.append_string (subtype)
		end


invariant

	subtype_not_empty: subtype /= Void and then not subtype.is_empty
	type_not_empty: type /= Void and then not type.is_empty
	-- boundary_if_multipart: is_multipart implies boundary /= Void and then not boundary.is_empty

end
