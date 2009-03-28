indexing

	description: "Body that contains text. Either saved in memory or in file."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	EPX_MIME_BODY_TEXT


inherit

	EPX_MIME_BODY


feature -- Queries

	decoder: EPX_STREAM_INPUT_STREAM [CHARACTER]

	has_every_part_a_form_content_disposition_field: BOOLEAN is True

	has_parts_with_multipart_bodies: BOOLEAN is False

	is_multipart: BOOLEAN is False

	parts_count: INTEGER is 0
		-- The number of parts if is_multipart.

	part (index: INTEGER): EPX_MIME_PART is
			-- Part number `index' if this is a multipart body.
		do
			-- Do nothing.
		end


feature -- Access to body content

	append_to_string (s: STRING) is
			-- Stream contents of MIME structure to a STRING.
			-- Streams body as encoded, does not return plain text.
		do
			s.append_string (as_string)
		end

	as_plain_text: STRING is
			-- Return the contents of this body as 8bit text/plain data.
			-- It is not checked if the resulting string does contain
			-- NULL characters.
		do
			if decoder = Void then
				Result := as_string
			else
				decoder.set_source (stream)
				rewind_stream
				create Result.make_empty
				from
					decoder.read
				until
					decoder.end_of_input
				loop
					Result.append_character (decoder.last_item)
					decoder.read
				end
			end
		end

	rewind_stream is
			-- Make sure `stream' starts returning character the
			-- beginning of the body.
		deferred
		end

	stream: KI_CHARACTER_INPUT_STREAM is
			-- Stream to the actual body; to be used for reading that body
		deferred
		ensure
			stream_not_void: Result /= Void
		end

	output_stream: KI_CHARACTER_OUTPUT_STREAM
			-- Stream to the actual body; to be used when writing to that body


feature -- Change body commands

	append_character (c: CHARACTER) is
			-- Extend value with `c' somehow.
		require
			writable: output_stream.is_open_write
		do
			output_stream.put_character (c)
		end

	append_string (s: STRING) is
			-- Extend value with `s' somehow.
		require
			writable: output_stream.is_open_write
			s_not_void: s /= Void
		do
			output_stream.put_string (s)
		end


feature -- Change

	set_decoder (a_decoder: EPX_STREAM_INPUT_STREAM [CHARACTER]) is
			-- Set `decoder'.
		do
			decoder := a_decoder
		ensure
			decoder_set: decoder = a_decoder
		end

	set_encoder (an_encoder: KL_PROXY_CHARACTER_OUTPUT_STREAM) is
			-- Replace `output_stream', assuming that it writes to
			-- `output_stream'.
		require
			writes_to_output_stream: an_encoder.base_stream = output_Stream
		do
			output_stream := an_encoder
		ensure
			encoder_set: output_stream = an_encoder
		end


feature {NONE} -- Implementation

	flush_encoder is
		do
			output_stream.flush
		end


invariant

	output_stream_not_void: output_stream /= Void

end
