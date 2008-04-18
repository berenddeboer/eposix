indexing

	description:

		"External URI resolver for the ftp protocol"

	library: "eposix"
	author: "Colin Adams"
	copyright: "Copyright (c) 2004, Colin Adams"
	license: "MIT License"
	date: "$Date: "
	revision: "$Revision: "


class

	EPX_FTP_URI_RESOLVER

inherit

	XM_URI_RESOLVER

	KL_SHARED_EXECUTION_ENVIRONMENT

	KL_CHARACTER_ROUTINES

	KL_SHARED_EXCEPTIONS

	KL_SHARED_STANDARD_FILES

feature -- Operation(s)

	scheme: STRING is "ftp"

	resolve (a_uri: UT_URI) is
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
			if a_uri.has_user_info then
				create a_splitter.make
				a_splitter.set_separators (":")
				some_parts := a_splitter.split (a_uri.user_info)
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
			client.open
			if client.is_open then
				parse_path (a_uri)
			else
				set_local_error ("Failed to connect to ftp server")
			end
		end

feature -- Result

	has_error: BOOLEAN is
			-- Did the last resolution attempt succeed?
		do
			Result := has_local_error or else is_retrieving and then client.last_reply_code /= 150
		end

	is_retrieving: BOOLEAN
			-- Is the file being retrieved?

	last_error: STRING is
		local
			a_message: STRING
		do
			if has_local_error then
				Result := last_local_error
			else
				Result := "Ftp returned code " + client.last_reply_code.out
			end
			a_message := STRING_.concat ("URI ", last_uri.full_reference)
			a_message := STRING_.appended_string (a_message, " ")
			Result := STRING_.appended_string (a_message, Result)
		end

	last_stream: KI_CHARACTER_INPUT_STREAM
			-- Matching stream

	has_media_type: BOOLEAN is
			-- Is the media type available.
		do
			Result := False
		end

	last_media_type: UT_MEDIA_TYPE is
			-- Media type, if available.
		do
			-- pre-condition is never met
		end

feature {NONE} -- Implementation

	client: EPX_FTP_CLIENT
			-- Current client

	has_local_error: BOOLEAN

	last_local_error: like last_error

	last_uri: UT_URI

	set_local_error (an_error_string: STRING) is
			-- Set a local error.
		require
			error_string_not_void: an_error_string /= Void
		do
			has_local_error := True
			last_local_error := an_error_string
		ensure
			error_set: has_local_error and then STRING_.same_string (an_error_string, last_local_error)
		end

	parse_path (a_uri: UT_URI) is
			-- Parse path component
		require
			uri_not_void: a_uri /= Void
			client_open: client /= Void and then client.is_open
			no_errors_yet: not has_local_error
		local
			a_path, a_typecode: STRING
			a_splitter: ST_SPLITTER
			some_parts: DS_LIST [STRING]
		do
			if client.is_authenticated then
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
				end
				if a_uri.has_query then
					set_local_error ("Query string is illegal in ftp URI")
				end
				--						if a_uri.fragment /= Void then
				--  We ignore any fragment-id
				--						end
			else
				set_local_error ("Server failed to authenticate client")
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
			if not has_local_error then prepare_retrieval (a_path, a_typecode) end
		end

	prepare_retrieval (a_path, a_typecode: STRING) is
			-- Prepare to retrieve file.
		require
			path_not_void: a_path /= Void
			plausible_typecode: a_typecode /= Void and then a_typecode.count < 2
			no_errors_yet: not has_local_error
		local
			a_splitter: ST_SPLITTER
			some_parts: DS_LIST [STRING]
			a_cursor: DS_LIST_CURSOR [STRING]
			a_socket: EPX_TCP_CLIENT_SOCKET
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
			variant
				some_parts.count + 1 - a_cursor.index
			until
				has_error or else a_cursor.after
			loop
				if a_cursor.index	= some_parts.count and then
					not (a_typecode.count = 1 and then as_lower(a_typecode.item (1)) = 'd') then
					retrieve_file (a_cursor.item, a_typecode)
				else
					debug ("XML ftp resolver")
						std.error.put_string ("Attempting to change directory to ")
						std.error.put_string (a_cursor.item)
						std.error.put_new_line
					end
					client.change_directory (a_cursor.item)
					if client.last_reply_code = 550 then
						set_local_error ("Failed to change to the required directory")
					elseif client.last_reply_code /= 250 then
						set_local_error ("Unexpected reply code when trying to change to the required directory: " + client.last_reply_code.out)
					end
				end
				a_cursor.forth
			end
			if a_typecode.count = 1 and then as_lower(a_typecode.item (1)) = 'd' then
				debug ("XML ftp resolver")
					std.error.put_string ("Attempting to list directory.%N")
				end
				client.name_list
				is_retrieving := True
				a_socket ?= client.data_connection
				check
					socket_not_void: a_socket /= Void
				end
				create {EPX_FTP_RESOLVER_STREAM} last_stream.make (client, a_socket)
			end
		end

	retrieve_file (a_file_name, a_typecode: STRING) is
			-- Retrieve `a_file_name'.
		require
			file_not_empty: a_file_name /= Void and then a_file_name.count > 0
			plausible_typecode: a_typecode /= Void and then a_typecode.count < 2
			no_errors_yet: not has_error
		local
			retried: BOOLEAN
			a_socket: EPX_TCP_CLIENT_SOCKET
		do
			if not retried then
				debug ("XML ftp resolver")
					std.error.put_string ("Attempting to retrieve file " + a_file_name)
					std.error.put_new_line
				end
				if a_typecode.count = 1 then
					if as_lower(a_typecode.item (1)) = 'i' then
						client.type_binary
						if client.last_reply_code /= 200 then
							set_local_error ("Unexpected reply code when trying to change to binary transfer mode: " + client.last_reply_code.out)
						end
					elseif as_lower(a_typecode.item (1)) = 'a' then
						client.type_ascii
						if client.last_reply_code /= 200 then
							set_local_error ("Unexpected reply code when trying to change to ASCII transfer mode: " + client.last_reply_code.out)
						end
					else
						set_local_error ("Illegal typecode in ftp: " + a_typecode)
					end
				end
				if not has_error then
					client.retrieve (a_file_name)
					is_retrieving := True
					a_socket ?= client.data_connection
					check
						socket_not_void: a_socket /= Void
					end
					create {EPX_FTP_RESOLVER_STREAM} last_stream.make (client, a_socket)
				end
			end
		rescue
			is_retrieving := False
			if Exceptions.is_developer_exception then
				set_local_error ("An attempt to retrieve a file by ftp resulted in the condition: " + Exceptions.developer_exception_name)
			else
				set_local_error ("An attempt to retrieve a file by ftp resulted in exception code " + Exceptions.exception.out)
			end
			retried := True
			retry
		end

end
