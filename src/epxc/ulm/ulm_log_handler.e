indexing

	description: "Class that can write ULM logging to an OS dependent%
	%logging mechanism."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	ULM_LOG_HANDLER

inherit

	ULM_LOG_LEVELS

feature -- Logging

	log_event (level: INTEGER; line: STRING) is
			-- Write a single line to the host logging system. `line'
			-- should be in ULM format.
		require
			valid_level: is_valid_log_level (level)
			line_not_empty: line /= Void and then not line.is_empty
		deferred
		end

feature -- OS queries needed by ULM_LOGGING

	host_name: STRING is
			-- Host name where system is running upon
		deferred
		ensure
			host_name_not_empty: Result /= Void and then not Result.is_empty
		end

end
