indexing

	description: "Class that implements ULM logging on top of syslog."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #1 $"


class

	EPX_LOG_HANDLER

inherit

	ULM_LOG_HANDLER

	SUS_SYSLOG_ACCESSOR

	SUS_SYSTEM
		rename
			security as base_security
		end

creation

	make

feature -- Initialization

	make (a_identification: STRING) is
			-- If syslog isn't open, `a_identification' will be used to open it.
		require
			valid_identification:
				a_identification /= Void and then
				not a_identification.is_empty
		do
			if not syslog.is_open then
				syslog.open (a_identification, LOG_ODELAY, LOG_LOCAL3)
			end
		end

feature -- Logging

	log_event (level: INTEGER; line: STRING) is
			-- Write a single event with `fields' to the host logging system.
			-- It is somewhat unclear how authentication and security
			-- events are to be logged.
		do
			inspect level
			when Emergency then syslog.emergency (line)
			when Alert then syslog.alert (line)
			when Error then syslog.alert (line)
			when Warning then syslog.warning (line)
			when Authentication then syslog.info (line)
			when Security then syslog.info (line)
			when Usage then syslog.info (line)
			when System_usage then syslog.info (line)
			when Important then syslog.notice (line)
			when Debugging then syslog.debug_dump (line)
			end
		end

end
