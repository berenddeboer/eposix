indexing

	description: "Body that is stored in a STRING."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

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

	make is
			-- Initialize text body.
		do
			value := ""
			create {KL_STRING_OUTPUT_STREAM} output_stream.make (value)
		end


feature -- Access to body content

	as_string: STRING is
			-- Return `value'.
		do
			flush_encoder
			Result := value
		end

	rewind_stream is
			-- Make sure `stream' starts returning character the
			-- beginning of the body.
		do
			if my_stream /= Void then
				my_stream.rewind
			end
		end

	stream: EPX_STRING_INPUT_STREAM is
			-- Return a stream to the actual body.
		do
			if my_stream = Void then
				create my_stream.make (value)
			end
			Result := my_stream
		end


feature {NONE} -- State

	my_stream: like stream

	value: STRING


invariant

	has_value: value /= Void

end
