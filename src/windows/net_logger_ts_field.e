indexing

	description: "Second only precision date for the NetLogger API on Windows."

	library: "eposix library"
	author: "Berend de Boer"
	copyright: "(c) 2008 by Berend de Boer."


class

	NET_LOGGER_TS_FIELD


inherit

	NET_LOGGER_TS_BASE
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


feature -- Access

	date: STDC_TIME

feature -- Commands

	refresh is
			-- Make `value' equal to current time.
		do
			date.make_from_now
			date.to_utc
			value.wipe_out
			value.append_string (date.format (once "%%Y-%%m-%%dT%%H-%%M-%%S"))
			value.append_character ('Z')
		end

invariant

	date_not_void: date /= Void

end
