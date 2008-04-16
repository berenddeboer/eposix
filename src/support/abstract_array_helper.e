indexing

	description: "Base class to converts arrays to pointers."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


deferred class

	ABSTRACT_ARRAY_HELPER

inherit

	ANY

	EPX_EXTERNAL_HELPER
		export
			{NONE} all
		end

	EPX_POINTER_HELPER
		export
			{NONE} all
		end


feature -- String array to pointer and vice versa conversion

	string_array_to_pointer_array (a: ARRAY [STRING]): ARRAY [POINTER] is
			-- Convert ARRAY[STRING] to char ** (ARRAY[POINTER]).
			-- Resulting array is null terminated.
			-- Result of this can be passed to `pointer_array_to_pointer'.
			-- You have to call EPX_STRING_HELPER.unfreeze_all to
			-- unfreeze STRINGs locked in memory.
			-- The returned pointer is for read-only use. Modifications
			-- made are not reflected in `a'.
		require
			a_not_void: a /= Void
		local
			i: INTEGER
			s: STRING
		do
			-- Create new array with room for null terminator
			if a.item (a.upper) = Void then
				create Result.make (a.lower, a.upper)
			else
				create Result.make (a.lower, a.upper+1)
			end

			-- Copy the strings in the new array as pointers
			from
				i := a.lower
			until
				i > a.upper
			loop
				s := a.item (i)
				if s = Void then
					Result.put (default_pointer, i)
				else
					Result.put (sh.string_to_pointer(s), i)
				end
				i := i + 1
			end
			Result.put (default_pointer, Result.upper)
		ensure
			returned_array_not_void: Result /= Void
			null_terminated: Result.item (Result.upper) = default_pointer
		end

	pointer_to_string_array (p: POINTER): ARRAY [STRING] is
			-- Convert char ** to ARRAY[STRING];
			-- Returns an empty array if p = default_pointer.
		local
			ptr1, ptr2: POINTER
			s: STRING
		do
			create Result.make (0, -1)

			if p /= default_pointer then
				ptr1 := p
				from
					ptr2 := posix_pointer_contents (ptr1)
				until
					ptr2 = default_pointer
				loop
					s := sh.pointer_to_string (ptr2)
					Result.force (s, Result.upper+1)
					ptr1 := posix_pointer_advance (ptr1)
					ptr2 := posix_pointer_contents (ptr1)
				end
			end
		ensure
			array_not_void: Result /= Void
			nil_pointer_is_empty_array: p = default_pointer implies Result.count = 0
		end


feature -- Contracts for platform specific EPX_ARRAY_HELPER

	integer_array_to_pointer (a: ARRAY [INTEGER]): POINTER is
			-- Convert to int ** (??).
			-- The returned pointer is for read-only use. Modifications
			-- made are not reflected in `a'.
		require
			valid_array: a /= Void
		deferred
		ensure
			valid_result: Result /= default_pointer
		end

	pointer_array_to_pointer (a: ARRAY [POINTER]): POINTER is
			-- Convert to void **.
			-- The returned pointer is for read-only use. Modifications
			-- made are not reflected in `a'.
		require
			valid_array: a /= Void
		deferred
		ensure
			valid_result: Result /= default_pointer
		end

	unfreeze_all is
			-- After having called `array_to_pointer' or
			-- `integer_array_to_pointer', regularly call `unfreeze_all'
			-- to make objects available to the garbage collector again.
		do
			-- Do nothing
		end

end
