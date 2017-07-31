note

	description:

		"External URI resolver for the http protocol"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com> and Colin Paul Adams"
	copyright: "Copyright (c) 2004-2007, Berend de Boer"
	license: "MIT License"


class

	EPX_HTTP_URI_RESOLVER

inherit

	XM_URI_RESOLVER

	KL_SHARED_STANDARD_FILES

create

	make

feature {NONE} -- Initialization

	make (a_stack: DS_STACK [UT_URI])
			-- establish invariant.
		require
			uri_stack_exists: a_stack /= Void
		do
			uri_stack := a_stack
		ensure
			uri_stack_saved: uri_stack = a_stack
		end

feature -- Operation(s)

	default_port: INTEGER
		once
			Result := 80
		end

	scheme: STRING
		once
			Result := "http"
		end

	resolve (a_uri: UT_URI)
			-- Resolve URI to stream.
		local
			a_path: STRING
			a_response_code: INTEGER
			a_uri_to_use: UT_URI
		do
			has_media_type := False
			a_response_code := Sc_found
			from a_uri_to_use := a_uri until not is_redirect (a_response_code) loop
				last_uri := a_uri_to_use
				if a_uri_to_use.is_server_authority then
					a_uri_to_use.parse_authority (default_port)
				end
				if not a_uri_to_use.has_parsed_authority then
					set_local_error ("Host name needed with http(s) protocol")
				end
				if not has_local_error then
					client := new_client (a_uri_to_use)
					if attached a_uri.user_info as user_info then
						set_basic_authentication_from_user_info (user_info)
					elseif attached user_name as u and then not u.is_empty and then
						attached password as p then
						client.set_basic_authentication (u, p)
					end
					debug ("XML http resolver")
						std.error.put_string ("Host is ")
						std.error.put_string (a_uri_to_use.host)
						std.error.put_new_line
					end
					if not has_local_error then
						create a_path.make_from_string (a_uri_to_use.path)
						if a_path.is_empty then
							a_path := "/"
						end
						if a_uri_to_use.has_query then
							a_path.append_character ('?')
							a_path.append_string (a_uri_to_use.query)
						end
						if a_uri_to_use.has_fragment then
							a_path.append_character ('#')
							a_path.append_string (a_uri_to_use.fragment)
						end
						client.get (a_path)
						a_response_code := client.response_code
						if a_response_code = Sc_ok then
							client.read_response
							if client.is_response_ok then
								handle_success (a_uri_to_use)
							else
								a_response_code := client.response_code
							end
						end
						if is_redirect (a_response_code) then
							if client.fields.has (Location) then
								create a_uri_to_use.make_resolve (a_uri_to_use, client.fields.item (Location).value)
								if uri_stack.is_empty then
									uri_stack.put (a_uri_to_use)
								else
									uri_stack.replace (a_uri_to_use)
								end
							else
								a_response_code := 500
								set_local_error ("Could not find Location field after Found response.")
							end
						end
					end
				end
			end
			debug ("XML http resolver")
				if has_error then
					std.error.put_string ("Error from HTTP resolver was: ")
					std.error.put_string (last_error)
					std.error.put_new_line
					std.error.put_string ("Status code was: ")
					std.error.put_string (a_response_code.out)
					std.error.put_new_line
					if last_stream /= Void and then last_stream.name /= Void then
						std.error.put_string ("Last_stream.name is: ")
						std.error.put_string (last_stream.name)
						std.error.put_new_line
					end
				end
			end
		end

feature -- Result

	has_error: BOOLEAN
			-- Did the last resolution attempt succeed?
		do
			-- I think the has_error and has_no_error invariants are wrong
			-- We need to set `has_error' if we haven't resolved
			-- anything, else it thinks `stream' is set.
			Result := not attached last_uri or else has_local_error or else (attached client as c and then not c.is_response_ok)
		end

	last_error: STRING
		local
			a_message: STRING
		do
			if attached last_uri as lu then
				a_message := "URI "
				a_message.append_string (lu.full_reference)
				a_message.append_character ( ' ')
				if has_local_error then
					if attached last_local_error as e then
						a_message.append_string (e)
					end
				else
					a_message.append_string (client.response_phrase)
				end
				Result := a_message
			else
				Result := "`resolve' not called"
			end
		end

	last_stream: detachable KI_CHARACTER_INPUT_STREAM
			-- Matching stream

	has_media_type: BOOLEAN
			-- Is the media type available.

	last_media_type: detachable UT_MEDIA_TYPE
			-- Media type, if available.

feature -- Authentication setup

	user_name: detachable STRING
			-- User name for HTTP Basic authentication

	password: detachable STRING
			-- Password for HTTP Basic authentication

	set_basic_authentication (a_user_name, a_password: STRING)
			-- Make sure the Authorization header is included in the
			-- request.
		require
			user_name_not_empty: a_user_name /= Void and then not a_user_name.is_empty
			password_not_empty: a_password /= Void and then not a_password.is_empty
		do
			user_name := a_user_name
			password := a_password
		ensure
			user_name_set: user_name = a_user_name
			password_set: password = a_password
		end

