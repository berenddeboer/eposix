indexing

	description: "Class that covers the syslog.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	SAPI_SYSLOG


feature {NONE} -- C binding

	posix_openlog (ident: POINTER; option, facility: INTEGER) is
			-- Open connection to system logger.

		external "C blocking"



		end

	posix_syslog (priority: INTEGER; msg: POINTER) is
			-- Write `msg' to log.
		require
			msg_not_nil: msg /= default_pointer

		external "C blocking"



		end

	posix_closelog is
			-- Close desriptor used to write to system logger.

		external "C blocking"



		end


end
