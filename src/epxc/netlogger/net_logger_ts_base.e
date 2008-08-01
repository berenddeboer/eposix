indexing

	description: "Base class for NetLogger Microsecond precision date field."

	author: "Berend de Boer"
	copyright: "(c) 2007 by Berend de Boer."


deferred class

	NET_LOGGER_TS_BASE


inherit

	STDC_BASE

	NET_LOGGER_FIELD
		rename
			make as inherited_make
		end


feature {NONE} -- Initialization

	make is
			-- Make sure date field has a value.
		local
			names: NET_LOGGER_RESERVED_NAMES
		do
			create names
			name := names.timestamp
			create value.make (expected_length)
			refresh
		end


feature -- Access

	expected_length: INTEGER is 27
			-- Length expected for a date field is up to microsecond precision


feature -- Change

	refresh is
		deferred
		end


end
