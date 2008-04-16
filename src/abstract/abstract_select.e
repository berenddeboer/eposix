indexing

	description: "Abstraction upon the select() call."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	ABSTRACT_SELECT


inherit

	ABSTRACT_NET_BASE


feature {NONE} -- Initialize

	make is
			-- Initialize class. Preallocates its arrays, you don't want
			-- to create hundreds of EPX_SELECTs I suppose.
		do
			create {DS_HASH_SET [ABSTRACT_DESCRIPTOR]} check_for_exception_conditions.make (abstract_api.FD_SETSIZE)
			create {DS_HASH_SET [ABSTRACT_DESCRIPTOR]} check_for_reading.make (abstract_api.FD_SETSIZE)
			create {DS_HASH_SET [ABSTRACT_DESCRIPTOR]} check_for_writing.make (abstract_api.FD_SETSIZE)

			create {DS_HASH_SET [ABSTRACT_DESCRIPTOR]} exception_conditions.make (abstract_api.FD_SETSIZE)
			create {DS_HASH_SET [ABSTRACT_DESCRIPTOR]} ready_for_reading.make (abstract_api.FD_SETSIZE)
			create {DS_HASH_SET [ABSTRACT_DESCRIPTOR]} ready_for_writing.make (abstract_api.FD_SETSIZE)

			create exception_conditions_fd_set.make
			create reading_fd_set.make
			create writing_fd_set.make
		end


feature -- Status

	is_interrupted: BOOLEAN
			-- Was `execute' interrupted?

	is_valid_descriptor_set (a_set: DS_SET [ABSTRACT_DESCRIPTOR]): BOOLEAN is
			-- Does `a_set' contain only valid descriptors so it can be
			-- used in `execute'?
		local
			c: DS_LINEAR_CURSOR [ABSTRACT_DESCRIPTOR]
		do
			Result := a_set /= Void and then a_set.count < maximum_descriptors
			if Result then
				c := a_set.new_cursor
				from
					c.start
				until
					not Result or else
					c.after
				loop
					-- Assume all three fd_sets are the same, which they
					-- should be, so it doesn't matter which
					-- `is_valid_descriptor' routine call.
					Result := reading_fd_set.is_valid_descriptor (c.item)
					c.forth
				end
			end
		end


