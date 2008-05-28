indexing

	description: "Class that makes it appear if Windows supports file %
	%descriptors. Windows doesn't. The few functions it has are not compatible%
	%with the rest of the system, therefore this class really is a wrapper%
	%for Windows HANDLE code.%
	%This is also why you can't switch from STDC_FILE to a %
	%EPX_FILE_DESCRIPTOR for example like you can with POSIX."

	bugs: "Basic calls raise exception, should be done by higher level calls."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	EPX_DESCRIPTOR


inherit

	ABSTRACT_DESCRIPTOR
		undefine
			raise_posix_error
		end

	WINDOWS_BASE

	WAPI_IO


create

	make,
	make_as_duplicate,
	attach_to_descriptor


feature {NONE} -- Abstract API binding

	abstract_close (fildes: INTEGER): INTEGER is
			-- Closes a a file descriptor.
		do
			if not posix_closehandle (fildes) then
				Result := -1
			end
		end

	abstract_dup (fildes: INTEGER): INTEGER is
			-- Duplicates an open file descriptor
		do
			safe_win_call (posix_duplicatehandle (posix_getcurrentprocess, fildes, posix_getcurrentprocess, $temp_int, 0, False, DUPLICATE_SAME_ACCESS))
			Result := temp_int
		end

	abstract_dup2 (fildes, fildes2: INTEGER): INTEGER is
			-- Duplicates an open file descriptor.
			-- Works only as expected for the standard i/o handles
		local
			r: INTEGER
			standard_handle: INTEGER
			from_fd,
			to_fd: INTEGER
			redirect_other_fd: BOOLEAN
		do
			from_fd := -1
			to_fd := -1
			standard_handle := -1

			-- detect which standard handle are used
			if posix_getstdhandle (STD_INPUT_HANDLE) = fildes then
				from_fd := 0
			elseif posix_getstdhandle (STD_OUTPUT_HANDLE) = fildes then
				from_fd := 1
			elseif posix_getstdhandle (STD_ERROR_HANDLE) = fildes then
				from_fd := 2
			end
			if posix_getstdhandle (STD_INPUT_HANDLE) = fildes2 then
				standard_handle := STD_INPUT_HANDLE
				to_fd := 0
			elseif posix_getstdhandle (STD_OUTPUT_HANDLE) = fildes2 then
				standard_handle := STD_OUTPUT_HANDLE
				to_fd := 1
			elseif posix_getstdhandle (STD_ERROR_HANDLE) = fildes2 then
				standard_handle := STD_ERROR_HANDLE
				to_fd := 2
			end

			Result := abstract_dup (fildes)

			if standard_handle /= -1 then
				safe_win_call (posix_setstdhandle (standard_handle, Result))
				redirect_other_fd := from_fd /= -1 and to_fd /= -1
				if redirect_other_fd then
					-- on Windows the stream is not redirected unless you explicitly
					-- redirect that other Windows incompatible file descriptor...
					r := posix_dup2 (from_fd, to_fd)
				end
			end
		end

	abstract_isatty (fildes: INTEGER): BOOLEAN is
			-- Determines if a file descriptor is associated with a terminal
		local
			type: INTEGER
		do
			type := posix_getfiletype (fildes)
			Result := type = FILE_TYPE_CHAR
		end

	abstract_read (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Read `nbyte's from `fildes' into `buf'.
		local
			success: BOOLEAN
			err: INTEGER
		do

			success := posix_readfile (fildes, buf, nbyte, $temp_int, default_pointer)
			if success then
				Result := temp_int
			else
				err := posix_getlasterror
				-- ERROR_BROKEN_PIPE happens when the remote has closed
				-- the pipe. This happens for example when you read stdout
				-- from a process and the process is finished. We want to
				-- treat this as eof.
				-- ReadFile seems to fail, but have ERROR_SUCCESS as the
				-- error when I compile my application for multi-threading
				-- (???). Just ignoring this bogus case (i.e. return 0
				-- bytes read) worked for me. Your mileage may vary.
				if
					err /= ERROR_BROKEN_PIPE and then
					err /= ERROR_SUCCESS
				then
					Result := -1
					errno.set_value (err)
				end
			end
		end

	abstract_write (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Write `nbyte's from `buf' to `fildes'.
		local
			success: BOOLEAN
			err: INTEGER
		do
			success := posix_writefile (fildes, buf, nbyte, $temp_int, default_pointer)
			if success then
				Result := temp_int
			else
				err := posix_getlasterror
				-- Previously I had these checks. I really have no idea
				-- anymore why I had this.
-- 				if (err = ERROR_BROKEN_PIPE) or else
-- 					(err = ERROR_NO_DATA) then
-- 					Result := 0
-- 				else
-- 					Result := -1
-- 					errno.set_value (posix_getlasterror)
-- 				end
				Result := -1
				errno.set_value (err)
			end
		end


feature {NONE} -- error codes

	abstract_EWOULDBLOCK: INTEGER is
			-- The process would be delayed in the I/O operation
		do
			-- Windows also does have EGAIN, but it's meaning is
			-- "Resource temporarily unavailable". It's not equal to
			-- EWOULDBLOCK like on Unix.
			Result := ERROR_NO_DATA
		end

	abstract_EINTR: INTEGER is
			-- read/write was interrupted
		do
			Result := EINTR
		end


feature {NONE} -- temp vars, needed for $

	temp_int: INTEGER

end
