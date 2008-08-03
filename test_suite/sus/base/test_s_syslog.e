indexing

	description: "Test the syslog facilities."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	TEST_S_SYSLOG

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	SUS_CONSTANTS

	SUS_SYSLOG_ACCESSOR


feature

	test_all is
		do
			syslog.open ("test", LOG_ODELAY + LOG_PID, LOG_USER)

			syslog.debug_dump ("debug")
			syslog.info ("info")
			syslog.notice ("notice")
			syslog.warning ("warning")
			syslog.error ("error")

			syslog.close
		end

end
