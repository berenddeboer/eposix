indexing

	description: "Class that implements the ULM DATE field for Standard C."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	ULM_STDC_DATE_FIELD

inherit

	ULM_DATE_FIELD
		redefine
			make
		end

create

	make

feature {NONE} -- Initialization

	make  is
			-- Make sure date field has a value.
		do
			create date.make_from_now
			precursor
		end

feature -- Public state

	date: STDC_TIME
			-- Current time, set by `refresh'

feature -- Query

	expected_length: INTEGER is
			-- Length expected for a date field.
		do
			Result := 14
		end

feature -- Commands

	refresh is
			-- Make `value' equal to current time
		do
			date.make_from_now
			date.to_utc
			value.wipe_out
			sh.append_integer (value, date.year, 4)
			sh.append_integer (value, date.month, 2)
			sh.append_integer (value, date.day, 2)
			sh.append_integer (value, date.hour, 2)
			sh.append_integer (value, date.minute, 2)
			sh.append_integer (value, date.second, 2)
		end

invariant

	date_not_void: date /= Void

end
