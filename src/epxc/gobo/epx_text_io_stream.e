note

	description: "All eposix's file/socket classes are bidirectional in principle. This class is the base class for them and combines the Gobo KI_INPUT_STREAM and KI_OUTPUT_STREAM."

	author: "Berend de Boer"


deferred class

	EPX_TEXT_IO_STREAM


inherit

	EPX_CHARACTER_IO_STREAM

	EPX_TEXT_INPUT_STREAM
		rename
			close as close_for_reading,
			is_closable as is_closable_for_reading
		undefine
			is_closable_for_reading
		end

	EPX_TEXT_OUTPUT_STREAM
		rename
			close as close_for_writing,
			is_closable as is_closable_for_writing
		undefine
			is_closable_for_writing
		end


end
