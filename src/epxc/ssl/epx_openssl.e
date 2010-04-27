indexing

	description: "Class that uses the openssl command-line tool to open a generic SSL/TLS connection to a server. It also implements the EPX_TEXT_IO_STREAM, so it can be used as a bidirectional socket instead of a network socket."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

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

	make_ssl3 (a_host: STRING; a_port: INTEGER) is
		obsolete "2004-03-13: use make_ssl3_client instead."
		do
			make_ssl3_client (a_host, a_port)
		end

	make_ssl3_client (a_host: STRING; a_port: INTEGER) is
			-- Use SSLv3 to connect to `a_host' at `a_port'.
		require
			host_not_empty: a_host /= Void and then not a_host.is_empty
			valid_port: a_port >= 0 and then a_port <= 65535
			openssl_program_exists: True -- I hope
		do
			-- Need to redirect stderr to /dev/null perhaps?
			-- Anyway, you will see connection errors/problems now
			make_capture_io (openssl, <<"s_client", "-quiet", "-ssl3", "-connect", a_host + ":" + a_port.out>>)
			host := a_host
			port := a_port
		end


feature -- Status

	is_streaming: BOOLEAN is
			-- Is data coming through a network stream?
		do
			Result := fd_stdout.is_streaming
		end


feature -- Access

	host: STRING
			-- Host to connect to

	name: STRING is
		do
			Result := host + ":" + port.out
		end

	port: INTEGER
			-- Port to connect to


feature -- Reading/writing commands

	close is
		do
			fd_stdin.close
			fd_stdout.close
			wait_for (True)
		end

	flush is
		do
			fd_stdin.flush
		end

	put_buffer, write_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER) is
		do
			fd_stdin.put_buffer (buf, offset, nbytes)
		end

	put_character (v: CHARACTER) is
		do
			fd_stdin.put_character (v)
		end

	put_string (a_string: STRING) is
		do
			fd_stdin.put_string (a_string)
		end

	read is
		do
			fd_stdout.read_character
		end

	read_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER) is
			-- Read data into `buf' at `offset' for `nbytes' bytes.
			-- Number of bytes actually read are available in `last_read'.
		do
			fd_stdout.read_buffer (buf, offset, nbytes)
			debug ("dump-input")
				if dump_input /= Void and then not end_of_input then
					dump_input.put_buffer (buf, offset, last_read)
				end
			end
		end

	read_character is
		do
			fd_stdout.read_character
			debug ("dump-input")
				if dump_input /= Void and then not end_of_input then
					dump_input.put_character (last_character)
				end
			end
		end

	read_line is
		do
			fd_stdout.read_line
			debug ("dump-input")
				if dump_input /= Void and then not end_of_input then
					dump_input.put_line (last_string)
				end
			end
		end

	read_new_line is
			-- Read a line separator from input file.
			-- Make the characters making up the recognized
			-- line separator available in `last_string',
			-- or make `last_string' empty and leave the
			-- input file unchanged if no line separator
			-- was found.
		do
			fd_stdout.read_new_line
		end

	read_string (nb: INTEGER) is
		do
			fd_stdout.read_string (nb)
		end


feature {NONE} -- Unreading

	unread_character (an_item: CHARACTER) is
		do
			-- not supported
		end


feature -- Reading/writing access

	end_of_input: BOOLEAN is
		do
			Result := fd_stdout.end_of_input
		end

	last_character: CHARACTER is
		do
			Result := fd_stdout.last_character
		end

	last_read: INTEGER is
			-- Last bytes read by `read_buffer';
			-- Can be less than requested for non-blocking input.
			-- Check `last_blocked' in that case.
		do
			Result := fd_stdout.last_read
		end

	last_string: STRING is
			-- Last string read;
			-- (Note: this query always return the same object.
			-- Therefore a clone should be used if the result
			-- is to be kept beyond the next call to this feature.
			-- However `last_string' is not shared between file objects.)
		do
			Result := fd_stdout.last_string
		end

	last_written: INTEGER is
			-- How many bytes were written by the last call to a routine;
			-- Can be less than requested for non-blocking output.
			-- Check `last_blocked' in that case.
		do
			Result := fd_stdin.last_written
		end

	is_open: BOOLEAN is
		do
			Result := not is_terminated
		end

	is_open_read: BOOLEAN is
		do
			Result := fd_stdout /= Void and then fd_stdout.is_open_read
		end

	is_open_write: BOOLEAN is
		do
			Result := fd_stdin /= Void and then fd_stdin.is_open_write
		end

	is_owner: BOOLEAN is True


feature {NONE} -- Implementation

	openssl: STRING is "openssl"
			-- Path to the openssl program


end
