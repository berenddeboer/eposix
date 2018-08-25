note

	description:

		"External URI resolver for the ftp protocol"

	library: "eposix"
	author: "Colin Adams"
	copyright: "Copyright (c) 2004, Colin Adams"
	license: "MIT License"


class

	EPX_FTP_URI_RESOLVER


inherit

	XM_URI_RESOLVER


inherit {NONE}

	KL_SHARED_EXECUTION_ENVIRONMENT

	KL_CHARACTER_ROUTINES

	KL_SHARED_EXCEPTIONS

	KL_SHARED_STANDARD_FILES


feature {NONE} -- Initialisation


feature -- Operation(s)

	scheme: STRING = "ftp"

	resolve (a_uri: UT_URI)
			-- Resolve URI to stream.
		local
			a_user_name, a_password: STRING
			a_splitter: ST_SPLITTER
			some_parts: DS_LIST [STRING]
		do
			debug ("XML ftp resolver")
				std.error.put_string ("Resolving ftp URI: ")
				std.error.put_string (a_uri.full_uri)
				std.error.put_new_line
			end
			last_uri := a_uri
			is_retrieving := False
			if a_uri.is_server_authority then
				a_uri.parse_authority (21)
			end
			if not a_uri.has_parsed_authority then
				set_local_error ("Host name needed with ftp protocol")
			end
			if a_uri.has_user_info and then attached a_uri.user_info as l_user_info then
				create a_splitter.make
				a_splitter.set_separators (":")
				some_parts := a_splitter.split (l_user_info)
				if some_parts.count = 2 then
					a_user_name := some_parts.item (1)
					a_password := some_parts.item (2)
				else
					set_local_error ("Illegal user-information in ftp URI")
				end
				if not has_local_error then
					create client.make_with_port (a_uri.host, a_uri.port, a_user_name, a_password)
				end
			else
				a_password := Execution_environment.variable_value ("USER")
				if a_password = Void then a_password := "gestalt" end
				debug ("XML ftp resolver")
					std.error.put_string ("Attempting anonymous ftp with server name: ")
					std.error.put_string (a_uri.host)
					std.error.put_string (":")
					std.error.put_string (a_uri.port.out)
					std.error.put_string (" and password: ")
					std.error.put_string (a_password + "@%N")
				end
				create client.make_anonymous_with_port (a_uri.host, a_uri.port, a_password + "@")
			end
			if attached client as l_client then
				l_client.open
				if l_client.is_open then
					parse_path (l_client, a_uri)
				else
					set_local_error ("Failed to connect to ftp server")
				end
			end
		end

feature -- Result

	has_error: BOOLEAN
			-- Did the last resolution attempt succeed?
		do
			Result :=
				has_local_error or else
				is_retrieving and then attached client as l_client and then l_client.last_reply_code /= 150
		end

	is_retrieving: BOOLEAN
			-- Is the file being retrieved?

	last_error: STRING
		local
			a_message: STRING
		do
			if has_local_error and then attached last_local_error as l_last_local_error then
				Result := l_last_local_error
			elseif attached client as l_client then
				Result := "Ftp returned code " + l_client.last_reply_code.out
			else
				Result := "<no client>"
			end
			if attached last_uri as l_last_uri then
				a_message := STRING_.concat ("URI ", l_last_uri.full_reference)
			else
				a_message := "<no last_uri>"
			end
			a_message := STRING_.appended_string (a_message, " ")
			Result := STRING_.appended_string (a_message, Result)
		end

	last_stream: detachable KI_CHARACTER_INPUT_STREAM
			-- Matching stream

	has_media_type: BOOLEAN
			-- Is the media type available.
		do
			Result := False
		end

	last_media_type: UT_MEDIA_TYPE
			-- Media type, if available.
		do
			-- pre-condition is never met
			create Result.make ("not", "applicable")
		end