feature -- Change

	set_timeout (a_timeout: EPX_TIME_VALUE) is
			-- Set `timeout'. Pass Void to wait infinitely.
		do
			timeout := a_timeout
		ensure
			time_set: timeout = a_timeout
		end


feature -- Access

	check_for_exception_conditions: DS_SET [ABSTRACT_DESCRIPTOR]
			-- Descriptors to be checked for a pending exception condition

	check_for_reading: DS_SET [ABSTRACT_DESCRIPTOR]
			-- Descriptors to be checked if they are ready for reading

	check_for_writing: DS_SET [ABSTRACT_DESCRIPTOR]
			-- Descriptors to be checked if they are ready for writing

	exception_conditions: DS_SET [ABSTRACT_DESCRIPTOR]
			-- Descriptors with a pending exception condition; set by
			-- `execute'. The definition of exception condition depends
			-- on the descriptor type. For sockets it is out-of-band data
			-- for example.

	maximum_descriptors: INTEGER is
			-- The maximum descriptors that can be checked at a given
			-- time. Recompile the eposix C binding library if you
			-- want to change this value.
		do
			Result := abstract_api.FD_SETSIZE
		ensure
			definition: Result = abstract_api.FD_SETSIZE
		end

	timeout: EPX_TIME_VALUE
			-- Time to wait in `execute' for any of the descriptors to be
			-- ready; if Void, wait indefinitely; if 0, poll only.

	ready_descriptors: INTEGER
			-- Number of ready descriptors, set by `execute'
			-- It is -1 if `execute' was interrupted or if there was an error.

	ready_for_reading: DS_SET [ABSTRACT_DESCRIPTOR]
			-- Descriptors to be checked if they are ready for reading

	ready_for_writing: DS_SET [ABSTRACT_DESCRIPTOR]
			-- Descriptors to be checked if they are ready for writing


feature -- Check for readiness

	execute is
			-- Test all descriptors set in the `check_for_XXXX' sets and
			-- put the descriptors that were set into
			-- `exception_conditions', `ready_for_reading' and
			-- `ready_for_writing'.
			-- There must be at least one descriptor (Windows requirement).
			-- If
		require
			check_for_reading_descriptors_less_than_limit:
				is_valid_descriptor_set (check_for_reading)
			check_for_writing_descriptors_less_than_limit:
				is_valid_descriptor_set (check_for_writing)
			exception_conditions_descriptors_less_than_limit:
				is_valid_descriptor_set (check_for_exception_conditions)
			at_least_one_descriptor:
				not check_for_reading.is_empty or else
				not check_for_writing.is_empty or else
				not check_for_exception_conditions.is_empty
		local
			timeout_ptr: POINTER
			exceptions_ptr,
			read_ptr,
			write_ptr: POINTER
			highest_fd: INTEGER
			new_highest_fd: INTEGER
		do
			if timeout /= Void then
				timeout_ptr := timeout.handle
			end
			highest_fd := -1

			-- Make exception conditions fd_set
			if not check_for_exception_conditions.is_empty then
				assign_to_fd_set (check_for_exception_conditions, exception_conditions_fd_set)
				new_highest_fd := exception_conditions_fd_set.highest_descriptor_value
				if new_highest_fd > highest_fd then
					highest_fd := new_highest_fd
				end
				exceptions_ptr := exception_conditions_fd_set.handle
			else
				exception_conditions.wipe_out
			end

			-- Make reading fd_set
			if not check_for_reading.is_empty then
				assign_to_fd_set (check_for_reading, reading_fd_set)
				new_highest_fd := reading_fd_set.highest_descriptor_value
				if new_highest_fd > highest_fd then
					highest_fd := new_highest_fd
				end
				read_ptr := reading_fd_set.handle
			else
				ready_for_reading.wipe_out
			end

			-- Make writing fd_set
			if not check_for_writing.is_empty then
				assign_to_fd_set (check_for_writing, writing_fd_set)
				new_highest_fd := writing_fd_set.highest_descriptor_value
				if new_highest_fd > highest_fd then
					highest_fd := new_highest_fd
				end
				write_ptr := writing_fd_set.handle
			else
				ready_for_writing.wipe_out
			end

				check
					got_highest_fd:
						highest_fd >= exception_conditions_fd_set.highest_descriptor_value and
						highest_fd >= reading_fd_set.highest_descriptor_value and
						highest_fd >= writing_fd_set.highest_descriptor_value
				end

			ready_descriptors := abstract_select (highest_fd + 1, read_ptr, write_ptr, exceptions_ptr, timeout_ptr)
			if ready_descriptors = -1 then
				-- Being interrupted is not an error, but a feature.
				if errno.value /= EINTR then
					is_interrupted := False
					raise_posix_error
				else
					is_interrupted := True
				end
			else
				is_interrupted := False
				-- Copy fd_sets to Eiffel friendly structures
				if not check_for_exception_conditions.is_empty then
					assign_from_fd_set (exception_conditions_fd_set, check_for_exception_conditions, exception_conditions)
				end
				if not check_for_reading.is_empty then
					assign_from_fd_set (reading_fd_set, check_for_reading, ready_for_reading)
				end
				if not check_for_writing.is_empty then
					assign_from_fd_set (writing_fd_set, check_for_writing, ready_for_writing)
				end
			end
		ensure
			nothing_ready_when_interrupted:
				is_interrupted implies
					ready_for_reading.is_empty and
					ready_for_writing.is_empty and
					exception_conditions.is_empty
			descriptors_add_up:
				not is_interrupted implies
					ready_descriptors = (ready_for_reading.count + ready_for_writing.count + exception_conditions.count)
		end


feature {NONE} -- Implementation

	assign_from_fd_set (a_from_set: EPX_DESCRIPTOR_SET; checked_set: DS_SET [ABSTRACT_DESCRIPTOR]; a_to_set: DS_SET [ABSTRACT_DESCRIPTOR]) is
			-- Make sure `a_to_set' contains only the descriptors in
			-- `a_from_set'.
		require
			a_from_set_not_void: a_from_set /= Void
			a_to_set_not_void: a_to_set /= Void
		local
			item: ABSTRACT_DESCRIPTOR
		do
			a_to_set.wipe_out
			from
				checked_set.start
			until
				checked_set.after
			loop
				item := checked_set.item_for_iteration
				if a_from_set.is_set (item) then
					a_to_set.put_last (item)
				end
				checked_set.forth
			end
		end

	assign_to_fd_set (a_from_set: DS_SET [ABSTRACT_DESCRIPTOR]; a_to_set: EPX_DESCRIPTOR_SET) is
			-- Make sure `a_to_set' contains only the descriptors in
			-- `a_from_set'.
		require
			valid_from_set: is_valid_descriptor_set (a_from_set)
			a_to_set_not_void: a_to_set /= Void
		local
			item: ABSTRACT_DESCRIPTOR
		do
			a_to_set.wipe_out
			from
				a_from_set.start
			until
				a_from_set.after
			loop
				item := a_from_set.item_for_iteration
				if a_to_set.is_valid_descriptor (item) then
					a_to_set.put (item)
				end
				a_from_set.forth
			end
		end

	exception_conditions_fd_set,
	reading_fd_set,
	writing_fd_set: EPX_DESCRIPTOR_SET
			-- fd_set structures used in `execute'


feature {NONE} -- Abstract API

	abstract_select (a_maxfdp1: INTEGER; a_readset, a_writeset, an_exceptset: POINTER; a_timeout: POINTER): INTEGER is
			-- Wait for a number of descriptors to change status.
			-- `a_maxfdp`' is the highest-numbered descriptor in any of
			-- the three sets, plus 1.
			-- At least one of the sets must be set (Windows requirement).
			-- If `a_timeout' is 0, function returns immediately (polling).
			-- If `a_timeout' is `default_pointer' function can block
			-- indefinitely.
			-- Returns -1 on error or else the number of descriptors that
			-- are ready.
		require
			a_maxfdp1_not_negative: a_maxfdp1 >= 0
			not_all_three_sets_are_null: a_readset /= default_pointer or else a_writeset /= default_pointer or else an_exceptset /= default_pointer
		deferred
		ensure
			-- Result = -1 implies errno.is_not_ok
		end


invariant

	exception_conditions_not_void: exception_conditions /= Void
	ready_for_reading_not_void: ready_for_reading /= Void
	ready_for_writing_not_void: ready_for_writing /= Void

	exception_conditions_fd_set_not_void: exception_conditions_fd_set /= Void
	reading_fd_set: reading_fd_set /= Void
	writing_fd_set: writing_fd_set /= Void

	valid_read_descriptors: ready_descriptors >= -1

end
