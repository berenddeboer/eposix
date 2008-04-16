indexing

	description: "Class that implements NetLogger logging on top of syslog."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_LOG_HANDLER

inherit

	NET_LOGGER_LOG_HANDLER

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
			when fatal then syslog.emergency (line)
			when error then syslog.error (line)
			when warning then syslog.warning (line)
			when info then syslog.info (line)
			when debug0..trace then syslog.debug_dump (line)
			end
		end

end
