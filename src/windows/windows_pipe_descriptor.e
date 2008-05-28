indexing

	description: "Class that covers a client or server end of a Windows pipe."

	todo: "Not sure if all creation routines are applicable."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	WINDOWS_PIPE_DESCRIPTOR


inherit

	WINDOWS_FILE_DESCRIPTOR
		redefine
			is_blocking_io,
			set_blocking_io,
			supports_nonblocking_io
		end


create

	open,
	open_read,
	open_write,
	open_read_write,
	open_truncate,
	create_read_write,
	create_write,
	create_with_mode,
	make_as_duplicate,
	attach_to_fd


feature -- non-blocking i/o

	is_blocking_io: BOOLEAN is
			-- Is blocking i/o enabled?
			-- Blocking i/o is the default.
			-- If false, calls like `read' and `write' will never wait
			-- for input if there is no input.
		do
			safe_win_call (posix_getnamedpipehandlestate (fd, $state, default_pointer, default_pointer, default_pointer, default_pointer, 0))
			Result := not test_bits (state, PIPE_NOWAIT)
		end

	set_blocking_io (enable: BOOLEAN) is
			-- Set `is_blocking_io'.
		local
			b: BOOLEAN
		do
			b := is_blocking_io
			if enable then
				mode := PIPE_WAIT
			else
				mode := PIPE_NOWAIT
			end
			safe_win_call (posix_setnamedpipehandlestate (fd, $mode, default_pointer, default_pointer))
		end

	supports_nonblocking_io: BOOLEAN is True
			-- Windows pipes support non-blocking i/o.


feature {NONE} -- Implementation

	state,
	mode: INTEGER
			-- Non-local variables needed for $ operator in SmartEiffel.

end
