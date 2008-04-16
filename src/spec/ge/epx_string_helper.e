indexing

	description: "GEC conversion of strings to pointers and vice versa."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	EPX_STRING_HELPER


inherit

	ABSTRACT_STRING_HELPER
		redefine
			unfreeze_all
		end


feature -- GE specific conversions

	pointer_to_string (p: POINTER): STRING is
		do
			if p = default_pointer then
				Result := ""
			else
				create Result.make_from_c (p)
			end
		end

	set_string_from_pointer (s: STRING; p: POINTER) is
		do
			if p = default_pointer then
				s.clear_all
			else
				s.make_from_c (p)
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
				if uc = Void or else uc.count = uc.byte_count then
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
				if s.count /= s.byte_count then
					Result := do_uc_string_to_pointer (s)
				else
					Result := do_string_to_pointer (s)
				end
			end
		end

	unfreeze_all is
		do
			-- Nothing to do
		end


feature {NONE} -- Implementation

	do_string_to_pointer (s: STRING): POINTER is
			-- Return a pointer to a linear area containing all the data
			-- in `s'. The area is zero-terminated.
		local
			a: ANY
			buf: STDC_BUFFER
		do
			a := s.to_c
			if a /= Void then
				create buf.allocate (s.count + 1)
				Result := $a
			end
		end

	do_uc_string_to_pointer (s: UC_STRING): POINTER is
			-- Return a pointer to a linear area containing all the data
			-- in the Unicode string `s'.
		local
			real_s: STRING
		do
			real_s := s.to_utf8
			Result := do_string_to_pointer (real_s)
		end


end
