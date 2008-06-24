indexing

	description: "Converts arrays to pointers."
	thanks: "The mico/E team for the idea."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_ARRAY_HELPER


inherit

	ABSTRACT_ARRAY_HELPER
		undefine
			unfreeze_all
		end

	EPX_ISE_GC_HELPER
		rename
			unfreeze_objects as unfreeze_all
		end

	PLATFORM
		export {NONE} all end


feature -- ISE specific conversions

	integer_array_to_pointer (a: ARRAY [INTEGER]): POINTER is
		local
			c_any: ANY
			buf: STDC_BUFFER
		do
			c_any := a.to_c
			if c_any /= Void then
				create buf.allocate (a.count * 4)
				buf.memory_copy ($c_any, 0, 0, a.count * 4)
				frozen_objects.put_last (buf)
				Result := buf.ptr
			end
		ensure then
			one_more_frozen_object: frozen_objects.count = old frozen_objects.count + 1
		end

	pointer_array_to_pointer (a: ARRAY [POINTER]): POINTER is
			-- Convert to void **.
		local
			c_any: ANY
			buf: STDC_BUFFER
			bytes: INTEGER
		do
			c_any := a.to_c
			if c_any /= Void then
				bytes := Pointer_bits // 8
				create buf.allocate (a.count * bytes)
				buf.memory_copy ($c_any, 0, 0, a.count * bytes)
				frozen_objects.put_last (buf)
				Result := buf.ptr
			end
		ensure then
			one_more_frozen_object: frozen_objects.count = old frozen_objects.count + 1
		end


end
