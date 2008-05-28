indexing

	description: "Stack, what do we miss a portable EiffelBase."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_STACK [G]

obsolete

		"eposix now depends upon Gobo. Use Gobo's DS_STACK instead."

create

	make


feature -- creation

	make (suggested_capacity: INTEGER) is
		require
			valid_capacity: suggested_capacity >= 0
		do
			create items.make (0, suggested_capacity)
		end


feature -- usual stack features

	is_empty: BOOLEAN is
		do
			Result := count = 0
		end

	pop is
		require
			can_pop: not is_empty
		do
			count := count - 1
		end

	push (a_item: G) is
		do
			assert_has_room (count)
			items.put (a_item, count)
			count := count + 1
		ensure
			can_pop: not is_empty
			more_items: count = old count + 1
			really_on_stack: exists_on_stack (a_item)
		end

	count: INTEGER
			-- number of entries on stack

	top: G is
			-- item on stack
		require
			has_items: not is_empty
		do
			Result := items.item (count - 1)
		end

	clear is
			-- remove all entries from stack
		do
			count := 0
			items.clear_all
		ensure
			no_entries: is_empty
		end


feature -- more unusual features

	exists_on_stack (a_item: G): BOOLEAN is
			-- Returns true if an exact copy of `a_item' is somewhere on
			-- the stack
		local
			i: INTEGER
		do
			from
				i := count - 1
			until
				Result or else i < 0
			loop
				Result := items.item (i).is_equal (a_item)
				i := i - 1
			end
		end

	remove (a_item: G) is
			-- removes the first occurence of this item
		require
			really_on_stack: exists_on_stack (a_item)
		local
			i: INTEGER
			Found: BOOLEAN
		do
			from
				i := count - 1
			until
				Found or else i < 0
			loop
				Found := items.item (i).is_equal (a_item)
				if Found then
					from
					until
						i = count - 1
					loop
						items.put (items.item (i + 1), i)
						i := i + 1
					end
					count := count - 1
				else
					i := i - 1
				end
			end
		ensure
			one_item_less: count = old count - 1
		end


feature {NONE} -- private state

	items: ARRAY[G]

	assert_has_room (needed_capacity: INTEGER) is
		do
			if items.upper < needed_capacity then
				items.resize (items.lower, items.upper * 2)
			end
		ensure
			enough_capacity: items.upper >= needed_capacity
		end


invariant

	has_items: items /= Void

end
