note

	description: "Stream that gets its input from another stream."

	author: "Berend de Boer"


class

	EPX_STREAM_INPUT_STREAM [G]


create

	make,
	make_connect


feature -- Initialization

	make
		do
		end

	make_connect (a_source: like source)
			-- Initialize stream, optionally connect it to `a_source'.
		do
			make
			set_source (a_source)
		ensure
			source_set: source = a_source
		end


feature -- Input

	read
			-- Read the next item in input stream.
			-- Make the result available in `last_item'.
		do
			if attached source as a_source then
				a_source.read
			end
		end

	unread (an_item: G)
			-- Put `an_item' back in input stream.
			-- This item will be read first by the next
			-- call to a read routine.
		do
			if attached source as a_source then
				a_source.unread (an_item)
			end
		end


feature -- Status report

	is_open_read: BOOLEAN
			-- Can items be read from input stream?
		do
			Result := attached source as a_source and then a_source.is_open_read
		end

	end_of_input: BOOLEAN
			-- Has the end of input stream been reached?
		do
			if attached source as a_source then
				Result := a_source.end_of_input
			else
				Result := True
			end
		end

	valid_unread_item (an_item: G): BOOLEAN
			-- Can `an_item' be put back in input stream?
		do
			Result := attached source as a_source and then a_source.valid_unread_item (an_item)
		end

	is_closable: BOOLEAN
			-- Can current input stream be closed?
		do
			Result := attached source as a_source and then a_source.is_closable
		end


feature -- Access

	name: STRING
			-- Name of input stream
		do
			if attached source as a_source then
				Result := a_source.name
			else
				Result := ""
			end
		end

	source: detachable KI_INPUT_STREAM [G]
			-- Where this stream derives it input from

	last_item: detachable G
			-- Last item read
		do
			if attached source as a_source then
				Result := a_source.last_item
			end
		end


feature -- Change

	set_source (a_source: like source)
			-- Set `source'.
		do
			source := a_source
		ensure
			source_set: source = a_source
		end


end
