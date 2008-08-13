indexing

	description:
		"Describes memory related security."

	usage: "Inherit from STDC_SECURITY_ACCESSOR."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	STDC_SECURITY_MEMORY


inherit

	STDC_SECURITY_ASPECT


create

	make


feature -- creation

	make is
			-- allow everything
		do
			max_allocated_memory := Max_Int
			max_single_allocation := Max_Int
		end


feature -- parameters

	allocated_memory: INTEGER is
			-- The amount of memory that is currently allocated. This
			-- object only tracks memory allocated by STDC_BUFFER.
		external "C"
		alias "posix_allocated_memory"
		end

	max_allocated_memory: INTEGER
			-- maximum allowed memory allocation in bytes

	max_single_allocation: INTEGER
			-- maximum allowed single memory block in bytes


feature {STDC_SECURITY_ACCESSOR} -- Set parameters

	set_max_allocated_memory (value: INTEGER) is
		require
			value_not_negative: value >= 0
		do
			max_allocated_memory := value
			check_max_allocation
		ensure
			maximum_set: max_allocated_memory = value
			maximum_not_exceeded: max_allocated_memory >= allocated_memory
		end

	set_max_single_allocation (value: INTEGER) is
		require
			value_not_negative: value >= 0
		do
			max_single_allocation := value
		ensure
			maximum_set: max_single_allocation = value
		end


feature {STDC_SECURITY_ACCESSOR} -- Count resource usage

	decrease_allocated_memory (amount: INTEGER) is
			-- Decrement record of memory allocated. Should be called
			-- AFTER memory has been released.
		require
			amount_not_negative: amount >= 0
		external "C"
		alias "posix_decrease_allocated_memory"
		ensure
			memory_decreased: allocated_memory = old allocated_memory - amount
		end

	increase_memory_allocation (amount: INTEGER) is
			-- Increment record of memory allocated. Should be called
			-- AFTER the fact.
		require
			amount_not_negative: amount >= 0
		do
			posix_increase_allocated_memory (amount)
			check_max_allocation
		ensure
			maximum_not_exceeded: max_allocated_memory >= allocated_memory
			allocated_memory_increased: allocated_memory = old allocated_memory + amount
		end


feature {NONE} -- Implementation

	memory: MEMORY is
			-- Ensuring that resource counting is correct, works only
			-- when garbage collector doesn't kick in to dispose handles.
			-- Need to test if garbage collector enabled or not.
		once
			create Result
		end

	posix_increase_allocated_memory (amount: INTEGER) is
		require
			amount_not_negative: amount >= 0
		external "C"
		ensure
			allocated_memory_increased: allocated_memory = old allocated_memory + amount
		end


feature -- Checks

	is_allocated_memory_increased (should_increase: BOOLEAN; old_allocated_memory, a_capacity: INTEGER): BOOLEAN is
			-- Is `allocated_memory' correctly incremented depending on
			-- `should_increase' given old `allocated_memory'?
			-- Routine to be used in postconditions.
		require
			old_allocated_memory_not_negative: old_allocated_memory >= 0
			capacity_not_negative: a_capacity >= 0
		do
			Result :=
				memory.collecting or else
				((should_increase implies
				  allocated_memory = old_allocated_memory + a_capacity) and then
				 (not should_increase implies
				  allocated_memory = old_allocated_memory))
		ensure
			no_test_when_gc_enabled: memory.collecting implies Result
		end

	is_allowed_allocation (amount: INTEGER): BOOLEAN is
			-- May application allocate memory blocks the size of `amount'.
		require
			amount_not_negative: amount >= 0
		do
			Result := amount <= max_single_allocation
		end

	is_within_maximum (amount: INTEGER): BOOLEAN is
			-- Does allocation of `amount' not exceed set limits?
		require
			amount_not_negative: amount >= 0
		do
			Result := allocated_memory + amount < max_allocated_memory
		end

	check_allocation (amount: INTEGER) is
			-- Test if application may allocate a memory block of `amount' bytes.
		require
			amount_not_negative: amount >= 0
		do
			if not is_allowed_allocation (amount) then
				raise_security_error ("Cannot allocate " + amount.out +
											 " memory. Maximum allowed is " +
											 max_single_allocation.out + ".%N")
			end
		end

	check_max_allocation is
			-- Test if we are still within the set memory limits.
		do
			if allocated_memory > max_allocated_memory then
				raise_security_error ("Maximum allowed memory allocation exceeded.%N")
			end
		ensure
			maximum_not_exceeded: max_allocated_memory >= allocated_memory
		end


invariant

	positive_allocated_memory: allocated_memory >= 0
	positive_max_allocated_memory: max_allocated_memory >= 0
	positive_max_single_allocation: max_single_allocation >= 0

end
