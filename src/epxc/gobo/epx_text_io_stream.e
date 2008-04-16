indexing

	description: "All eposix's file/socket classes are bidirectional in principle. This class is the base class for them and combines the Gobo KI_INPUT_STREAM and KI_OUTPUT_STREAM."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


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

-- 		rename
-- 			close as close_for_reading,
-- 			end_of_input as eof,
-- 			is_closable as is_closable_for_reading,
-- 			name as path,
-- 			read_to_buffer as non_blocking_read_to_buffer,
-- 			read_character as non_blocking_read_character,
-- 			read_string as non_blocking_read_string,
-- 			read_to_string as non_blocking_read_to_string
-- 		undefine
-- 			eol,
-- 			is_closable_for_reading,
-- 			non_blocking_read_to_buffer,
-- 			non_blocking_read_to_string,
-- 			rewind,
-- 			valid_unread_character
-- 		end


end
