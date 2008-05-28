indexing

	description: "Makes an STDC_TEXT_FILE available as a KI_CHARACTER_INPUT_STREAM."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_TEXT_INPUT_FILE

obsolete "2003-05-08: there is no need for this class any more since STDC_TEXT_FILE is a KI_CHARACTER_INPUT_STREAM."

inherit

	STDC_TEXT_FILE


create

	open,
	open_read

end
