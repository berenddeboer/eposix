indexing

	description: "Certain eposix classes can read lines. They will inherit from this class as well as from EPX_CHARACTER_INPUT_STREAM"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	EPX_TEXT_INPUT_STREAM

inherit

	EPX_CHARACTER_INPUT_STREAM

	KI_TEXT_INPUT_STREAM
		undefine
			close,
			is_rewindable,
			read_to_string,
			valid_unread_character
		end


feature -- Access

	eol: STRING is "%N"
			-- Line separator;
			-- EPX classes do not distinguish between a %R%N or just %N
			-- end-of-line. The platform may though.


end
