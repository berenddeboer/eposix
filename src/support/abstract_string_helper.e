indexing

	description:

		"String utilities such as converting strings to pointers and vice versa."

	thanks: "The mico/E team for the idea."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #15 $"

deferred class

	ABSTRACT_STRING_HELPER

inherit

	KL_IMPORTED_STRING_ROUTINES


feature -- Contracts for platform specific EPX_STRING_HELPER

	pointer_to_string (p: POINTER): STRING is
			-- Returns a new string from a zero-terminated string pointed
			-- to by `p'.
		require
			-- any `p' including default_pointer
		deferred
		ensure
			string_not_void: Result /= Void
			empty_string: p = default_pointer implies Result.is_empty
		end

	set_string_from_pointer (s: STRING; p: POINTER) is
			-- Copy contents of `p' to `s'.
		require
			valid_s: s /= Void
		deferred
		ensure
			empty_string: p = default_pointer implies s.count = 0
		end

	string_to_pointer (s: STRING): POINTER is
			-- Return a pointer to a linear area containing all the data
			-- in `s'. The area is zero-terminated.
			-- `s' may contain '%U' characters, but you will have to be
			-- careful to what functions you pass that string. C
			-- functions usually don't like that.
			-- For moving garbage collectors you should regularly call
			-- `unfreeze_all', else memory will not be freed.  The
			-- returned pointer is read-only, it probably does not point
			-- to `s' because a new string is created!
		deferred
		ensure
			definition: (s = Void) = (Result = default_pointer)
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
		deferred
		ensure
			definition: (s = Void) = (Result = default_pointer)
		end

	unfreeze_all is
			-- After having called `string_to_pointer', regularly call
			-- `unfreeze_all' to make objects available to the garbage
			-- collector again.
		deferred
		end


feature -- String utilities that have different names per compiler...

	frozen wipe_out (s: STRING) is
			-- Remove all characters in `s', but do not change its
			-- capacity. Notably ISE doesn't implement ELKS correctly
			-- here.
			-- Note that if you have a UC_STRING, wipe_out is correctly
			-- implemented, even for ISE.
		obsolete "2008-08-08: use STRING_.wipe_out"
		require
			s_not_void: s /= Void
		do
			STRING_.wipe_out (s)
		ensure
			empty: s.is_empty
		end

	frozen has_substring (s, substring: STRING): BOOLEAN is
			-- True if `s' contains the string `substring'
		obsolete "has_substring is now portable, use s.has_substring instead."
		require
			s_not_void: s /= Void
		do
			Result := s.has_substring (substring)
		end

	frozen insert_character (s: STRING; c: CHARACTER; i: INTEGER) is
		obsolete "[20050303] please use s.insert_character (c, i) instead."
		require
			s_not_void: s /= Void
			valid_index: i >= 1 and i <= s.count + 1
		do
			s.insert_character (c, i)
		end

	frozen make_with_capacity (capacity: INTEGER): STRING is
			-- Create a new string.
		obsolete "Use STRING.make, it is now portable."
		require
			valid_capacity: capacity >= 0
		do
			create Result.make (capacity)
		ensure
			have_result: Result /= Void
		end


feature -- General string utilities

	append_integer (s: STRING; i: INTEGER; width: INTEGER) is
			-- Append `i' to `s', pad until `width' with 0 if necessary.
		require
			s_not_void: s /= Void
			positive_integer: i >= 0
			valid_width: width >= 1
			i_fits_in_width: i.out.count <= width
		local
			t: STRING
			j: INTEGER
			count: INTEGER
		do
			t := i.out
			from
				j := width
				count := t.count
			until
				j = count
			loop
				s.append_character ('0')
				j := j - 1
			end
			s.append_string (t)
		ensure
			s_is_longer: s.count = old s.count + width
		end

	chop (s: STRING) is
			-- remove newline character (if any) from `s'
			-- only when the last characters from last_string are %N or
			-- %R%N, they're removed.
		require
			s_not_void: s /= Void
		do
			if s.count > 0 and then s.item (s.count) = '%N' then
				s.remove (s.count)
				if s.count > 0 and then s.item (s.count) = '%R' then
					s.remove (s.count)
				end
			end
		end

	make_spaces (count: INTEGER): STRING is
			-- Return string with `count' spaces.
		require
			valid_count: count >= 0
		do
			create Result.make_filled (' ', count)
		ensure
			enough_spaces: Result /= Void and then Result.count = count
			only_spaces: True -- for_each c in Result it_holds c = ' '
		end

	split_on (s: STRING; on: CHARACTER): ARRAY [STRING] is
			-- Split `s' on a given character `on'.
			-- s = Void is treated as s.is_empty, in that case the Result
			-- doesn't contain any entries.
		local
			p, start: INTEGER
			tmp_string: STRING
			count: INTEGER
			large_array: ARRAY [STRING]
			i: INTEGER
		do
			if s /= Void and then not s.is_empty then
				-- attempt to avoid allocs
				create Result.make (0, 32)
				from
					start := 1
					p := s.index_of (on, start)
				variant
					(s.count + 1) - start
				until
					p = 0
				loop
					tmp_string := s.substring (start, p-1)
					Result.force (tmp_string, count)
					count := count + 1
					start := p + 1
					p := s.index_of (on, start)
				end

				if start <= s.count then
					tmp_string := s.substring (start, s.count)
					Result.force (tmp_string, count)
					count := count + 1
				elseif start = s.count + 1 then
					-- make sure that when ended with `on' we append an
					-- empty string
					Result.force ("", count)
					count := count + 1
				end
				Result.resize (0, count-1)
				-- The following code covers the case where ARRAY.resize
				-- is not ELKS conformant.
				if Result.upper /= count - 1 then
					large_array := Result
					create Result.make (0, count - 1)
					from
						i := 0
					until
						i > count - 1
					loop
						Result.put (large_array.item (i), i)
						i := i + 1
					end
				end
			else
				create Result.make (0, -1)
			end
		ensure
			array_empty_if_s_empty:
				(s = Void implies Result.count = 0) and
				(s.is_empty implies Result.count = 0)
			got_all_parts:
				s /= Void and then not s.is_empty implies
					Result.count = s.occurrences (on) + 1
			-- and for_each s element_of Result it_holds s /= Void
		end

	trim (s: STRING) is
			-- Remove leading and trailing white space. Actual definition
			-- of white space probably depends on vendors `left_adjust'
			-- and `right_adjust' implementations.
		require
			s_not_void: s /= Void
		do
			s.left_adjust
			s.right_adjust
		ensure
			s_same_size_or_smaller: s.count <= old s.count
		end


feature {NONE} -- Implementation

	do_string_to_pointer (s: STRING): POINTER is
			-- A pointer to a linear area containing all the data
			-- in `s'. The area is zero-terminated.
			-- `s'.`count' should be equal to `s'.`byte_count'.
			-- For moving garbage collectors you should regularly call
			-- `unfreeze_all', else memory will not be freed.
		require
			s_not_void: s /= Void
		deferred
		ensure
			not_nil: Result /= default_pointer
		end

	do_uc_string_to_pointer (s: UC_STRING): POINTER is
			-- A pointer to a linear area containing all the data
			-- in the Unicode string `s'.
			-- Currently getting such a pointer is not an operation
			-- directly supported by UC_STRING and we need to do
			-- different things for certain compilers.
			-- And because a new string might have to be created, we need
			-- to keep that alive, so it won't get garbage collected.
		require
			s_not_void: s /= Void
		deferred
		ensure
			not_nil: Result /= default_pointer
		end


end
