indexing

	description: "Class that does pointer arithmetic."

	usage: "Use a mixin."

	I_trust_myself: "Should be yes..."

	author: "Berend de Boer"
	date: "$Date: 2003/03/20 $"
	revision: "$Revision: #1 $"

class

	EPX_POINTER_HELPER


feature -- Pointer conversion

	posix_pointer_to_integer (p: POINTER): INTEGER is
		external "C"
		end


feature -- Pointer operations

	posix_pointer_add (p: POINTER; offset: INTEGER): POINTER is
			-- Increment `p' with `offset' bytes.
		obsolete "Every POINTER now supports the '+' operator."
		require
			valid_p: p /= default_pointer
		external "C"
		ensure
			valid_result: Result /= default_pointer
		end

	posix_pointer_advance (p: POINTER): POINTER is
			-- Do a p++ if p is a void**.
		require
			valid_p: p /= default_pointer
		external "C"
		ensure
			valid_result: Result /= default_pointer
		end

	posix_pointer_contents (p: POINTER): POINTER is
			-- Return the contents of a pointer, given 'ptr' is of the
			-- C type char** or void**.
		require
			valid_p: p /= default_pointer
		external "C"
		end


end
