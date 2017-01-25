note

	description: "Class that covers Posix terminal settings."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	POSIX_TERMIOS


inherit

	POSIX_BASE

	PAPI_TERMIOS


create

	make


feature {NONE} -- Initialize

	make (a_fd: POSIX_FILE_DESCRIPTOR)
		require
			file_descriptor_not_void: a_fd /= Void
			valid_file_descriptor: a_fd.is_attached_to_terminal
		do
			fd := a_fd
			create attr.allocate (posix_termios_size)
			refresh
		end


feature -- Access, raw individual fields

	iflag: INTEGER
			-- Input mode flags
		do
			Result := posix_termios_cflag (attr.ptr)
		end

	oflag: INTEGER
			-- output mode flags
		do
			Result := posix_termios_cflag (attr.ptr)
		end

	cflag: INTEGER
			-- control mode flags
		do
			Result := posix_termios_cflag (attr.ptr)
		end

	lflag: INTEGER
			-- local mode flags
		do
			Result := posix_termios_lflag (attr.ptr)
		end


feature -- More friendly settings

	is_input_echoed: BOOLEAN
			-- are input characters echoed back to the terminal?
		do
			Result := test_bits (lflag, ECHO)
		end

	is_receiving: BOOLEAN
			-- If false, no characters are received
		do
			Result := test_bits (cflag, CREAD)
		end

	set_echo_input (enable: BOOLEAN)
		do
			posix_set_termios_lflag (attr.ptr, flip_bits (lflag, ECHO, enable))
		end

	set_echo_new_line (enable: BOOLEAN)
		do
			posix_set_termios_lflag (attr.ptr, flip_bits (lflag, ECHONL, enable))
		end

	set_input_control (enable: BOOLEAN)
			-- enable start/stop input control
		do
			posix_set_termios_iflag (attr.ptr, flip_bits (iflag, IXOFF, enable))
		end

	set_receive (enable: BOOLEAN)
		do
			posix_set_termios_cflag (attr.ptr, flip_bits (cflag, CREAD, enable))
		end

feature -- line control functions

	flush_input
			-- Discards all data that has been received but not read.
		do
			safe_call (posix_tcflush (fd.value, TCIFLUSH))
		end

	drain
			-- Wait for all output to be transmitted to the terminal.
		do
			-- not yet implemented
		end

	send_break
			-- sends a break to the terminal
		do
			-- not yet implemented
		end


feature -- Get/set baudrates as symbols

	input_speed: INTEGER
			-- The terminal input baud rate as symbolic value.
		do
			Result := posix_cfgetispeed (attr.ptr)
		end

	output_speed: INTEGER
			-- The terminal output baud rate as symbolic value.
		do
			Result := posix_cfgetospeed (attr.ptr)
		end

	set_input_speed (new_rate: INTEGER)
			-- Set terminal input baud rate, `new_rate' is one of the
			-- BXXXX constants
		do
			safe_call (posix_cfsetispeed (attr.ptr, new_rate))
		end

	set_output_speed (new_rate: INTEGER)
			-- Set terminal output baud rate, `new_rate' is one of the
			-- BXXXX constants
		do
			safe_call (posix_cfsetospeed (attr.ptr, new_rate))
		end


feature -- symbol to baud rate conversions

	speed_to_baud_rate (symbol: INTEGER): INTEGER
			-- Given a baud rate symbol, the real baud rate is returned.
		do
			if symbol = B0 then
				Result := 0
			elseif symbol = B50 then
				Result := 50
			elseif symbol = B75 then
				Result := 75
			elseif symbol = B110 then
				Result := 110
			elseif symbol = B134 then
				Result := 134
			elseif symbol = B150 then
				Result := 150
			elseif symbol = B200 then
				Result := 200
			elseif symbol = B300 then
				Result := 300
			elseif symbol = B600 then
				Result := 600
			elseif symbol = B1200 then
				Result := 1200
			elseif symbol = B1800 then
				Result := 1800
			elseif symbol = B2400 then
				Result := 2400
			elseif symbol = B4800 then
				Result := 4800
			elseif symbol = B9600 then
				Result := 9600
			elseif symbol = B19200 then
				Result := 19200
			elseif symbol = B38400 then
				Result := 38400
			elseif symbol = B57600 then
				Result := 57600
			elseif symbol = B115200 then
				Result := 115200
			elseif symbol = B230400 then
				Result := 230400
			else
				-- unknown
				Result := 0
			end
		end

feature -- Apply/refresh state

	apply_now
			-- Change occurs immediately.
		do
			safe_call (posix_tcsetattr (fd.value, Tcsanow, attr.ptr))
			refresh
		end

	apply_drain
			-- Change occurs after all output written to `fd' has been
			-- transmitted. This function should be used when changing
			-- parameters that affect output.
		do
			safe_call (posix_tcsetattr (fd.value, Tcsadrain, attr.ptr))
			refresh
		end

	apply_flush
			-- Change occurs after all output written to `fd' has been
			-- transmitted. All input that has been received but not
			-- read, is discarded before the change is made.
		do
			safe_call (posix_tcsetattr (fd.value, Tcsaflush, attr.ptr))
			refresh
		end

	refresh
			-- Get terminal settings currently in effect.
		do
			-- tcdrain here?
			safe_call (posix_tcgetattr (fd.value, attr.ptr))
		end


feature -- Access

	fd: POSIX_FILE_DESCRIPTOR
			-- The file descriptor for these terminal settings.


feature {NONE} -- Implementation

	attr: STDC_BUFFER
			-- The terminal attributes.


invariant

	valid_attr: attr /= Void and then attr.capacity = posix_termios_size
	valid_fd: fd /= Void


end
