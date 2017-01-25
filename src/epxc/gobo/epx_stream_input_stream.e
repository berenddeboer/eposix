note

	description: "Stream that gets its input from another stream."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


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
			source.read
		end

	unread (an_item: G)
			-- Put `an_item' back in input stream.
			-- This item will be read first by the next
			-- call to a read routine.
		do
			source.unread (an_item)
		end


feature -- Status report

	is_open_read: BOOLEAN
			-- Can items be read from input stream?
		do
			Result := source /= Void and then source.is_open_read
		end

	end_of_input: BOOLEAN
			-- Has the end of input stream been reached?
		do
			Result := source.end_of_input
		end

	valid_unread_item (an_item: G): BOOLEAN
			-- Can `an_item' be put back in input stream?
		do
			Result := source /= Void and then source.valid_unread_item (an_item)
		end

	is_closable: BOOLEAN
			-- Can current input stream be closed?
		do
			Result := source /= Void and then source.is_closable
		end


feature -- Access

	name: STRING
			-- Name of input stream
		do
			if source /= Void then
				Result := source.name
			else
				Result := ""
			end
		end

	source: KI_INPUT_STREAM [G]
			-- Where this stream derives it input from

	last_item: G
			-- Last item read
		do
			Result := source.last_item
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
