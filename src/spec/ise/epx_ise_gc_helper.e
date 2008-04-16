indexing

	description: "ISE routines to access its garbage collector."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_ISE_GC_HELPER


feature -- Unfreezing

	unfreeze_objects is
			-- Unfreeze the objects in `frozen_objects'.
		do
			from
				frozen_objects.start
			until
				frozen_objects.after
			loop
				frozen_objects.item_for_iteration.deallocate
				frozen_objects.forth
			end
			frozen_objects.wipe_out
		ensure
			all_unfrozen: frozen_objects.is_empty
		end


feature {NONE} -- Frozen object remembering

	frozen_objects: DS_LINKED_LIST [STDC_BUFFER] is
			-- All frozen objects are stored in this buffer. Call
			-- `unfreeze_objects' to free them.
			-- Actually the objects are not frozen, but copied to a
			-- portion of memory that does not move. Freezing and
			-- unfreezing does not seem to work reliably with ISE Eiffel 5.5.
			-- This list of objects is shared among all external
			-- helpers. Calling `clear_frozen_objects' on any of them, will
			-- unfreeze all frozen objects.
		once
			create Result.make
		ensure
			frozen_objects_not_void: frozen_objects /= Void
		end


end
