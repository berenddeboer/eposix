indexing

	description: "Class that describes the ULM LVL field."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #1 $"

class

	ULM_LVL_FIELD

inherit

	ULM_FIELD
		rename
			make as inherited_make
		export
			{NONE} set_value
		end

	ULM_LOG_LEVELS

creation

	make

feature {NONE} -- Initialization

	make (a_level: INTEGER)  is
		require
			valid_level: is_valid_log_level (a_level)
		do
			set_level (a_level)
			inherited_make ("LVL", value)
		end

feature -- Set level

	set_level (a_level: INTEGER) is
		require
			valid_level: is_valid_log_level (a_level)
		do
			value := log_level_text.item (a_level)
		end

end
