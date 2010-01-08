indexing

	description: "Class that implements NetLogger logging on top of syslog."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007 - 2009, Berend de Boer"
	license: "MIT License"


class

	EPX_LOG_HANDLER


inherit

	NET_LOGGER_LOG_HANDLER

	SUS_SYSLOG_ACCESSOR
		export
			{NONE} all
		end

	EPX_CURRENT_PROCESS
		export
			{NONE} all
		end

	SUS_SYSTEM
		export
			{NONE} all
		end

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end


create

	make,
	make_default


feature -- Initialization

	make_default is
		local
			path: STDC_PATH
		do
			create path.make_from_string (Arguments.program_name)
			path.parse (Void)
			make (path.basename + "[" + pid.out + "]")
		end

	make (an_identification: STRING) is
			-- If syslog isn't open, `an_identification' will be used to open it.
		require
			valid_identification:
				an_identification /= Void and then
				not an_identification.is_empty
		do
			if not syslog.is_open then
				syslog.open (an_identification, LOG_ODELAY, LOG_LOCAL3)
			end
		end

feature -- Logging

	log_event (level: INTEGER; line: STRING) is
			-- Write a single event with `fields' to the host logging system.
			-- It is somewhat unclear how authentication and security
			-- events are to be logged.
		do
			inspect level
			when fatal then syslog.emergency (line)
			when error then syslog.error (line)
			when warning then syslog.warning (line)
			when info then syslog.info (line)
			when debug0..trace then syslog.debug_dump (line)
			end
		end

end
