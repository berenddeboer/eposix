indexing

	description: "Extension to STDC_BUFFER that has the ability to set the `count'. Only up to `count' bytes can be read."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_PARTIAL_BUFFER


inherit

	STDC_BUFFER
		redefine
			is_valid_index,
			is_valid_range,
			set_capacity
		end


create

	allocate,
	allocate_and_clear,
	make_from_pointer


feature -- Access

	count: INTEGER
			-- Number of bytes that may be accessed in this buffer


feature -- Status

	is_valid_index (index: INTEGER): BOOLEAN is
		do
			Result := index >= 0 and index < count
		end

	is_valid_range (from_index, to_index: INTEGER): BOOLEAN is
			-- Is `from_index'..`to_index' a valid and meaningfull range?
		do
			Result :=
				from_index >= 0 and from_index < count and
				to_index >= from_index and to_index < count
		end


feature -- Change

	set_count (a_count: INTEGER) is
		require
			valid_count: a_count >= 0 and then a_count <= capacity
		do
			count := a_count
		ensure
			count_set: count = a_count
		end


feature {NONE} -- Low level handle functions

	set_capacity (a_capacity: INTEGER) is
		do
			capacity := a_capacity
			if count > capacity then
				count := capacity
			end
		end


invariant

	count_within_capacity: count >= 0 and then count <= capacity

end
