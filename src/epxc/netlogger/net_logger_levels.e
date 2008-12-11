indexing

	description:

		"NetLogger log levels"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"


class

	NET_LOGGER_LEVELS


feature -- Access

	nolog: INTEGER is 0
			-- Log nothing

	fatal: INTEGER is 1
			-- Component cannot continue, or system is unusable

	error: INTEGER is 2
			-- Action must be taken immediately

	warning: INTEGER is 3
			-- Problems that are recovered from, usually

	info: INTEGER is 4
			-- Normal but significant condition

	debug0: INTEGER is 5
			-- Lower level information concerning program logic
			-- decisions, internal state, etc.

	debug1: INTEGER is 6
			-- More detailed debugging.

	debug2: INTEGER is 7
			-- Even more detailed debugging.

	debug3: INTEGER is 8
			-- Even more detailed debugging.

	debug4: INTEGER is 9
			-- Even more detailed debugging.

	trace: INTEGER is 10
			-- Finest granularity, similar to “stepping through” the
			-- component or system.


feature -- Status

	is_valid_level (a_level: INTEGER): BOOLEAN is
		do
			Result := a_level >= fatal and then a_level <= trace
		end

end
