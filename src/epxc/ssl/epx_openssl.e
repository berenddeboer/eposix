note

	description: "Class that uses the openssl command-line tool to open a generic SSL/TLS connection to a server. It also implements the EPX_TEXT_IO_STREAM, so it can be used as a bidirectional socket instead of a network socket."

	author: "Berend de Boer"


class

	EPX_OPENSSL


inherit

	EPX_EXEC_PROCESS
		rename
			make as make_process
		end

	EPX_TEXT_IO_STREAM
		undefine
			raise_posix_error
		end


create

	make_ssl3_client


feature {NONE} -- Initialization.

	make_ssl3_client (a_host: STRING; a_port: INTEGER)
			-- Use tls 1.1 or higher to connect to `a_host' at `a_port'.
		require
			host_not_empty: a_host /= Void and then not a_host.is_empty
			valid_port: a_port >= 0 and then a_port <= 65535
			openssl_program_exists: True -- I hope
		do
			-- Need to redirect stderr to /dev/null perhaps?
			-- Anyway, you will see connection errors/problems now
			make_capture_io (openssl, <<"s_client", "-quiet", "-no_ssl2", "-no_ssl3", "-no_tls1", "-connect", a_host + ":" + a_port.out>>)
			host := a_host
			port := a_port
		end


feature -- Status

	is_streaming: BOOLEAN
			-- Is data coming through a network stream?
		do
			if attached fd_stdout as a_fd_stdout then
				Result := a_fd_stdout.is_streaming
			end
		end


feature -- Access

	host: STRING
			-- Host to connect to

	name: STRING
		do
			Result := host + ":" + port.out
		end

	port: INTEGER
			-- Port to connect to


feature -- Reading/writing commands

	close
		do
			if attached fd_stdin as a_fd_stdin then
				a_fd_stdin.close
			end
			if attached fd_stdout as a_fd_stdout then
				a_fd_stdout.close
			end
			wait_for (True)
		end

	flush
		do
			if attached fd_stdin as a_fd_stdin then
				a_fd_stdin.flush
			end
		end

	put_buffer, write_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER)
		do
			if attached fd_stdin as a_fd_stdin then
				a_fd_stdin.put_buffer (buf, offset, nbytes)
			end
		end

	put_character (v: CHARACTER)
		do
			if attached fd_stdin as a_fd_stdin then
				a_fd_stdin.put_character (v)
			end
		end

	put_string (a_string: STRING)
		do
			if attached fd_stdin as a_fd_stdin then
				a_fd_stdin.put_string (a_string)
			end
		end

	read
		do
			if attached fd_stdout as a_fd_stdout then
				a_fd_stdout.read_character
			end
		end

	read_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER)
			-- Read data into `buf' at `offset' for `nbytes' bytes.
			-- Number of bytes actually read are available in `last_read'.
		do
			if attached fd_stdout as a_fd_stdout then
				a_fd_stdout.read_buffer (buf, offset, nbytes)
			end
		end

	read_character
		do
			if attached fd_stdout as a_fd_stdout then
				a_fd_stdout.read_character
			end
		end

	read_line
		do
			if attached fd_stdout as a_fd_stdout then
				a_fd_stdout.read_line
			end
		end

	read_new_line
			-- Read a line separator from input file.
			-- Make the characters making up the recognized
			-- line separator available in `last_string',
			-- or make `last_string' empty and leave the
			-- input file unchanged if no line separator
			-- was found.
		do
			if attached fd_stdout as a_fd_stdout then
				a_fd_stdout.read_new_line
			end
		end

	read_string (nb: INTEGER)
		do
			if attached fd_stdout as a_fd_stdout then
				a_fd_stdout.read_string (nb)
			end
		end


feature {NONE} -- Unreading

	unread_character (an_item: CHARACTER)
		do
			-- not supported
		end


feature -- Reading/writing access

	end_of_input: BOOLEAN
		do
			if attached fd_stdout as a_fd_stdout then
				Result := a_fd_stdout.end_of_input
			end
		end

	last_character: CHARACTER
		do
			if attached fd_stdout as a_fd_stdout then
				Result := a_fd_stdout.last_character
			end
		end

	last_read: INTEGER
			-- Last bytes read by `read_buffer';
			-- Can be less than requested for non-blocking input.
			-- Check `last_blocked' in that case.
		do
			if attached fd_stdout as a_fd_stdout then
				Result := a_fd_stdout.last_read
			end
		end

	last_string: STRING
			-- Last string read;
			-- (Note: this query always return the same object.
			-- Therefore a clone should be used if the result
			-- is to be kept beyond the next call to this feature.
			-- However `last_string' is not shared between file objects.)
		do
			if attached fd_stdout as a_fd_stdout then
				Result := a_fd_stdout.last_string
			else
				Result := ""
			end
		end

	last_written: INTEGER
			-- How many bytes were written by the last call to a routine;
			-- Can be less than requested for non-blocking output.
			-- Check `last_blocked' in that case.
		do
			if attached fd_stdin as a_fd_stdin then
				Result := a_fd_stdin.last_written
			end
		end

	is_open: BOOLEAN
		do
			Result := not is_terminated
		end

	is_open_read: BOOLEAN
		do
			Result := not is_terminated and then attached fd_stdout as a_fd_stdout and then a_fd_stdout.is_open_read
		end

	is_open_write: BOOLEAN
		do
			Result := not is_terminated and then attached fd_stdin as a_fd_stdin and then a_fd_stdin.is_open_write
		end

	is_owner: BOOLEAN = True


feature {NONE} -- Implementation

	openssl: STRING = "openssl"
			-- Path to the openssl program


end
