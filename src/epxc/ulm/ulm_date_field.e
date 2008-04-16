indexing

	description: "Class that describes the ULM DATE field."
	usage: "Implement refresh to set value to current date."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

deferred class

	ULM_DATE_FIELD

inherit

	ULM_FIELD
		rename
			make as inherited_make
		end

	STDC_BASE


feature {NONE} -- Initialization

	make is
			-- Make sure date field has a value.
		do
			create value.make (expected_length)
			refresh
			inherited_make (once "DATE", value)
		end

feature -- Query

	expected_length: INTEGER is
			-- Length expected for a date field
		deferred
		ensure
			valid_length: Result > 0
		end

feature -- Commands

	refresh is
			-- Make `value' equal to current time.
		deferred
		ensure
			correct_length: value.count = expected_length
		end

end