feature {NONE} -- Implementation

	client: detachable EPX_HTTP_11_CLIENT

	has_local_error: BOOLEAN

	last_local_error: detachable like last_error

	last_uri: detachable UT_URI

	uri_stack: DS_STACK [UT_URI]
			-- Resolver's URI stack

	Content_type: STRING = "Content-Type"
			-- Name of content type header

	Location: STRING = "Location"
			-- Name of Location response field

	Sc_ok: INTEGER = 200
			-- Request succeeded normally

	Sc_moved_permanently: INTEGER = 301
			-- Requested resource assigned new permanent URI.

	Sc_found: INTEGER = 302
			-- Resource has been moved temporarily

	Sc_see_other: INTEGER = 303
			-- Response to request can be found under a different URI, and
			--  SHOULD be retrieved using a GET method on that resource.

	Sc_temporary_redirect: INTEGER = 307
			-- Requested resource resides temporarily under a different URI.

	is_redirect (a_response_code: INTEGER): BOOLEAN
			-- Does `a_response_code' indicate a re-direct status?
		do
			Result := a_response_code = Sc_moved_permanently
				or else a_response_code = Sc_found
				or else a_response_code = Sc_see_other
				or else a_response_code = Sc_temporary_redirect
		end

	new_client (a_uri_to_use: UT_URI): EPX_HTTP_11_CLIENT
		require
			a_uri_to_use_not_void: a_uri_to_use /= Void
			scheme_supported: a_uri_to_use.scheme ~ "http" or else a_uri_to_use.scheme ~ "https"
		do
			if a_uri_to_use.port = 0 then
				if a_uri_to_use.scheme ~ "https" then
					create Result.make_secure (a_uri_to_use.host)
				else
					create Result.make (a_uri_to_use.host)
				end
			else
				if a_uri_to_use.scheme ~ "https" then
					create Result.make_secure_with_port (a_uri_to_use.host, a_uri_to_use.port)
				else
					create Result.make_with_port (a_uri_to_use.host, a_uri_to_use.port)
				end
			end
		ensure
			not_void: Result /= Void
		end

	set_local_error (an_error_string: STRING)
			-- Set a local error.
		require
			error_string_not_void: an_error_string /= Void
		do
			has_local_error := True
			last_local_error := an_error_string
		ensure
			error_set: has_local_error and then attached last_local_error as e and then STRING_.same_string (an_error_string, e)
		end

	handle_success (a_uri: UT_URI)
			-- Handle `Sc_ok'.
		require
			sucessful_response: client.response_code = Sc_ok and then client.is_response_ok
		local
			a_content_type: EPX_MIME_FIELD
			a_content: STRING
		do
			-- response, if available now in `client'.`body'.
			last_stream := client.body.stream
			if last_stream /= Void then
				last_stream.name.wipe_out
				last_stream.name.append_string (a_uri.full_reference)
			end
			if client.fields.has (Content_type) then
				a_content_type := client.fields.item (Content_type)
				a_content := a_content_type.value
				set_media_type (a_content)
			end
		end

	set_media_type (a_content_type: STRING)
			-- Set `last_media_type'
		require
			content_type_not_void: a_content_type /= Void
		local
			a_splitter: ST_SPLITTER
			some_parameters, a_parameter_pair, some_components: DS_LIST [STRING]
			a_media_type: STRING
			a_cursor: DS_LIST_CURSOR [STRING]
		do
			create a_splitter.make
			a_splitter.set_separators (";")
			some_parameters := a_splitter.split (a_content_type)
			a_media_type := some_parameters.item (1)
			a_splitter.set_separators ("/")
			some_components := a_splitter.split (a_media_type)
			if some_components.count /= 2 then
				set_local_error ("Content-type must contain exactly one '/'")
			else
				has_media_type := True
				create last_media_type.make (some_components.item (1), some_components.item (2))
				if some_parameters.count > 1 then
					some_parameters.remove_first
					from
						a_splitter.set_separators ("=")
						a_cursor := some_parameters.new_cursor; a_cursor.start
					until
						a_cursor.after
					loop
						a_parameter_pair := a_splitter.split (a_cursor.item)
						if a_parameter_pair.count /= 2 then
							set_local_error (a_cursor.item + " is not valid syntax for a Content-type parameter.")
							a_cursor.go_after
						else
							last_media_type.add_parameter (a_parameter_pair.item (1), a_parameter_pair.item (2))
							a_cursor.forth
						end
					variant
						some_parameters.count + 1 - a_cursor.index
					end
				end
			end
		ensure
			error_or_media_type_set: not has_error implies has_media_type = True and then last_media_type /= Void
		end

	set_basic_authentication_from_user_info (a_user_info: STRING)
			-- Set basic authentication on `client' from `a_user_info'.
		require
			a_user_info_not_void: a_user_info /= Void
			client_not_void: client /= Void
		local
			l_splitter: ST_SPLITTER
			l_parts: DS_LIST [STRING]
		do
			create l_splitter.make_with_separators (":")
			l_parts := l_splitter.split (a_user_info)
			if l_parts.count = 2 then
				client.set_basic_authentication (l_parts.item (1), l_parts.item (2))
			else
				-- Is this correct?
				set_local_error ("Authentication must contain exactly one ':'")
			end
		end

invariant

	uri_stack_exists: attached uri_stack

end
