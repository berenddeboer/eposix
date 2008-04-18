indexing

	description:

		"Semaphore abstraction for named and unnamed semaphores."

	notes: "This kind of semaphore can be acquired just once. Use direct OS calls to acquire a semaphore multiple times if the OS supports that."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	ABSTRACT_SEMAPHORE [H]


inherit

	STDC_HANDLE [H]

	PLATFORM
		export
			{NONE} all
		end


feature -- Commands

	attempt_acquire is
			-- Lock the semaphore only if it is not locked. If it is locked
			-- by some process, this command returns immediately and the
			-- semaphore is not locked
		require
			open: is_open
			unlocked: not is_acquired
		deferred
		end

	acquire is
			-- Lock the semaphore.
		require
			open: is_open
			unlocked: not is_acquired
		deferred
		ensure
			locked: raise_exception_on_error implies is_acquired
		end

	release is
			-- Unlock the semaphore.
		require
			open: is_open
			locked: is_acquired
		deferred
		ensure
			unlocked: raise_exception_on_error implies not is_acquired
		end


feature -- Access

	resource_usage_can_be_increased: BOOLEAN is
			-- Can the number of allocated resources increased with `capacity'?
		do
			-- We don't keep track of semaphore handles
			Result := True
		end


feature -- Status

	is_acquired: BOOLEAN
			-- Has the semaphore been acquired successfully?

	is_initialized: BOOLEAN is
		obsolete "2004-06-18: Use is_open instead."
		do
			Result := is_open
		end

	is_locked: BOOLEAN is
		obsolete "2004-06-19 Use is_acquired instead."
		do
			Result := is_acquired
		end

	supports_semaphores: BOOLEAN is
			-- Does this Operating System supports semaphores?
			-- Most systems support unnamed semaphores, but still return
			-- False here...
		deferred
		end


feature {NONE} -- Counting of allocated resource

	decrease_resource_count is
			-- Decrease number of allocated resource by `capacity'.
			-- Due to limitations of certain Eiffel implementations, this
			-- routine may not call any other object. Calling C code is safe.
		do
			shared_resource_count.set_item (shared_resource_count.item - capacity)
		end

	increase_resource_count is
			-- Increase number of allocated resources by `capacity'.
		do
			shared_resource_count.set_item (shared_resource_count.item + capacity)
		end

	resource_count: INTEGER is
			-- Currently allocated number of resources. It's a global
			-- number, counting the `capacity' of all owned resources of
			-- this type.
		do
			Result := shared_resource_count.item
		end

	shared_resource_count: INTEGER_REF is
		once
			create Result
		ensure
			shared_resource_count_not_void: shared_resource_count /= Void
		end


feature {NONE} -- Abstract API

	abstract_sem_value_max: INTEGER is
			-- Maximum initial value for a semaphore.
		deferred
		ensure
			sem_value_max_positive: Result > 0
		end


end
