note

	description: "ISE conversion of strings to pointers and vice versa."
	thanks: "The mico/E team for the idea."


class

	EPX_STRING_HELPER


inherit

	ABSTRACT_STRING_HELPER
		redefine
			unfreeze_all
		end

	EPX_ISE_GC_HELPER


feature -- ISE specific conversions

	pointer_to_string (p: POINTER): STRING
		do
			if p = default_pointer then
				Result := ""
			else
				create Result.make_from_c (p)
			end
		end

	set_string_from_pointer (s: STRING; p: POINTER)
		do
			if p = default_pointer then
				s.wipe_out
			else
				s.make_from_c (p)
			end
		end

	string_to_pointer (s: detachable READABLE_STRING_8): POINTER
			-- Return a pointer to a linear area containing all the data
			-- in `s'. The area is zero-terminated.
			-- `s' may contain '%U' characters, but you will have to be
			-- careful to what functions you pass that string. C
			-- functions usually don't like that.
			-- For moving garbage collectors you should regularly call
			-- `unfreeze_all', else memory will not be freed.
			-- The returned pointer is read-only, it probably does not
			-- point to `s' because a new string is created!
		do
			if attached s then
				if not attached {UC_STRING} s as uc or else uc.count = uc.byte_count then
					Result := do_string_to_pointer (s)
				else
					Result := do_uc_string_to_pointer (uc)
				end
			end
		end

	uc_string_to_pointer (s: detachable UC_STRING): POINTER
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
			if attached s then
				if s.count /= s.byte_count then
					Result := do_uc_string_to_pointer (s)
				else
					Result := do_string_to_pointer (s)
				end
			end
		end

	unfreeze_all
		do
			unfreeze_objects
		end


feature {NONE} -- Implementation

	do_string_to_pointer (s: STRING): POINTER
			-- Return a pointer to a linear area containing all the data
			-- in `s'. The area is zero-terminated.
		local
			buf: STDC_BUFFER
		do
			if attached {ANY} s.to_c as a then
				create buf.allocate (s.count + 1)
				buf.memory_copy ($a, 0, 0, s.count)
				-- Set zero byte
				buf.poke_character (buf.capacity - 1, '%U')
				frozen_objects.put_last (buf)
				Result := buf.ptr
			end
		ensure then
			one_more_frozen_object: frozen_objects.count = old frozen_objects.count + 1
		end

	do_uc_string_to_pointer (s: UC_STRING): POINTER
			-- Return a pointer to a linear area containing all the data
			-- in the Unicode string `s'.
		local
			real_s: STRING
		do
			real_s := s.to_utf8
			Result := do_string_to_pointer (real_s)
		ensure then
			one_more_frozen_object: frozen_objects.count = old frozen_objects.count + 1
		end


end
