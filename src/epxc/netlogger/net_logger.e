note

	description: "Class that implements the NetLogger API."

	url: "http://dsd.lbl.gov/NetLoggerWiki/index.php/Main_Page"

	use_when: "NetLogger is designed to make debugging and performance analysis of complex distributed applications easier. See `url' for more details."

	author: "Berend de Boer"
	copyright: "(c) 2007 by Berend de Boer."


class

	NET_LOGGER


inherit

	STDC_BASE
		rename
			security as base_security
		end

	NET_LOGGER_ROUTINES


create

	make


feature {NONE} -- Initialization

	make (a_handler: NET_LOGGER_LOG_HANDLER; a_program_name: READABLE_STRING_8)
		require
			handler_not_void: a_handler /= Void
			program_name_not_empty: a_program_name /= Void and then not a_program_name.is_empty
		do
			handler := a_handler
			--precursor (a_handler, a_program_name)
			set_level (levels.info)
			create date.make
			create event.make (names.event, Void)
			create host.make (names.host, handler.host_name)
			create program_name.make (names.prog, a_program_name)
			create lvl.make (levels.info)
			create line.make (128)
		end


feature -- Access

	level: INTEGER
			-- Everything lower or equal to this level will be logged

	levels: NET_LOGGER_LEVELS
			-- The available NetLogger levels
		once
			create Result
		end


feature -- NetLogger normal usage API

	set_level (a_new_level: INTEGER)
			-- Change the level at which logging will occur.
		require
			new_level_valid: a_new_level = 0 or else levels.is_valid_level (a_new_level)
		do
			level := a_new_level
		ensure
			level_set: level = a_new_level
		end

	write (a_level: INTEGER; an_event_name: STRING; an_event_attributes: detachable DS_LINEAR [NET_LOGGER_FIELD])
			-- Write an event if `a_level' >= `level'.
		require
			valid_level: levels.is_valid_level (a_level)
		do
			if a_level <= level then
				reset_line
				date.refresh
				event.set_value (an_event_name)
				lvl.set_level (a_level)
				default_fields_to_line
				flatten_fields_to_line (an_event_attributes)
				handler.log_event (a_level, line)
			end
		end

	write_msg (a_level: INTEGER; an_event_name: STRING; a_msg: detachable STRING)
			-- Write one event if `a_level' >= `level'.
		require
			valid_level: levels.is_valid_level (a_level)
			event_name_not_empty: an_event_name /= Void and then not an_event_name.is_empty
			msg_valid: attached a_msg as m implies is_valid_value (m)
		local
			list: DS_LINKED_LIST [NET_LOGGER_FIELD]
		do
			if a_level <= level then
				if not attached a_msg as m or else m.is_empty then
					write (a_level, an_event_name, Void)
				else
					create list.make
					list.put_last (create {NET_LOGGER_FIELD}.make (names.msg, m))
					write (a_level, an_event_name, list)
				end
			end
		end


feature -- Reserved field names

	names: NET_LOGGER_RESERVED_NAMES
		once
			create Result
		ensure
			not_void: Result /= Void
		end


feature {NONE} -- Correct field list generation

	date: NET_LOGGER_TS_FIELD
			-- Default date field.

	event: NET_LOGGER_FIELD
			-- Default event field

	host: NET_LOGGER_FIELD
			-- Default host host field

	program_name: NET_LOGGER_FIELD
			-- Default prog field

	lvl: NET_LOGGER_LEVEL_FIELD
			-- Default level field

	line: STRING
			-- Buffer written to by `flatten_fields'.

	default_fields_to_line
			-- Write the default fields to `line'. Assumes all values in
			-- the default fields have been set.
		require
			line_not_void: line /= Void
		do
			-- We're assuming the name of the program is used as
			-- identification so we don't need to write this
			--append_field (program_name)
			--append_separator

			append_field (event)
			append_separator

			append_field (date)
			append_separator

			append_field (lvl)
			append_separator

			append_field (host)
		ensure
			line_not_empty: not line.is_empty
		end

	flatten_fields_to_line (a_fields: detachable DS_LINEAR [NET_LOGGER_FIELD])
			-- Append `fields' to `line'.
		do
			if a_fields /= Void then
				from
					a_fields.start
				until
					a_fields.after
				loop
					append_separator
					append_field (a_fields.item_for_iteration)
					a_fields.forth
				end
			end
		ensure
			line_not_empty: not line.is_empty
		end

	append_field (f: NET_LOGGER_FIELD)
			-- Append `f' in the correct format to `line'.
		require
			field_not_void: f /= Void
			line_not_void: line /= Void
		local
			quote: BOOLEAN
		do
			line.append_string (f.name)
			line.append_character ('=')
			if attached f.value and then not f.value.is_empty then
				quote := f.value.has (' ')
				if quote then
					line.append_character ('"')
				end
				if f.value.has ('"') then
					line.append_string (escape_quote (f.value))
				else
					line.append_string (f.value)
				end
				if quote then
					line.append_character ('"')
				end
			end
		ensure
			line_greater: line.count >= old line.count + f.name.count + 1
		end

	append_separator
			-- Append separator to `line'
		require
			line_not_void: line /= Void
		do
			line.append_character (' ')
		end

	escape_quote (a_value: STRING): STRING
			-- `a_value' with every double quote preceded by a '\'
		require
			value_not_void: a_value /= Void
		local
			i: INTEGER
		do
			Result := a_value.twin
			from
				i := 1
			until
				i > Result.count
			loop
				if Result.item (i) = '"' then
					Result.insert_character ('\', i)
					i := i + 2
				else
					i := i + 1
				end
			end
		ensure
			result_not_void: Result /= Void
		end

	reset_line
			-- Assert `line' has enough capacity
		do
			line.wipe_out
		ensure
			line_not_void: line /= Void
		end


feature {NONE} -- Implementation

	handler: NET_LOGGER_LOG_HANDLER
			-- Actual OS dependent log writer


invariant

	logging_valid_level: level = 0 or else levels.is_valid_level (level)

	handler_not_void: handler /= Void

	date_not_void: date /= Void
	event_not_void: event /= Void
	host_not_void: host /= Void
	program_name_not_void: program_name /= Void
	lvl_not_void: lvl /= Void

end
