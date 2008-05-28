indexing

	description: "Access to the sendmail (or compatible) program and use it to send email."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	EPX_SENDMAIL


inherit

	POSIX_EXEC_PROCESS
		rename
			make as make_process
		redefine
			make_from_command_line
		end

	EPX_FACTORY
		export
			{NONE} all
		end


create

	make,
	make_from_command_line,
	make_use_path,
	make_with_path


feature {NONE} -- Initialization

	make is
			-- Set `sendmail' to the location of the sendmail binary by
			-- looking in a few well-defined places. For security reasons
			-- we don't use the PATH.
			-- Raises an exception if sendmail is not found.
		local
			sendmail: STRING
		do
			sendmail := fs.find_program_in_path ("sendmail", <<"/usr/sbin", "/usr/bin", "/usr/local/sbin", "/usr/local/bin", "/usr/lib", "/usr/local/lib">>)
			if sendmail = Void then
				exceptions.raise ("sendmail not found")
			end
			make_capture_input (sendmail, sendmail_options)
			create message.make
		end


	make_use_path is
			-- Set `sendmail' to the location of the sendmail binary and
			-- assume the binary can be found in the PATH.
			-- @@BdB: does looking in PATH work??
		do
			make_capture_input ("sendmail", sendmail_options)
			create message.make
		end

	make_with_path (a_path: STRING) is
		require
			executable: fs.is_executable (a_path)
		do
			make_capture_input (a_path, sendmail_options)
			create message.make
		end

	make_from_command_line (a_command_line: STRING) is
			-- Give path and options to sendmail. Does not necessarily
			-- have to be the full path, will look in PATH otherwise.
			-- @@BdB: does looking in PATH work??
		do
			precursor (a_command_line)
			set_capture_input (True)
			create message.make
		end


feature -- Access

	message: EPX_MIME_EMAIL
			-- The message we're creating


feature -- Output

	send is
			-- Send `message; using `sendmail'
		require
			iput_captured: capture_input
			terminated: is_terminated
		do
			execute
			if not is_terminated then
				fd_stdin.put_string (message.as_string)
				fd_stdin.close
				wait_for (True)
			end
		ensure
			terminated: is_terminated
		end


feature {NONE} -- Implementation

	sendmail_options: ARRAY [STRING] is
			-- Default options to pass to sendmail. Must include -t and -i.
		once
			-- -i     When reading a message from standard  input,  don´t
			--        treat  a line with only a . character as the end of
			--        input.
			-- -t     Extract   recipients  from  message  headers.  This
			--        requires that no recipients  be  specified  on  the
			--        command line.
			Result := <<"-i", "-t">>
		end


invariant

	message_not_void: message /= Void
	stdin_of_sendmail_is_writable: capture_input

end
