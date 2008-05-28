indexing

	description: "Class that describes the NetLogger level field."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	NET_LOGGER_LEVEL_FIELD


inherit

	NET_LOGGER_FIELD
		rename
			make as inherited_make
		export
			{NONE} set_value
		end

	NET_LOGGER_LEVELS


create

	make


feature {NONE} -- Initialization

	make (a_level: INTEGER)  is
		require
			valid_level: is_valid_level (a_level)
		local
			names: NET_LOGGER_RESERVED_NAMES
		do
			set_level (a_level)
			create names
			inherited_make (names.level, value)
		end


feature -- Access

	level: INTEGER
			-- Logging level


feature -- Set level

	set_level (a_level: INTEGER) is
			-- Set `level' and `value'.
		require
			valid_level: is_valid_level (a_level)
		do
			level := a_level
			inspect level
			when fatal then value := "fatal"
			when error then value := "error"
			when warning then value := "warning"
			when info then value := "info"
			when debug0 then value := "debug"
			else
				value := "debug" + (a_level - debug0).out
			end
		ensure
			definition: level = a_level
		end


invariant

	valid_level: is_valid_level (level)

end
