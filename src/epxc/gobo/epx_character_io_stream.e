indexing

	description: "All eposix's file/socket classes are bidirectional. This class is the base class for them and combines the Gobo KI_INPUT_STREAM and KI_OUTPUT_STREAM."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	EPX_CHARACTER_IO_STREAM


inherit

	EPX_CHARACTER_INPUT_STREAM
		rename
			close as close_for_reading,
			is_closable as is_closable_for_reading
		redefine
			is_closable_for_reading
		end

	EPX_CHARACTER_OUTPUT_STREAM
		rename
			close as close_for_writing,
			is_closable as is_closable_for_writing
		redefine
			is_closable_for_writing
		end


feature -- Basic operations

	close is
		require
			owner: is_owner
		deferred
		end

	close_for_reading	is
			-- Try to close input stream if it is closable. Set
			-- `is_open_read' to false if operation was successful.
		do
			close
		ensure then
			closed: not is_open_read
		end

	close_for_writing is
			-- Try to close output stream if it is closable. Set
			-- `is_open_write' to false if operation was successful.
		do
			close
		ensure then
			closed: not is_open_write
		end


feature -- Status report

	is_closable_for_reading: BOOLEAN is
			-- Can current input stream be closed?
		do
			Result := is_owner and is_open_read
		end

	is_closable_for_writing: BOOLEAN is
			-- Can current output stream be closed?
		do
			Result := is_owner and is_open_write
		end

	is_closable: BOOLEAN is
			-- Can current stream be closed for reading and writing?
		do
			Result := is_owner
		ensure
			is_open: Result implies is_owner
		end

	is_open: BOOLEAN is
			-- Does current stream have a non-closed handle?
		deferred
		end

	is_owner: BOOLEAN is
			-- May this object close the stream on `close' or `dispose'?
		deferred
		end


invariant

	open_in_sync: (is_open_read or is_open_write) implies is_open
			-- The reverse is not true, for examples sockets can be
			-- closed for reading/writing, but still open.

end
