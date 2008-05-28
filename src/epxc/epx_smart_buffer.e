indexing

   description: "Smart buffer that has the notion of fill, because it %
   %has a `count'. It can grow if needed."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class

   EPX_SMART_BUFFER


inherit

   STDC_BUFFER


create

   allocate,
   allocate_and_clear


feature -- append things and manage `count'

   append_character (c: CHARACTER) is
      do
         assure_has_room (count + 1)
         poke_character (count, c)
         count := count + 1
      ensure
         count_greater: count = old count + 1
      end

   clear is
      do
         count := 0
      ensure
         empty: count = 0
      end

   remove_last_character is
      require
         there_is_something: count > 0
      do
         count := count - 1
      ensure
         count_lesser: count = old count - 1
      end

   set_count (new_count: INTEGER) is
      require
         valid_new_count: new_count >= 0 and new_count <= capacity
      do
         count := new_count
      end


feature -- queries

   has_substring (other: STRING): BOOLEAN is
         -- Does buffer contain 'other'?
         -- Checks contents up to `count'
      require
         other_not_empty: other /= Void and then not other.is_empty
      local
         stop: BOOLEAN
         i1, i2, i3: INTEGER
         index: INTEGER
      do
         if capacity >= other.count then
            -- the following smart search algorithm shamelessly
            -- copied from SE
            from
               index := -1
               i1 := 0
               i2 := other.count - 1
               i3 := i2 + 1
            invariant
               i3 = i2 - i1 + 1
            variant
               (count + 1) - i1
            until
               index >= 0
            loop
               if i2 >= count then
                  index := count
               else
                  from
                     stop := False
                  invariant
                     i3 = i2 - i1 + 1
                  variant -- be carefull to keep it >= 0
                     (i3 + i2 + 3)
                  until
                     stop
                  loop
                     if i3 = 0 then
                        stop := True
                        index := i1
                     elseif other.item (i3) /= peek_character (i2) then
                        stop := True
                     end
                     i3 := i3 - 1
                     i2 := i2 - 1
                  end
               end
               i1 := i1 + 1
               i3 := other.count
               i2 := i1 + i3 - 1
            end
            Result := index < count
         else
            Result := False
         end
      ensure
         false_if_too_small: capacity < other.count implies not Result
      end


feature -- state

   count: INTEGER


feature {NONE} -- grow buf

   assure_has_room (needed_capacity: INTEGER) is
      local
         new_capacity: INTEGER
      do
         if needed_capacity > capacity then
            -- attempt to avoid growing too less
            if needed_capacity - capacity < 2 * capacity then
               new_capacity := capacity * 2
            else
               new_capacity := needed_capacity
            end
            resize (new_capacity)
         end
      ensure
         we_have_room: capacity >= needed_capacity
      end


end -- class EPX_SMART_BUFFER
