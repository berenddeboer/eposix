note

	description:

		"Routines to read and parse Fast CGI stream"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_FAST_CGI


inherit {NONE}

	EPX_FAST_CGI_CONSTANTS

	KL_IMPORTED_STRING_ROUTINES

	POSIX_CONSTANTS


create

	make


feature {NONE} -- Initialisation

	make (a_socket: ABSTRACT_TCP_SOCKET)
		require
			socket_not_void: a_socket /= Void
		do
			socket := a_socket
			if not socket.is_blocking_io then
				socket.set_blocking_io (True)
			end
			socket.set_continue_on_error
			socket.errno.clear_all
			create parameters.make (64)
			parameters.compare_objects
			create header_buf.allocate_and_clear (Fcgi_header_len)
			create body_buf.allocate_and_clear (Fcgi_max_len)
			create output_header_buf.allocate_and_clear (Fcgi_header_len)
			output_header_buf.poke_int8 (0, Fcgi_version)
			create last_string.make (1024)
		end


feature -- Status

	is_connection_terminated: BOOLEAN
			-- Set if read or write to webserver has failed;
			-- Can be used to abort request processing early

	end_of_input: BOOLEAN


feature -- Access

	content_length: INTEGER
			-- Max input bytes to read from stdin as given by the
			-- Content-Length parameter

	parameters: attached HASH_TABLE [STRING, STRING]
			-- Filled by `read_all_parameters'

	socket: ABSTRACT_TCP_SOCKET
			-- Socket through which we communicate

	last_character: CHARACTER
			-- Last character read by `read_chacter'

	last_read: INTEGER
			-- How many characters were read by `read_buffer'

	bytes_read: INTEGER
			-- Total stdin bytes read;
			-- Should be less or equal than `content_length'

	last_string: STRING
			-- Last string read by `read_string'


feature -- Reading

	read_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER)
			-- Read data into `buf' at `offset' for `nbytes' bytes.
			-- Number of bytes actually read are available in `last_read'.
		require
			is_open_read: socket.is_open_read
			not_end_of_input: not end_of_input
			nbytes_not_negative: nbytes >= 0
			offset_not_negative: offset >= 0
			buf_not_void: buf /= Void
			dont_overflow: buf.capacity >= offset + nbytes
		local
			done: BOOLEAN
		do
			end_of_input := bytes_read = content_length
			last_read := 0
			if not end_of_input then
				if last_record_type = 0 then
					read_record_header
				end
				from
				until
					socket.errno.is_not_ok or else
					done
				loop
					if last_record_type = Fcgi_stdin then
						-- We will always read an entire block as we don't cache
							check
								can_read_entire_block: nbytes >= last_content_length
							end
						do_read_record_body (buf, offset, last_content_length)
						last_read := socket.last_read
						done := True
					else
						read_record_body (last_content_length)
						action_record_body (last_record_type, last_content_length, body_buf)
						done := last_record_type = Fcgi_abort_request
					end
				end
			end
			last_record_type := 0
		ensure
			last_record_type_unset: last_record_type = 0
			consistent: last_read > 0 implies not end_of_input
		end

	read_string
			-- If stdin input is pending, put this in `last_string'.
		do
			last_string.wipe_out
			if last_record_type = 0 then
				read_record_header
			end
			read_record_body (last_content_length)
			action_record_body (last_record_type, last_content_length, body_buf)
			last_record_type := 0
		ensure
			last_record_type_unset: last_record_type = 0
		end

	read_all_parameters
			-- Read records until FCGI_STDIN or
			-- FCGI_ABORT_REQUEST/FCGI_END_REQUEST is received.
		do
			from
				read_record_header
			until
				socket.errno.is_not_ok or else
				last_record_type = FCGI_STDIN or else
				last_record_type = FCGI_ABORT_REQUEST or else
				last_record_type = FCGI_END_REQUEST or else
				last_record_type = Fcgi_null_request_id
			loop
				read_record_body (last_content_length)
				if not is_connection_terminated then
					action_record_body (last_record_type, last_content_length, body_buf)
					read_record_header
				end
			end
			if parameters.has_key ({WGI_META_NAMES}.content_length) then
				content_length := parameters.item ({WGI_META_NAMES}.content_length).to_integer
			end
		end


feature {NONE} -- Record reading

	header_buf: attached EPX_BUFFER
			-- Set by `read_record_header'

	body_buf: attached EPX_BUFFER
			-- Set by `read_record_body'

	last_record_type: INTEGER
			-- Set by `read_record_header'

	last_request_id: INTEGER
			-- Set by `read_record_header'

	last_content_length: INTEGER
			-- Length of body content;
			-- Set by `read_record_header'

	read_record_header
			-- Read the entire record header.
			-- Set `last_record_type', `last_request_id', and
			-- `last_content_length'.
		do
			socket.read_buffer (header_buf, 0, header_buf.capacity)
			if socket.errno.is_ok then
				last_record_type := header_buf.peek_uint8 (1)
				last_request_id := header_buf.peek_uint16_big_endian (2)
				last_content_length := header_buf.peek_uint16_big_endian (4)
			else
				last_record_type := Fcgi_unknown_type
			end
		end

	read_record_body (a_content_length: INTEGER)
			-- Reads data, if there's an error sets `is_connection_terminated'.
		require
			content_length_not_negative: a_content_length >= 0
			content_fits: body_buf.capacity >= a_content_length
		local
			pos: INTEGER
			bytes_to_read: INTEGER
		do
			from
				bytes_to_read := a_content_length
			until
				bytes_to_read <= 0
			loop
				do_read_record_body (body_buf, pos, bytes_to_read)
				is_connection_terminated := socket.errno.is_not_ok
				if not is_connection_terminated then
					bytes_to_read := bytes_to_read - socket.last_read
					pos := pos + socket.last_read
				else
					bytes_to_read := -1
				end
			variant
				bytes_to_read
			end
		end

	do_read_record_body (buf: STDC_BUFFER; offset, nbytes: INTEGER)
		require
			content_fits: body_buf.capacity >= offset + nbytes
		do
			socket.read_buffer (buf, offset, nbytes)
			if last_record_type = Fcgi_stdin then
				bytes_read := bytes_read + socket.last_read
			end
		end

	action_record_body (a_record_type, a_content_length: INTEGER; a_content: EPX_BUFFER)
			-- Execute some action depending on `a_record_type'
		require
			valid_record_type: a_record_type >= 1 and then a_record_type <= Fcgi_max_type
			valid_content_length: a_content_length >= 0 and then a_content_length <= Fcgi_max_len
			content_not_void: a_content /= Void

		do
			if record_type_handlers.has (a_record_type) then
				record_type_handlers.item (a_record_type).call ([Current, a_content_length, a_content])
			else
				unknown_type_handler (a_record_type)
			end
		end

	record_type_handlers: DS_HASH_TABLE [PROCEDURE [EPX_FAST_CGI, TUPLE [EPX_FAST_CGI, INTEGER, EPX_BUFFER]], INTEGER]
		once
			create Result.make (Fcgi_max_type)
			Result.put (agent {EPX_FAST_CGI}.fcgi_begin_request_handler, Fcgi_begin_request)
			Result.put (agent {EPX_FAST_CGI}.fcgi_params_handler, Fcgi_params)
			Result.put (agent {EPX_FAST_CGI}.fcgi_stdin_handler, Fcgi_stdin)
			Result.put (agent {EPX_FAST_CGI}.fcgi_get_values_handler, Fcgi_get_values)
			Result.put (agent {EPX_FAST_CGI}.fcgi_get_values_result_handler, Fcgi_get_values_result)
		ensure
			not_void: Result /= Void
		end


feature {EPX_FAST_CGI} -- Record handlers

	unknown_type_handler (a_record_type: INTEGER)
			-- Respond that this record type is unknown.
		do
			put_record_header (Fcgi_unknown_type, 0, Fcgi_unknown_body_type_body_len)
			body_buf.poke_int8 (0, a_record_type)
			socket.put_buffer (body_buf, 0, Fcgi_unknown_body_type_body_len)
		end

	fcgi_begin_request_handler (a_content_length: INTEGER; a_content: EPX_BUFFER)
		do
		end

	param_index: INTEGER
			-- Index in buffer where to read a single name and value

	fcgi_params_handler (a_content_length: INTEGER; a_content: EPX_BUFFER)
		do
			from
				param_index := 0
			until
				param_index >= a_content_length
			loop
				fcgi_read_one_param (a_content_length, a_content, param_index)
			end
		end

	fcgi_read_one_param (a_content_length: INTEGER; a_content: EPX_BUFFER; a_param_index: INTEGER)
			-- Read params.
		require
			valid_index: a_content.is_valid_index (a_param_index)
		local
			name_start,
			value_start: INTEGER
			value_length_start: INTEGER
			name_length,
			value_length: INTEGER
			name,
			value: STRING
			index_ok: BOOLEAN
		do
			name_length := a_content.peek_uint8 (a_param_index + 0)
			if name_length >= 128 then
				-- Eh, we really have names with over 65536 in length??
				name_length := a_content.peek_uint16_big_endian (a_param_index + 2)
				value_length_start := a_param_index + 4
			else
				value_length_start := a_param_index + 1
			end
			index_ok := a_content.is_valid_index (value_length_start)
			if index_ok then
				value_length := a_content.peek_uint8 (value_length_start)
				if value_length >= 128 then
					-- Eh, we really have values with over 65536 in length??
					value_length := a_content.peek_uint16_big_endian (value_length_start + 2)
					name_start := value_length_start + 4
				else
					name_start := value_length_start + 1
				end
				value_start := name_start + name_length
				index_ok :=
					a_content.is_valid_range (name_start, name_start + name_length - 1) and then
					a_content.is_valid_range (value_start, value_start + value_length)
				if index_ok then
					name := a_content.substring (name_start, name_start + name_length - 1)
					if value_length > 0 then
						value := a_content.substring (value_start, value_start + value_length - 1)
					else
						create value.make_empty
					end
					param_index := value_start + value_length
					parameters.force (value, name)
				end
			end

			if not index_ok then
				-- Invalid input, skip reading more parameters
				param_index := a_content_length
			end
		ensure
			param_index_updated: param_index > a_param_index
			param_index_not_too_large: param_index <= a_content_length
		end

	fcgi_stdin_handler (a_content_length: INTEGER; a_content: EPX_BUFFER)
		do
			-- We probably can just block when reading is webserver and
			-- fastcgi will be close together, so not much delay, if at
			-- all.
			-- Most probably the web server just sends a block as soon as
			-- it receives new data.
			a_content.append_to_string (last_string, 0, a_content_length - 1)
		ensure
			correct_string_length: last_string.count = a_content_length
		end

	fcgi_get_values_handler (a_content_length: INTEGER; a_content: EPX_BUFFER)
		do
			-- TODO
			-- But we can ignore this for Apache mod-fastcgi as it never sends this
		end

	fcgi_get_values_result_handler (a_content_length: INTEGER; a_content: EPX_BUFFER)
		do
			-- TODO
			-- But we can ignore this for Apache mod-fastcgi as it never sends this
		end


feature -- Writing to stdout

	put_character (c: CHARACTER_8)
			-- Write `c' to web server.
		do
			if socket.errno.is_ok then
				-- TODO: optimise by caching character writing!
				put_record_header (Fcgi_stdout, last_request_id, 1)
				socket.put_character (c)
			end
		end

	put_string (s: READABLE_STRING_8)
			-- Write `c' to web server.
		require
			s_not_void: s /= Void
		local
			left: INTEGER
			buf: STRING
			bytes_to_write: INTEGER
			start: INTEGER
		do
			if not is_connection_terminated then
				if not s.is_empty then
					-- TODO: support large strings
					-- TODO: optimise perhaps by caching small strings before writing?
					if s.count <= Fcgi_max_len then
						put_record_header (Fcgi_stdout, last_request_id, s.count)
						socket.put_string (s)
					else
						from
							start := 1
							left := s.count
							create buf.make (Fcgi_max_len)
						until
							left = 0 or else
							socket.errno.is_not_ok
						loop
							if left > Fcgi_max_len then
								bytes_to_write := Fcgi_max_len
							else
								bytes_to_write := left
							end
							buf.wipe_out
							STRING_.append_substring_to_string (buf, s, start, start + bytes_to_write - 1)
							put_record_header (Fcgi_stdout, last_request_id, bytes_to_write)
							socket.put_string (buf)
							left := left - bytes_to_write
							start := start + bytes_to_write
						variant
							left + 1
						end
					end
					if socket.errno.is_not_ok then
						--print ("ERRNO: " + socket.errno.value.out + "%N")
						is_connection_terminated := True
					end
				end
			end
		end


feature -- Writing to stderr

	stderr_put_line (s: READABLE_STRING_8)
			-- Write string to web server's stderr.
		require
			s_not_void: s /= Void
			string_small_enough: s.count <= Fcgi_max_len
		do
			if not s.is_empty then
				-- TODO: support large strings
				put_record_header (Fcgi_stderr, last_request_id, s.count + 1)
				socket.put_string (s)
				socket.put_character ('%N')
				if socket.errno.is_not_ok then
					is_connection_terminated := True
				end
				terminate_stream (Fcgi_stderr)
			end
		end


feature {NONE} -- Writing

	output_header_buf: EPX_BUFFER

	put_record_header (a_record_type, a_request_id, a_content_length: INTEGER)
		require
			valid_type: a_record_type >= 1 and a_record_type <= Fcgi_max_type
			valid_request_id: a_request_id >= 0
			length_not_negative: a_content_length >= 0
		do
			output_header_buf.poke_uint8 (1, a_record_type)
			output_header_buf.poke_uint16_big_endian (2, a_request_id)
			output_header_buf.poke_uint16_big_endian (4, a_content_length)
			socket.put_buffer (output_header_buf, 0, output_header_buf.capacity)
			if socket.errno.is_not_ok then
				--print ("ERRNO: " + socket.errno.value.out + "%N")
				is_connection_terminated := True
			end
		end

	terminate_stream (a_stream_type: INTEGER)
			-- Indicate end of stream.
		require
			valid_stream_type: a_stream_type = Fcgi_stdout or else a_stream_type = Fcgi_stderr
		do
			put_record_header (a_stream_type, last_request_id, 0)
		end


feature -- Closing

	close
		local
			application_status: INTEGER
		do
			if not is_connection_terminated then
				socket.shutdown_read
				terminate_stream (Fcgi_stdout)
				put_record_header (Fcgi_end_request, last_request_id, Fcgi_end_req_body_len)
				body_buf.poke_int32_big_endian (0, application_status)
				body_buf.poke_int8 (4, Fcgi_request_complete)
				socket.put_buffer (body_buf, 0, Fcgi_unknown_body_type_body_len)
				socket.shutdown_write
			end
			socket.close
			socket.errno.clear_all
		ensure
			closed: not socket.is_open
		end


invariant

	socket_not_void: socket /= Void
	blocking_io: socket.is_open implies socket.is_blocking_io
	header_buf_large_enough: header_buf.capacity >= Fcgi_header_len
	body_buf_large_enough: body_buf.capacity >= Fcgi_max_len
	output_header_buf_not_void: output_header_buf /= Void
	output_header_buf_large_enough: output_header_buf.capacity = Fcgi_header_len
	last_string_not_void: last_string /= Void
	never_read_too_much_from_stdin: bytes_read <= content_length
	param_index_not_negative: param_index >= 0

end
