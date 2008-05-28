indexing

	description: "Makes an STDC_TEXT_FILE available as a KI_OUTPUT_STREAM [STRING]."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_STRING_OUTPUT_FILE

obsolete
		"2003-05-08: There is no need for this class as STDC_TEXT_FILE is a KI_OUTPUT_STREAM at the moment (albeit a character one)."

inherit

	STDC_TEXT_FILE


create

	create_read_write,
	create_write


end
