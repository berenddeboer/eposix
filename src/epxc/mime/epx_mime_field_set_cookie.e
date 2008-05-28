indexing

	description:

		"Describes the Set-Coookie field"

	references: "http://www.cookiecentral.com/faq/"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_MIME_FIELD_SET_COOKIE


inherit

	EPX_MIME_FIELD_WITH_PARAMETERS

	EPX_HTTP_COOKIE
		rename
			key as cookie_name,
			value as cookie_value,
			make as make_cookie
		end


create

	make


feature -- Initialization

	make (a_cookie_name, a_cookie_value: STRING) is
			-- Initialize Set-Cookie.
		require
			cookie_name_not_empty: a_cookie_name /= Void and then not a_cookie_name.is_empty
			cookie_value_not_void: a_cookie_value /= Void
		do
			make_parameters
			make_cookie (a_cookie_name, a_cookie_value)
		end


feature -- Access

	name: STRING is "Set-Cookie"

	value: STRING is
		do
			create Result.make (cookie_name.count + 1 + cookie_value.count)
			Result.append_string (cookie_name)
			Result.append_character ('=')
			Result.append_string (cookie_value)
			from
				parameters.start
			until
				parameters.after
			loop
				parameters.item_for_iteration.append_to_string (Result)
				parameters.forth
			end
		end


end
