indexing

	description: "Class that covers the Single Unix Specification syslog API."

	usage: "Inherit from SUS_SYSLOG_ACCESSOR to access this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

class

	SUS_SYSLOG


inherit

	EPX_SINGLETON

	SUS_BASE

	SAPI_SYSLOG

	MEMORY
		redefine
			dispose
		end


create {SUS_SYSLOG_ACCESSOR}

	make


feature {SUS_SYSLOG_ACCESSOR}

	make is
		do
			-- do nothing
		end


feature -- open and close

	open (a_identification: STRING; a_format, a_facility: INTEGER) is
			-- start logging with the given identification
		require
			valid_identification:
				a_identification /= Void and then
				not a_identification.is_empty
			closed: not is_open
		do
			identification := a_identification
			create identification_buffer.allocate_and_clear (identification.count + 1)
			identification_buffer.put_string (identification, 0, identification.count - 1)
			format := a_format
			facility := a_facility
			posix_openlog (identification_buffer.ptr, format, facility)
			is_open := True
		ensure
			opened: is_open
		end

	close is
			-- stop logging
		require
			opened: is_open
		do
			posix_closelog
			is_open := False
		ensure
			closed: not is_open
		end

feature {NONE} -- garbage collector

	dispose is
		do
			if is_open then
				close
			end
			precursor
		end


feature -- Write log messages, will auto-open if not is_open

	emergency (msg: STRING) is
			-- the system is unusable
		do
			posix_syslog (LOG_EMERG, sh.string_to_pointer (msg))
			sh.unfreeze_all
		end

	alert (msg: STRING) is
			-- action must be taken immediately
		do
			posix_syslog (LOG_ALERT, sh.string_to_pointer (msg))
			sh.unfreeze_all
		end

	critical (msg: STRING) is
			-- critical conditions
		do
			posix_syslog (LOG_CRIT, sh.string_to_pointer (msg))
			sh.unfreeze_all
		end

	error (msg: STRING) is
			-- error conditions
		do
			posix_syslog (LOG_ERR, sh.string_to_pointer (msg))
			sh.unfreeze_all
		end

	warning (msg: STRING) is
			-- warning conditions
		do
			posix_syslog (LOG_WARNING, sh.string_to_pointer (msg))
			sh.unfreeze_all
		end

	notice (msg: STRING) is
			-- normal but significant condition
		do
			posix_syslog (LOG_NOTICE, sh.string_to_pointer (msg))
			sh.unfreeze_all
		end

	info (msg: STRING) is
			-- informational
		do
			posix_syslog (LOG_INFO, sh.string_to_pointer (msg))
			sh.unfreeze_all
		end

	debug_dump (msg: STRING) is
			-- Debug-level messages.
		do
			posix_syslog (LOG_DEBUG, sh.string_to_pointer (msg))
			sh.unfreeze_all
		end


feature -- Access

	identification: STRING

	format,
	facility: INTEGER

	is_open: BOOLEAN


feature {NONE} -- Implementation

	identification_buffer: STDC_BUFFER

	frozen singleton: EPX_SINGLETON is
		once
			Result := Current
		end

invariant

	have_identification: is_open implies identification /= Void and then not identification.is_empty

end
