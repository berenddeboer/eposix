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


creation

	make


feature {NONE} -- Initialization

	make is
			-- Initialize text body.
		do
			value := ""
		end


feature -- Access to body content

	as_string: STRING is
			-- Return `value'.
		do
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


feature -- Change body commands

	append_character (c: CHARACTER) is
			-- Extend `value' with `c' somehow.
		do
			value.append_character (c)
		end

	append_string (s: STRING) is
			-- Extend `value' with `s' somehow.
		do
			value.append_string (s)
		end


feature {NONE} -- State

	my_stream: like stream

	value: STRING


invariant

	has_value: value /= Void

end
