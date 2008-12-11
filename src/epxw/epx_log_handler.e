indexing

	description: "Class that implements NetLogger logging on top of NT event log."

	notes:
		"If you don't want the message in the NT Event Log that %
		%'The description for Event ID ( ... ) in Source ( ... ) cannot be%
		%found....' I suggest you register the event source you passed to%
		%`make'. You can use the supplied messages.dll."

	author: "Berend de Boer"


class

	EPX_LOG_HANDLER


inherit

	NET_LOGGER_LOG_HANDLER

	WINDOWS_SYSTEM
		rename
			security as base_security,
			node_name as host_name
		export
			{NONE} all;
			{ANY} host_name
		end

	MEMORY
		export
			{NONE} all
		redefine
			dispose
		end


create

	make


feature -- Initialization

	make (a_source_name: STRING) is
			-- Source name must be a subkey of a logfile entry under the
			-- EventLog key in the registry.
		require
			valid_source_name:
				a_source_name /= Void and then
				not a_source_name.is_empty
		do
			handle := posix_registereventsource (default_pointer, sh.string_to_pointer (a_source_name))
			sh.unfreeze_all
			create my_lpStrings.make (0, 0)
		end


feature -- Logging

	log_event (level: INTEGER; line: STRING) is
			-- Write a single event with `fields' to the host logging system.
			-- It is somewhat unclear how authentication and security
			-- events are to be logged.
		do
			inspect level
			when fatal then do_log_event (EVENTLOG_ERROR_TYPE, level, line)
			when error then do_log_event (EVENTLOG_ERROR_TYPE, level, line)
			when warning then do_log_event (EVENTLOG_WARNING_TYPE, level, line)
			when info then do_log_event (EVENTLOG_INFORMATION_TYPE, level, line)
			when debug0..trace then do_log_event (EVENTLOG_INFORMATION_TYPE, level, line)
			end
		end


feature {NONE} -- NT logging

	category: INTEGER is 0

	do_log_event (event_type: INTEGER; level: INTEGER; line: STRING) is
			-- Log event to NT event log, truncate `line' if necessary.
		require
			valid_level: is_valid_level (level)
			line_not_void: line /= Void
		local
			short_line: STRING
		do
			if line.count > maximum_insertion_string_size then
				short_line := line.substring (1, maximum_insertion_string_size)
			else
				short_line := line
			end
			my_lpStrings.put (sh.string_to_pointer (short_line), my_lpStrings.lower)
			safe_win_call (posix_reportevent (
				handle,
				event_type,
				category,
				map_level_to_event_id (level),
				default_pointer,
				1,
				0,
				ah.pointer_array_to_pointer (my_lpStrings),
				default_pointer))
			ah.unfreeze_all
			sh.unfreeze_all
		end

	maximum_insertion_string_size: INTEGER is 32766
			-- 32KB - 2 is the best that works.

	my_lpStrings: ARRAY [POINTER]
			-- Cache for string.


feature {NONE} -- The event ids which we log

	event_id_emergency: INTEGER is -1073741823
			-- 0xC0000001L

	event_id_alert: INTEGER is -1073741822
			-- 0xC0000002L

	event_id_error: INTEGER is -1073741821
			-- 0xC0000003L

	event_id_warning: INTEGER is -2147483644
			-- 0x80000004L

	event_id_authentication: INTEGER is 1073741829
			-- 0x40000005L

	event_id_security: INTEGER is -2147483642
			-- 0x80000006L

	event_id_usage: INTEGER is 1073741831
			-- 0x40000007L

	event_id_system_usage: INTEGER is 8
			-- 0x00000008L

	event_id_important: INTEGER is 1073741833
			-- 0x40000009L

	event_id_debugging: INTEGER is 1073741840
			-- 0x40000010L

	event_ids: ARRAY [INTEGER] is
		once
			create Result.make (fatal, trace)
			Result.put (event_id_emergency, fatal)
			Result.put (event_id_error, error)
			Result.put (event_id_warning, warning)
			Result.put (event_id_usage, info)
			Result.put (event_id_debugging, debug0)
			Result.put (event_id_debugging, debug1)
			Result.put (event_id_debugging, debug2)
			Result.put (event_id_debugging, debug3)
			Result.put (event_id_debugging, debug4)
			Result.put (event_id_debugging, trace)
		ensure
			valid_bounds:
				is_valid_level (Result.lower) and
				is_valid_level (Result.upper)
		end

	map_level_to_event_id (level: INTEGER): INTEGER is
		require
			valid_level: is_valid_level (level)
		do
			Result := event_ids.item (level)
		end


feature {NONE} -- Private state

	handle: INTEGER
			-- Handle to opened event log.


feature {NONE} -- Shutdown

	dispose is
		local
			success: BOOLEAN
		do
			if handle /= 0 then
				success := posix_deregistereventsource (handle)
				handle := 0
			end
			precursor
		end


invariant

	event_log_opened: handle /= 0
	my_lpStrings_has_at_least_one_item: my_lpStrings /= Void and then my_lpStrings.count >= 1

end
