indexing

	description: "Microsecond precision date for the NetLogger API on Unix."

	library: "eposix library"
	author: "Berend de Boer"
	copyright: "(c) 2007 by Berend de Boer."


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
			create timeofday.make_from_now
			create date.make_from_unix_time (timeofday.seconds)
			precursor
		end


feature -- Access

	date: STDC_TIME

	timeofday: SUS_TIME_VALUE
			-- Current time, set by `refresh'

feature -- Commands

	refresh is
			-- Make `value' equal to current time.
		do
			timeofday.make_from_now
			date.make_from_unix_time (timeofday.seconds)
			date.to_utc
			value.wipe_out
			value.append_string (date.format (once "%%Y-%%m-%%dT%%H-%%M-%%S."))
			sh.append_integer (value, timeofday.microseconds, 6)
			value.append_character ('Z')
		end

invariant

	date_not_void: date /= Void

end
