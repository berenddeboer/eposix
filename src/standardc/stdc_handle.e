indexing

	description:

		"Base class for other classes that create or get assigned a handle%
		%to an external resource like a file, socket or memory block. %
		%This class can become owner of the resource in which case it%
		%automatically closes the resource when garbage collected. It also%
		%contains protection against misuse of resources by checking against%
		%set limits.%
		%Postconditions that resource counting is correct, only work when the%
		%garbage collector does not kick in. Therefore, disable the gc if you%
		%want to test it or compile without a gc."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"


deferred class

	STDC_HANDLE [H]


inherit

	STDC_BASE

	MEMORY
		export
			{NONE} all
		redefine
			dispose
		end


feature {NONE} -- Resources retrieved from other applications

	attach_to_handle (a_handle: H; a_become_owner: BOOLEAN) is
			-- This class will give access to `a_handle'. It will become
			-- the owner of it if `a_become_owner'. If not
			-- `a_become_owner', the handle will not be automatically
			-- closed, unless `become_owner' is called.
		require
			closed: not is_open
			is_handle: a_handle /= unassigned_value
			capacity_set: capacity > 0
			resource_usage_within_limits: resource_usage_can_be_increased
		do
			set_handle (a_handle, a_become_owner)
		ensure
			open: is_open
			owner_set: a_become_owner = is_owner
			resource_accounted_for: is_resource_count_incremented (old resource_count)
		end


feature -- Access

	is_open: BOOLEAN is
			-- Does `handle' contain an open handle?
		do
			Result := handle /= unassigned_value
		ensure
			not_unassigned: Result implies handle /= unassigned_value
		end

	is_owner: BOOLEAN
			-- Does this object close the stream on `close' or `dispose'?
			-- Only for resources that are owned, are resource limits checked.

	resource_usage_can_be_increased: BOOLEAN is
			-- Can the number of allocated resources increased with `capacity'?
		require
			capacity_set: capacity > 0
		deferred
		end


feature -- Influence ownership of the handle. Can help to influence subtile garbage collector problems

	become_owner is
			-- This class will own its handle. This is the only function
			-- that actually increases the resource count.
		require
			open: is_open
			not_owner: not is_owner
			resource_usage_within_limits: resource_usage_can_be_increased
		do
			-- Become owner, because file is open, we must close it
			is_owner := True
			-- Next try to increase resource usage. Will cause exception
			-- if number of allowed open files is exceeded.
			increase_resource_count
		ensure
			owner: is_owner
			open_resources_increased: is_resource_count_incremented (old resource_count)
		end

	unown is
			-- Resource will not be closed on dispose. Calling close will
			-- be forbidden. This routine may not call any other object,
			-- else it cannot be called from within dispose.
		require
			owner: is_owner
		do
			decrease_resource_count
			is_owner := False
		ensure
			not_owner: not is_owner
			open_resources_decreased: is_resource_count_decremented (old is_owner, old resource_count, old capacity)
		end


feature -- Close

	close is
			-- Close the resource.
		require
			owner: is_owner
		local
			success: BOOLEAN
		do
			if is_owner then
				success := do_close
				capacity := 0
				if not success then
					raise_posix_error
				end
			else
				-- In case you run with preconditions off, still do
				-- something sensible.
				detach
			end
		ensure
			closed: not is_open
			not_owner: not is_owner
			resource_accounted_for: is_resource_count_decremented (old is_owner, old resource_count, old capacity)
		end

	detach is
			-- Forget the resource. Resource is not closed.
		require
			open: is_open
		do
			clear_handle
		ensure
			closed: not is_open
			not_owner: not is_owner
			resource_accounted_for: is_resource_count_decremented (old is_owner, old resource_count, old capacity)
		end


feature -- Cleanup

	dispose is
			-- Close handle if owner.
		local
			success: BOOLEAN
		do
			if is_open and then is_owner then
				success := do_close
			end
			precursor
		end


feature -- Resource

	capacity: INTEGER
			-- Number of resources that are in use by `handle'. For a
			-- file this is 1, for a memory handle, this is the number of
			-- bytes.

	handle: H
			-- Identifier of resource tracked by this class.