feature {NONE} -- Implementation

	client: detachable EPX_FTP_CLIENT
			-- Current client

	has_local_error: BOOLEAN

	last_local_error: detachable like last_error

	last_uri: detachable UT_URI

	set_local_error (an_error_string: STRING)
			-- Set a local error.
		require
			error_string_not_void: an_error_string /= Void
		do
			has_local_error := True
			last_local_error := an_error_string
		ensure
			error_set: has_local_error and then attached last_local_error as l_last_local_error and then STRING_.same_string (an_error_string, l_last_local_error)
		end

	parse_path (a_client: EPX_FTP_CLIENT; a_uri: UT_URI)
			-- Parse path component
		require
			uri_not_void: a_uri /= Void
			client_open: a_client.is_open
			no_errors_yet: not has_local_error
		local
			a_path, a_typecode: STRING
			a_splitter: ST_SPLITTER
			some_parts: DS_LIST [STRING]
		do
			if a_client.is_authenticated then
				debug ("XML ftp resolver")
					std.error.put_string ("Path is: ")
					std.error.put_string (a_uri.path)
					std.error.put_new_line
				end
				create a_splitter.make
				a_splitter.set_separators (";")
				some_parts := a_splitter.split (a_uri.path)
				if some_parts.count = 2 then
					a_path := some_parts.item (1)
					a_typecode := some_parts.item (2)
					debug ("XML ftp resolver")
						std.error.put_string ("Typecode is: ")
						std.error.put_string (a_typecode)
						std.error.put_new_line
					end
				elseif some_parts.count = 1 then
					a_path := some_parts.item (1)
					a_typecode := ""
				else
					set_local_error ("Bad syntax for path component of ftp URI")
					a_typecode := ""
					a_path := ""
				end
				if a_uri.has_query then
					set_local_error ("Query string is illegal in ftp URI")
				end
				--						if a_uri.fragment /= Void then
				--  We ignore any fragment-id
				--						end
			else
				set_local_error ("Server failed to authenticate client")
				a_typecode := ""
				a_path := ""
			end
			if not has_local_error and then a_typecode.count > 0 then
				create a_splitter.make
				a_splitter.set_separators ("=")
				some_parts := a_splitter.split (a_typecode)
				if some_parts.count /= 2 then
					set_local_error ("Invalid parameter in ftp URI: " + a_typecode)
				else
					if STRING_.same_case_insensitive (some_parts.item (1), "typecode") then
						a_typecode := some_parts.item (2)
						if a_typecode.count /= 1 then
							set_local_error ("Invalid value for typecode parameter in ftp URI: " + a_typecode)
						end
					else
						set_local_error ("Invalid parameter in ftp URI: " + a_typecode)
					end
				end
			end
			if not has_local_error then
				prepare_retrieval (a_client, a_path, a_typecode)
			end
		end

	prepare_retrieval (a_client: EPX_FTP_CLIENT; a_path, a_typecode: STRING)
			-- Prepare to retrieve file.
		require
			path_not_void: a_path /= Void
			plausible_typecode: a_typecode /= Void and then a_typecode.count < 2
			no_errors_yet: not has_local_error
		local
			a_splitter: ST_SPLITTER
			some_parts: DS_LIST [STRING]
			a_cursor: DS_LIST_CURSOR [STRING]
		do
			debug ("XML ftp resolver")
				std.error.put_string ("Preparing to retrieve file%N")
			end
			create a_splitter.make
			a_splitter.set_separators ("/")
			some_parts := a_splitter.split (a_path)
			debug ("XML ftp resolver")
				std.error.put_string ("Path has ")
				std.error.put_string (some_parts.count.out)
				std.error.put_string (" components%N")
			end
			from
				a_cursor := some_parts.new_cursor; a_cursor.start
			until
				has_error or else a_cursor.after
			loop
				if a_cursor.index	= some_parts.count and then
					not (a_typecode.count = 1 and then as_lower(a_typecode.item (1)) = 'd') then
					retrieve_file (a_client, a_cursor.item, a_typecode)
				else
					debug ("XML ftp resolver")
						std.error.put_string ("Attempting to change directory to ")
						std.error.put_string (a_cursor.item)
						std.error.put_new_line
					end
					a_client.change_directory (a_cursor.item)
					if a_client.last_reply_code = 550 then
						set_local_error ("Failed to change to the required directory")
					elseif a_client.last_reply_code /= 250 then
						set_local_error ("Unexpected reply code when trying to change to the required directory: " + a_client.last_reply_code.out)
					end
				end
				a_cursor.forth
			variant
				some_parts.count + 1 - a_cursor.index
			end
			if a_typecode.count = 1 and then as_lower(a_typecode.item (1)) = 'd' then
				debug ("XML ftp resolver")
					std.error.put_string ("Attempting to list directory.%N")
				end
				a_client.name_list
				is_retrieving := True
				if attached {EPX_TCP_CLIENT_SOCKET} a_client.data_connection as l_socket then
					create {EPX_FTP_RESOLVER_STREAM} last_stream.make (a_client, l_socket)
				end
			end
		end

	retrieve_file (a_client: EPX_FTP_CLIENT; a_file_name, a_typecode: STRING)
			-- Retrieve `a_file_name'.
		require
			file_not_empty: a_file_name /= Void and then a_file_name.count > 0
			plausible_typecode: a_typecode /= Void and then a_typecode.count < 2
			no_errors_yet: not has_error
		local
			retried: BOOLEAN
		do
			if not retried then
				debug ("XML ftp resolver")
					std.error.put_string ("Attempting to retrieve file " + a_file_name)
					std.error.put_new_line
				end

				if a_typecode.count = 1 then
					if as_lower(a_typecode.item (1)) = 'i' then
						a_client.type_binary
						if a_client.last_reply_code /= 200 then
							set_local_error ("Unexpected reply code when trying to change to binary transfer mode: " + a_client.last_reply_code.out)
						end
					elseif as_lower(a_typecode.item (1)) = 'a' then
						a_client.type_ascii
						if a_client.last_reply_code /= 200 then
							set_local_error ("Unexpected reply code when trying to change to ASCII transfer mode: " + a_client.last_reply_code.out)
						end
					else
						set_local_error ("Illegal typecode in ftp: " + a_typecode)
					end
				end
				if not has_error then
					a_client.retrieve (a_file_name)
					is_retrieving := True
					if attached {EPX_TCP_CLIENT_SOCKET} a_client.data_connection as l_socket then
						create {EPX_FTP_RESOLVER_STREAM} last_stream.make (a_client, l_socket)
					end
				end
			end
		rescue
			is_retrieving := False
			if Exceptions.is_developer_exception then
				if attached Exceptions.developer_exception_name as l_name then
					set_local_error ("An attempt to retrieve a file by ftp resulted in the condition: " + l_name)
				else
					set_local_error ("An attempt to retrieve a file by ftp resulted in the condition: <no name>")
				end
			else
				set_local_error ("An attempt to retrieve a file by ftp resulted in exception code " + Exceptions.exception.out)
			end
			retried := True
			retry
		end

end
