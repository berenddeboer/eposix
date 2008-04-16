indexing

	description: "Base class for eposix's file and descriptor classes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	STDC_HANDLE_BASED_IO_STREAM [H]


inherit

	STDC_HANDLE [H]
		redefine
			detach
		end

	EPX_TEXT_IO_STREAM

	PORTABLE_PATH
		rename
			portable_path as name
		export
			{ANY} name
		end


feature -- Status

	eof: BOOLEAN is
		obsolete "2006-10-23: Use end_of_input instead"
		do
			Result := end_of_input
		end

	is_open_read: BOOLEAN
			-- Can items be read from input stream?

	is_open_write: BOOLEAN
			-- Can items be written to output stream?

	is_streaming: BOOLEAN
			-- Is data coming from a network stream?


feature -- Access

	last_character: CHARACTER
			-- Last character read by `read_character' and a few other
			-- routines

	last_read: INTEGER
			-- Last bytes read by `read_buffer';
			-- Can be less than requested for non-blocking input.
			-- Check `last_blocked' in that case.

	last_string: STRING
			-- Last string read;
			-- (Note: this query always return the same object.
			-- Therefore a clone should be used if the result
			-- is to be kept beyond the next call to this feature.
			-- However `last_string' is not shared between file objects.)

	last_written: INTEGER
			-- How many bytes were written by the last call to a routine;
			-- Can be less than requested for non-blocking output.
			-- Check `last_blocked' in that case.


feature -- Stream or disk file

	set_streaming (enable: BOOLEAN) is
			-- Influence behaviour of certain functions if they should be
			-- optimized for data coming from disk or data coming from
			-- the network. In particular `is_streaming' implies that a
			-- client application is prepared to handle `read's that
			-- return less than the requested number of bytes, but don't
			-- assume that means end-of-file.
		do
			is_streaming := enable
		ensure
			streaming_set: is_streaming = enable
		end


feature -- Close

	detach is
			-- Forget the resource. Resource is not closed.
			-- You cannot read and write anymore.
		do
			precursor
			is_open_read := False
			is_open_write := False
		ensure then
			not_read: not is_open_read
			not_write: not is_open_write
		end


end
