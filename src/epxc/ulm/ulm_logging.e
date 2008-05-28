indexing

	description: "Class that implements ULM logging, see url."

	url: "http://www.hsc.fr/gul/draft-abela-ulm-05.txt"

	known_bug: "Doesn't check format of fields, i.e. is it an integer when it should be."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

  ULM_LOGGING

obsolete

	"2007-12-24: Please use the new NET_LOGGER classes"

inherit

	STDC_BASE
		rename
			security as base_security
		end

	ULM_LOG_LEVELS

create

  make

feature {NONE} -- Initialization

	make (a_handler: ULM_LOG_HANDLER; a_program_name: STRING) is
			-- Start logging for `program'. The host name is derived from
			-- an OS specific call through `a_handler'.
		require
			handler_not_void: a_handler /= Void
			program_not_empty: a_program_name /= Void and then not a_program_name.is_empty
		do
			handler := a_handler
			create_my_date
			create my_host.make (HOST, handler.host_name)
			create my_prog.make (PROG, a_program_name)
			create my_qualified_prog.make (PROG, a_program_name)
			create my_lvl.make (Emergency)
		end

	create_my_date is
			-- Create the `my_date' field.
		do
			create {ULM_STDC_DATE_FIELD} my_date.make
		ensure
			my_date_is_set: my_date /= Void
		end

feature -- Log methods

	log_error (level: INTEGER; subsystem: STRING; error_number: INTEGER; error_message: STRING) is
			-- Useful for logging errors.
		require
			valid_level: is_valid_log_level (level)
		local
			fields: ARRAY [ULM_FIELD]
			field: ULM_FIELD
		do
			create fields.make (0, 1)
			create field.make (ID, error_number.out)
			fields.put (field, 0)
			if error_message = Void or else error_message.is_empty then
				create field.make (MSG, "No error message specified.")
			else
				create field.make (MSG, error_message)
			end
			fields.put (field, 1)
			log_event (level, subsystem, fields)
		end

	log_event (level: INTEGER; subsystem: STRING; fields: ARRAY [ULM_FIELD]) is
			-- Log event, consisting of one or more fields. It is the
			-- responsibility of the client to make sure the values are
			-- proper for each field.
			-- This function adds any ULM required field if not present.
			-- `subsystem', if present is appended with a dot to
			-- `program' and written in the "PROG" field.
			-- DATE is logged in GMT.
		require
			valid_level: is_valid_log_level (level)
			one_or_more_fields: fields /= Void and then fields.count >= 1
			valid_field_list: is_valid_partial_field_list (fields)
		do
			flatten_fields (level, subsystem, fields)
			handler.log_event (level, line)
		end

	log_single_field (level: INTEGER; subsystem, field_name, value: STRING) is
			-- Log `value' for `field_name'. `value' will be properly
			-- quoted if necessary. `value' should be in the proper
			-- format for `field_name'.
			-- This function adds any ULM required field.
			-- `subsystem', if present is appended with a dot to
			-- `program' and written in the "PROG" field.
			-- in the "PROG" field.
			-- DATE is logged in GMT.
		require
			valid_level: is_valid_log_level (level)
			field_name_is_valid: is_valid_field_name (field_name)
			value_not_empty: value /= Void and then not value.is_empty
		local
			fields: ARRAY [ULM_FIELD]
			field: ULM_FIELD
		do
			create fields.make (0, 0)
			create field.make (field_name, value)
			fields.put (field, 0)
			log_event (level, subsystem, fields)
		end

	log_message (level: INTEGER; subsystem, value: STRING) is
			-- Log a simple message with the MSG field.
			-- This function adds any ULM required field.
			-- `subsystem', if present is appended with a dot to
			-- `program' and written in the "PROG" field.
			-- DATE is logged in GMT.
		require
			valid_level: is_valid_log_level (level)
			value_not_empty: value /= Void and then not value.is_empty
		do
			log_single_field (level, subsystem, MSG, value)
		end

feature -- Queries

	is_valid_field_name (field_name: STRING): BOOLEAN is
			-- Returns True if `field_name' is valid according to ULM spec.
			-- Basically it should consist of one or more letters and have
			-- no spaces.
		local
			i: INTEGER
			count: INTEGER
			c: CHARACTER
			state: INTEGER
		do
			Result := field_name /= Void and then not field_name.is_empty
			if Result then
				from
					i := 1
					count := field_name.count
					state := FN_Start
				until
					not Result or else
					i > count
				loop
					c := field_name.item (i)
					inspect c
					when 'A'..'Z','a'..'z' then
						state := FN_Next
					when '0'..'9', '-' then
						Result := state /= FN_Start
						state := FN_Next
					when '.' then
						Result := state = FN_Next
						state := FN_Dot
					else
						Result := False
					end
					i := i + 1
				end
				if Result then
					Result := state = FN_Next
				end
			end
		end

	is_valid_partial_field_list (fields: ARRAY [ULM_FIELD]): BOOLEAN is
			-- Contains True if `fields' contains at least one item, and
			-- if every item in `fields' is not Void and if `fields'does
			-- not contain a duplicate field and if `fields' does not
			-- contain the LVL field.
		require
			have_fields: fields /= Void
		local
			i: INTEGER
			f: ULM_FIELD
		do
			Result := fields.count >= 1
			if Result then
				from
					i := fields.lower
				until
					not Result or else
					i > fields.upper
				loop
					f := fields.item (i)
					Result := f /= Void
					if Result then
						Result := not do_find_field (f.name, fields, i)
					end
					i := i + 1
				end
			end
		end


feature {NONE} -- Field name checking

	FN_Start,
	FN_Next,
	FN_Dot: INTEGER is UNIQUE

feature {NONE} -- Correct field list generation

	line: STRING
			-- Buffer written to by `flatten_fields'.

	found_index: INTEGER
			-- Index as returned by `find_field'.

	found_field: ULM_FIELD
			-- Last field found by `find_field' or Void.

	my_date: ULM_DATE_FIELD
			-- Default DATE field.

	my_host: ULM_FIELD
			-- Default HOST host field

	my_prog: ULM_FIELD
			-- Default PROG field

	my_qualified_prog: ULM_FIELD
			-- Used when subsystem is given.

	my_lvl: ULM_LVL_FIELD
			-- Default LVL field

	flatten_fields (level: INTEGER; subsystem: STRING; fields: ARRAY [ULM_FIELD]) is
			-- Makes sure `line' contains all required fields, and
			-- all other fields present in `fields'. If `fields' does not
			-- contain a require field, a default is added.
			-- All fields in `line' are correctly sorted.
		require
			valid_level: is_valid_log_level (level)
			valid_field_list: is_valid_partial_field_list (fields)
		local
			i, j: INTEGER
			the_date_field,
			the_host_field,
			the_prog_field: ULM_FIELD
			field: ULM_FIELD
		do
			-- assert `line' has enough capacity
			if line = Void then
				create line.make (128)
			else
				line.wipe_out
			end

			-- add required fields in correct order
			-- DATE
			if find_field (DATE, fields) then
				the_date_field := found_field
			else
				my_date.refresh
				the_date_field := my_date
			end
			append_field (the_date_field)
			append_separator
			-- HOST
			if find_field (HOST, fields) then
				the_host_field := found_field
			else
				the_host_field := my_host
			end
			append_field (the_host_field)
			append_separator
			-- PROG
			if find_field (PROG, fields) then
				the_prog_field := found_field
			else
				if subsystem = Void or else subsystem.is_empty then
					the_prog_field := my_prog
				else
					my_qualified_prog.set_value (my_prog.value + once "." + subsystem)
					the_prog_field := my_qualified_prog
				end
			end
			append_field (the_prog_field)
			append_separator
			-- LVL
			my_lvl.set_level (level)
			append_field (my_lvl)

			-- copy other fields
			from
				i := fields.lower
				j := 4
			until
				i > fields.upper
			loop
				field := fields.item (i)
				if
					field /= the_date_field and then
					field /= the_host_field and then
					field /= the_prog_field then
					append_separator
					append_field (field)
					j := j + 1
				end
				i := i + 1
			end
		ensure
			line_not_empty: not line.is_empty
		end

	append_field (f: ULM_FIELD) is
			-- Append `f' in the correct format to `line'
		require
			field_not_void: f /= Void
			line_not_void: line /= Void
		do
			line.append_string (f.name)
			line.append_character ('=')
			if is_alphaext (f.value) then
				line.append_string (f.value)
			else
				line.append_character ('"')
				line.append_string (make_string (f.value))
				line.append_character ('"')
			end
		ensure
			line_greater: line.count >= old line.count + f.name.count + 1 + f.value.count
		end

	append_separator is
			-- Append separator to `line'
		require
			line_not_void: line /= Void
		do
			line.append_character (' ')
		end

	find_field (field_name: STRING; fields: ARRAY [ULM_FIELD]): BOOLEAN is
			-- Return True if `fields' contains a field `field_name'.
			-- If True, set found_field.
		require
			field_name_not_empty: field_name /= Void and then not field_name.is_empty
			fields_not_void: fields /= Void
		do
			Result := do_find_field (field_name, fields, fields.lower - 1)
		ensure
			found_field_set: Result = (found_field /= Void)
			found_field_and_index_consistent: Result implies (fields.item (found_index) = found_field)
			found_index_set: Result = (found_index >= fields.lower and found_index <= fields.upper)
		end

	do_find_field (field_name: STRING; fields: ARRAY [ULM_FIELD]; skip_index: INTEGER): BOOLEAN is
			-- Return True if `fields' contains a field `field_name' in
			-- another position than `skip_index'.
			-- If True, set found_field.
		require
			field_name_not_empty: field_name /= Void and then not field_name.is_empty
			fields_not_void: fields /= Void
		local
			i: INTEGER
		do
			from
				i := fields.lower
			until
				Result or else
				i > fields.upper
			loop
				if i /= skip_index then
					found_field := fields.item (i)
					if found_field /= Void then
						Result := found_field.name.is_equal (field_name)
					end
				end
				i := i + 1
			end
			if Result then
				found_index := i - 1
			else
				found_field := Void
				found_index := fields.lower - 1
			end
		ensure
			found_field_set: Result = (found_field /= Void)
			found_index_set: Result = (found_index >= fields.lower and found_index <= fields.upper)
			found_field_and_index_consistent: Result implies (fields.item (found_index) = found_field)
			found_index_not_skip_index: Result implies (found_index /= skip_index)
		end

	is_alphaext (value: STRING): BOOLEAN is
			-- Is `value' an ALPHAEXT according to the ULM spec?
		require
			value_not_void: value /= Void
		local
			i: INTEGER
			c: CHARACTER
		do
			from
				Result := True
				i := 1
			until
				not Result or else
				i > value.count
			loop
				c := value.item (i)
				inspect c
				when 'a'..'z', 'A'..'Z', '0'..'9', '.', '-' then
					Result := True
				else
					Result := False
				end
				i := i + 1
			end
		end

	make_string (value: STRING): STRING is
			-- Return `value' properly quoted. Return value does not
			-- include the quotes it self.
		require
			value_not_void: value /= Void
		local
			i: INTEGER
			c: CHARACTER
		do
			Result := clone (value)
			from
				i := 1
			until
				i > Result.count
			loop
				c := Result.item (i)
				inspect c
				when '\', '"' then
					Result.insert_character ('\', i)
					i := i + 2
				else
					i := i + 1
				end
			end
		ensure
			result_not_void: Result /= Void
		end


feature -- Standard field names

	LVL: STRING is
			-- Importance and category of the ULM.
		do
			Result :=  "LVL"
		end

	HOST: STRING is
			-- Name of software component which issues the ULM
		do
			Result := "HOST"
		end

	PROG: STRING is
			-- Name of the software component which issued the ULM
		do
			Result := "PROG"
		end

	DATE: STRING is
			-- Instantaneous date of the event
		do
			Result := "DATE"
		end

	LANG: STRING is "LANG"
			-- Language used for text fields. Default is english (EN).

	DUR: STRING is "DUR"
			-- Indicates duration (in seconds) of the event.

	PS: STRING is "PS"
			-- Process id which issued the ULM.

	ID: STRING is "ID"
			-- System reference to the concerned document.

	SRC_IP: STRING is "SRC.IP"
			-- The IP number of the source host.

	SRC_FQDN: STRING is "SRC.FDQN"
			-- Fully qualified Domain Name for the source host.

	SRC_NAME: STRING is "SRC.NAME"
			-- Generic name qualifying the source.

	SRC_PORT: STRING is "SRC.PORT"
			-- Port number for TCP, UDP or other protocol.

	SRC_USR: STRING is "SRC.USR"
			-- User name or user id.

	SRC_MAIL: STRING is "SRC.MAIL"
			-- Email address.

	DST_IP: STRING is "DST.IP"
			-- The IP number of the destination host.

	DST_FQDN: STRING is "DST.FDQN"
			-- Fully qualified Domain Name for the destination host.

	DST_NAME: STRING is "DST.NAME"
			-- Generic name qualifying the destination.

	DST_PORT: STRING is "DST.PORT"
			-- Port number for TCP, UDP or other protocol.

	DST_USR: STRING is "DST.USR"
			-- User name or user id.

	DST_MAIL: STRING is "DST.MAIL"
			-- Email address.

	REL_IP: STRING is "REL.IP"
			-- The IP number of the proxy/relayer host.

	REL_FQDN: STRING is "REL.FDQN"
			-- Fully qualified Domain Name for the proxy/relayer host.

	REL_NAME: STRING is "REL.NAME"
			-- Generic name qualifying the proxy/relayer.

	REL_PORT: STRING is "REL.PORT"
			-- Port number for TCP, UDP or other protocol.

	REL_USR: STRING is "REL.USR"
			-- User name or user id.

	REL_MAIL: STRING is "REL.MAIL"
			-- Email address.

	VOL: STRING is "VOL"
			-- Volume (number of bytes) sent and received from the source
			-- point of view.

	VOL_SENT: STRING is "VOL.SENT"
			-- Volume (number of bytes) sent from the source point of view.

	VOL_RCVD: STRING is "VOL.RCVD"
			-- Volume (number of bytes) received from the source point of view.

	CNT: STRING is "CNT"
			-- Count (of articles, files, events) sent and received from
			-- the source point of view.

	CNT_SENT: STRING is "CNT.SENT"
			-- Count (of articles, files, events) sent from the source
			-- point of view.

	CNT_RCVD: STRING is "CNT.RCVD"
			-- Count (of articles, files, events) received from the
			-- source point of view.

	PROG_FILE: STRING is "PROG.FILE"
			-- Name of the program source file from which the ULM was generated.

	STAT: STRING is "STAT"
			-- State or status of the designed process. Possible values
			-- for this field may include "Failure", "Success", "Start",
			-- "End".

	TTY: STRING is "TTY"
			-- User's physical connection to the host.

	DOC: STRING is "DOC"
			-- Name of accessed document like the path of an ftp file,
			-- the name of a newsgroup, or the non-host part of an URL.

	PROT: STRING is "PROT"
			-- Protocol used.

	CMD: STRING is "CMD"
			-- Issued command.

	MSG: STRING is
			-- The only field which should contain arbitrary data
		do
			Result := "MSG"
		end


feature -- Public state

	host_name: STRING is
			-- Name of the host which issues the ULM.
		do
			Result := my_host.value
		end

	program_name: STRING is
			-- Name of the software component which issues the ULM.
		do
			Result := my_prog.value
		end


feature {NONE} -- Internal

	handler: ULM_LOG_HANDLER
			-- Actual OS dependent log writer.

invariant

	handler_not_void: handler /= Void
	host_name_not_empty: host /= Void and then not host.is_empty
	program_name_not_empty: program_name/= Void and then not program_name.is_empty

	have_my_date: my_date /= Void
	have_my_host: my_host /= Void
	have_my_prog: my_prog /= Void
	have_my_lvl: my_lvl /= Void

end
