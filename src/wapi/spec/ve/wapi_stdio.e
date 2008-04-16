indexing

	description: "Class that covers Windows stdio.h."

	author: "Berend de Boer"
	date: "$Date: 2007/05/18 $"
	revision: "$Revision: #1 $"

class

	WAPI_STDIO


feature -- C binding

	posix_fdopen (fildes: INTEGER; a_mode: POINTER): POINTER is
			-- Opens a stream
		require
			valid_mode: a_mode /= default_pointer



		external "C"

		end

	posix_fileno (a_stream: POINTER): INTEGER is
			-- Maps a stream pointer to a file descriptor
		require
			valid_stream: a_stream /= default_pointer
		external "C"
		ensure
			-- Result = -1 implies errno.is_not_ok
		end


end -- class WAPI_STDIO
