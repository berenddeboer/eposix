indexing

	description:

		"MIME header with support for HTTP specific fields"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2007/01/25 $"
	revision: "$Revision: #1 $"


class

	EPX_MIME_HTTP_HEADER


inherit

	EPX_MIME_HEADER


creation

	make_default


feature -- Access to well-known fields

	cache_control: EPX_MIME_UNSTRUCTURED_FIELD


feature -- Access to well-known fields

	cache_control_field: EPX_MIME_FIELD is
			-- Field `Cache-Control' if it exists, else Void.
		do
			fields.search (field_name_cache_control)
			if fields.found then
				Result := fields.found_item
			end
		ensure
			definition: fields.has (field_name_cache_control) = (Result /= Void)
		end

	set_cache_control (a_cache_directives: ARRAY [STRING]) is
			-- The Cache-Control general-header field is used to specify
			-- directives that MUST be obeyed by all caching mechanisms
			-- along the request/response chain. The directives specify
			-- behavior intended to prevent caches from adversely
			-- interfering with the request or response. These directives
			-- typically override the default caching algorithms. Cache
			-- directives are unidirectional in that the presence of a
			-- directive in a request does not imply that the same
			-- directive is to be given in the response.
			-- See RFC 2616, section 14.9 for more details
		require
			at_least_one_directive: a_cache_directives /= Void and then a_cache_directives.count > 0
		local
			field: EPX_MIME_UNSTRUCTURED_FIELD
			serialization: STRING
			i: INTEGER
		do
			create serialization.make (a_cache_directives.item (a_cache_directives.lower).count * a_cache_directives.count)
			from
				i := a_cache_directives.lower
			until
				i > a_cache_directives.upper
			loop
				serialization.append_string (a_cache_directives.item (i))
				if i < a_cache_directives.upper then
					serialization.append_character (',')
					serialization.append_character (' ')
				end
				i := i + 1
			end
			if field = Void then
				create field.make (field_name_cache_control, serialization)
				add_field (field)
			else
				field.set_value (serialization)
			end
		ensure
			cache_control_field_set: cache_control_field /= Void
		end


end
