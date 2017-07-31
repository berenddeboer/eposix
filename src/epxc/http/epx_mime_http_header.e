note

	description:

		"MIME header with support for HTTP specific fields"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"


class

	EPX_MIME_HTTP_HEADER


inherit

	EPX_MIME_HEADER


create

	make_default


feature -- Access to well-known fields

	vary_field: detachable EPX_MIME_FIELD
			-- Field `Cache-Control' if it exists, else Void.
		do
			fields.search (field_name_vary)
			if fields.found then
				Result := fields.found_item
			end
		ensure
			definition: fields.has (field_name_vary) = (Result /= Void)
		end


feature -- Set fields

	set_vary (a_field_names: ARRAY [STRING])
			-- The Vary field value indicates the set of request-header
			-- fields that fully determines, while the response is fresh,
			-- whether a cache is permitted to use the response to reply
			-- to a subsequent request without revalidation. For
			-- uncacheable or stale responses, the Vary field value
			-- advises the user agent about the criteria that were used
			-- to select the representation. A Vary field value of "*"
			-- implies that a cache cannot determine from the request
			-- headers of a subsequent request whether this response is
			-- the appropriate representation.
			-- See RFC 2616, section 14.44 for more details
			-- If no field names are passed, '*' is assumed.
		local
			field: EPX_MIME_UNSTRUCTURED_FIELD
			serialization: STRING
			i: INTEGER
		do
			if a_field_names = Void or else a_field_names.count = 0 then
				serialization := "*"
			else
				create serialization.make (a_field_names.item (a_field_names.lower).count * a_field_names.count)
				from
					i := a_field_names.lower
				until
					i > a_field_names.upper
				loop
					serialization.append_string (a_field_names.item (i))
					if i < a_field_names.upper then
						serialization.append_character (',')
						serialization.append_character (' ')
					end
					i := i + 1
				end
				if field = Void then
					create field.make (field_name_vary, serialization)
					add_field (field)
				else
					field.set_value (serialization)
				end
			end
		ensure
			vary_field_set: vary_field /= Void
		end


end
