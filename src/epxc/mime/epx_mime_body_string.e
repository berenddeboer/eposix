note

	description: "Body that is stored in a STRING."

	author: "Berend de Boer"


class

	EPX_MIME_BODY_STRING


inherit

	EPX_MIME_BODY_TEXT
		redefine
			as_string
		end


create

	make


feature {NONE} -- Initialization

	make
			-- Initialize text body.
		do
			value := ""
			create {KL_STRING_OUTPUT_STREAM} output_stream.make (value)
		end


feature -- Access to body content

	as_string: STRING
			-- Return `value'.
		do
			flush_encoder
			Result := value
		end

	rewind_stream
			-- Make sure `stream' starts returning character the
			-- beginning of the body.
		do
			stream.rewind
		end

	stream: EPX_STRING_INPUT_STREAM
			-- Return a stream to the actual body.
		once
			create Result.make (value)
		end


feature {NONE} -- State

	value: STRING


invariant

	has_value: value /= Void

end