feature {NONE} -- Low level handle functions

	clear_handle is
			-- Give handle its default value. This is the only function
			-- that may do so, else resource counting may be
			-- incorrect. This routine may never call another object,
			-- else it cannot be used safely in `dispose'.
		do
			if is_owner then
				unown
			end
			handle := unassigned_value
			capacity := 0
		ensure
			handle_unassigned: handle = unassigned_value
			capacity_cleared: capacity = 0
			resource_accounted_for: is_resource_count_decremented (old is_owner, old resource_count, old capacity)
		end

	do_close: BOOLEAN is
			-- Close resource. Return False if an error occurred. Error
			-- value should be in `errno'. This routine may never call
			-- another object, else it cannot be used safely in
			-- `dispose'.
			-- This routine is usually redefined to actually close or
			-- deallocate the resource in addition of resetting `handle'.
		require
			open: is_open
			owner: is_owner
		do
			clear_handle
			Result := True
		ensure
			handle_unassigned: handle = unassigned_value
			closed: not is_open
			resource_accounted_for: is_resource_count_decremented (old is_owner, old resource_count, old capacity)
		end

	set_handle (a_handle: H; a_become_owner: BOOLEAN) is
			-- Only function that sets `handle'. Should only be called
			-- with a valid handle, call `clear_handle' to reset the
			-- handle.
		require
			is_handle: a_handle /= unassigned_value
			handle_not_set: handle = unassigned_value
			capacity_positive: capacity > 0
			unowner: not is_owner
			resource_usage_within_limits: a_become_owner implies resource_usage_can_be_increased
		do
			handle := a_handle
			if a_become_owner then
				become_owner
			end
		ensure
			handle_set: handle = a_handle
			owner_set: a_become_owner = is_owner
			resource_accounted_for: is_resource_count_incremented (old resource_count)
		end

	unassigned_value: H is
			-- The value that indicates that `handle' is unassigned.
		deferred
		end


feature {NONE} -- Counting of allocated resource

	decrease_resource_count is
			-- Decrease number of allocated resource by `capacity'.
			-- Due to limitations of certain Eiffel implementations, this
			-- routine may not call any other object. Calling C code is safe.
		require
			capacity_set: capacity > 0
		deferred
		ensure
			open_resources_decreased:
				memory.collecting or else
				resource_count = old resource_count - capacity
		end

	increase_resource_count is
			-- Increase number of allocated resources by `capacity'.
		require
			capacity_set: capacity > 0
			resource_usage_within_limits: resource_usage_can_be_increased
		deferred
		ensure
			open_resources_increased:
				memory.collecting or else
				resource_count = old resource_count + capacity
		end

	is_resource_count_decremented (old_is_owner: BOOLEAN; old_resource_count, old_capacity: INTEGER): BOOLEAN is
			-- Is `resource_count' correctly decremented depending on
			-- `is_owner' given old `resource_count'?
			-- Routine to be used in postconditions.
		require
			old_resource_count_not_negative: old_resource_count >= 0
			old_capacity_set: old_is_owner implies old_capacity > 0
		do
			Result :=
				memory.collecting or else
				((old_is_owner implies
				  resource_count = old_resource_count - old_capacity) and then
				 (not old_is_owner implies
				  resource_count = old_resource_count))
		ensure
			no_test_when_gc_enabled: memory.collecting implies Result
		end

	is_resource_count_incremented (old_resource_count: INTEGER): BOOLEAN is
			-- Is `resource_count' correctly incremented depending on
			-- `is_owner' given old `resource_count'?
			-- Routine to be used in postconditions.
		require
			old_resource_count_not_negative: old_resource_count >= 0
			capacity_set: capacity > 0
		do
			Result :=
				memory.collecting or else
				((is_owner implies
				  resource_count = old_resource_count + capacity) and then
				 (not is_owner implies
				  resource_count = old_resource_count))
		ensure
			no_test_when_gc_enabled: memory.collecting implies Result
		end

	memory: MEMORY is
			-- Ensuring that resource counting is correct, works only
			-- when garbage collector doesn't kick in to dispose handles.
			-- Need to test if garbage collector enabled or not.
		once
			create Result
		end

	resource_count: INTEGER is
			-- Currently allocated number of resources. It's a global
			-- number, counting the `capacity' of all owned resources of
			-- this type.
		deferred
		ensure
			resource_count_not_negative: Result >= 0
		end


invariant

	capacity_not_negative: capacity >= 0
	valid_capacity: is_open = (capacity > 0)
	open_implies_handle_assigned: is_open = (handle /= unassigned_value)
	owned_implies_open: is_owner implies is_open
	owned_implies_handle_assigned: is_owner implies handle /= unassigned_value

end
