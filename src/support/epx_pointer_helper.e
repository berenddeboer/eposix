note

	description: "Class that does pointer arithmetic."

	usage: "Use a mixin."

	I_trust_myself: "Should be yes..."

	author: "Berend de Boer"

class

	EPX_POINTER_HELPER


feature -- Pointer conversion

	any_to_pointer (a: any): POINTER
			-- Pointer to `a'
		require
			a_not_void: a /= Void
		do
			Result := $a
		ensure
			not_nil: Result /= default_pointer
		end

	posix_pointer_to_integer (p: POINTER): INTEGER
		external "C"
		end


feature -- Pointer operations

	posix_pointer_add (p: POINTER; offset: INTEGER): POINTER
			-- Increment `p' with `offset' bytes.
		obsolete "Every POINTER now supports the '+' operator."
		require
			valid_p: p /= default_pointer
		external "C"
		ensure
			valid_result: Result /= default_pointer
		end

	posix_pointer_advance (p: POINTER): POINTER
			-- Do a p++ if p is a void**.
		require
			valid_p: p /= default_pointer
		external "C"
		ensure
			valid_result: Result /= default_pointer
		end

	posix_pointer_contents (p: POINTER): POINTER
			-- Return the contents of a pointer, given 'ptr' is of the
			-- C type char** or void**.
		require
			valid_p: p /= default_pointer
		external "C"
		end


end
