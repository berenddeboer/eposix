indexing

	description: "Class that covers Standard C string.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	CAPI_STRING


feature -- C binding

	posix_memcmp (a_s1, a_s2: POINTER; a_size: INTEGER): INTEGER is
			-- Compare two memory areas. It returns an integer less than,
			-- equal to, or greater than zero if s1 is found,
			-- respectively, to be less than, to match, or be greater
			-- than s2.
		require
			valid_s1: a_s1 /= default_pointer
			valid_s2: a_s2 /= default_pointer
			valid_size: a_size >= 0
		external "C"
		end

	posix_memcpy (dest, src: POINTER; a_size: INTEGER) is
			-- Copy non-overlapping memory objects.
		require
			valid_pointers: dest /= default_pointer and src /= default_pointer
			valid_size: a_size >= 0
			--- pointers do not overlap
		external "C"
		ensure
			-- a_size = 0 implies Result = default_pointer
		end

	posix_memmove (dest, src: POINTER; a_size: INTEGER) is
			-- Copies (possibly overlapping) memory objects
		require
			valid_pointers: dest /= default_pointer and src /= default_pointer
			valid_size: a_size >= 0
		external "C"
		end

	posix_memset (p: POINTER; byte, a_size: INTEGER) is
			-- Fill memory with a constant byte
		require
			valid_ptr: p /= default_pointer
			valid_byte: byte >= 0 and byte <= 255
			valid_size: a_size >= 0
		external "C"
		end

	posix_strerror (errnum: INTEGER): POINTER is
			-- Converts an error number to a string
		external "C"
		end


end
