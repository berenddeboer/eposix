indexing

	description:

		"Describes the RFC2616 WWW-Authenticate field"

	library: "eposix Library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_MIME_FIELD_WWW_AUTHENTICATE


inherit

	EPX_MIME_FIELD_WITH_PARAMETERS
		rename
			value as scheme
		redefine
			append_to_string
		end


create

	make


feature -- Initialization

	make (a_scheme: STRING) is
			-- Initialize WWW-Authenticate field
		require
			scheme_not_empty: a_scheme /= Void and then not a_scheme.is_empty
		do
			make_parameters
			scheme := a_scheme
		end


feature -- Access

	scheme: STRING
			-- Authentication scheme

	name: STRING is "WWW-Authenticate"
			-- Authorative name

	realm: STRING is
			-- Realm if defined; According to the spec all authentication
			-- schems should have one.
		do
			parameters.search (parameter_name_realm)
			if parameters.found then
				Result := parameters.found_item.value
			end
		ensure
			void_or_not_empty: Result = Void or else not Result.is_empty
		end


feature -- Output

	append_to_string (s: STRING) is
			-- Stream contents of MIME structure to a STRING.
		do
			s.append_string (name)
			s.append_string (once_space_colon)
			s.append_string (scheme)
			from
				parameters.start
			until
				parameters.after
			loop
				s.append_character (' ')
				s.append_string (parameters.item_for_iteration.name)
				s.append_character ('=')
				s.append_character ('"')
				s.append_string (parameters.item_for_iteration.value)
				s.append_character ('"')
				parameters.forth
			end
			s.append_string (once_crlf)
		end


invariant

	scheme_not_empty: scheme /= Void and then not scheme.is_empty

end
