indexing

	description: "Converts strings to pointers and vice versa. VisualEiffel 4.1 specification"
	thanks: "The mico/E team for the idea."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #9 $"

class

	EPX_STRING_HELPER


inherit

	ABSTRACT_STRING_HELPER


feature -- VisualEiffel specific conversions

	pointer_to_string (p: POINTER): STRING is
		do
			create Result.make_empty
			if p /= default_pointer then
				Result.from_c (p)
			end
		end

	set_string_from_pointer (s: STRING; p: POINTER) is
		do
			if p = default_pointer then
				s.wipe_out
			else
				s.from_c (p)
			end
		end

	string_to_pointer (s: STRING): POINTER is
			-- Return a pointer to a linear area containing all the data
			-- in `s'. The area is zero-terminated.
			-- `s' may contain '%U' characters, but you will have to be
			-- careful to what functions you pass that string. C
			-- functions usually don't like that.
			-- For moving garbage collectors you should regularly call
			-- `unfreeze_all', else memory will not be freed.
			-- The returned pointer is read-only, it probably does not
			-- point to `s' because a new string is created!
		local
			uc: UC_STRING
		do
			if s /= Void then
				uc ?= s
				-- For VE we must always convert a UC_STRING to a real STRING.
				if uc = Void then
					Result := do_string_to_pointer (s)
				else
					Result := do_uc_string_to_pointer (uc)
				end
			end
		end

	uc_string_to_pointer (s: UC_STRING): POINTER is
			-- Return a pointer to a linear area containing all the data
			-- in `s'. The string is encoded in UTF-8. The area is
			-- zero-terminated.
			-- `s' may contain '%U' characters, but you will have to be
			-- careful to what functions you pass that string. C
			-- functions usually don't like that.
			-- For moving garbage collectors you should regularly call
			-- `unfreeze_all', else memory will not be freed.
			-- The returned pointer is read-only, it probably does not
			-- point to `s' because a new string is created!
		do
			if s /= Void then
				Result := do_uc_string_to_pointer (s)
			end
		end

	unfreeze_all is
			-- After having called `string_to_pointer', regularly call
			-- `unfreeze_all' to make objects available to the garbage
			-- collector again.
		do
			saved_strings.clear_all
			saved_strings.resize (0, -1)
		end


feature {NONE} -- Implementation

	do_string_to_pointer (s: STRING): POINTER is
			-- A pointer to a linear area containing all the data
			-- in `s'. The area is zero-terminated.
			-- 's'.count should be equal to `s'.byte_count.
		do
			Result := s.to_pointer
		end

	do_uc_string_to_pointer (s: UC_STRING): POINTER is
			-- A pointer to a linear area containing all the data
			-- in the Unicode string `s'.
		local
			real_s: STRING
		do
			-- VE must have a real STRING.
			real_s := s.to_utf8
			Result := real_s.to_pointer
			-- A big issue now is to keep `real_s' alive until the next
			-- `unfreeze_all'.
			saved_strings.force (real_s, saved_strings.upper + 1)
		end

	saved_strings: ARRAY [STRING] is
			-- List of strings created by `uc_string_to_pointer' that
			-- must be kept alive.
		once
			create Result.make (0, -1)
		ensure
			saved_strings_not_void: Result /= Void
		end

end
