indexing

	description: "Base class that covers the memory map routines that are %
	%portable between POSIX and Windows.%
	%Basically, a memory map is a specialized STDC_BUFFER. Its memory can be%
	%shared among multiple processes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	ABSTRACT_MEMORY_MAP

inherit

	STDC_BUFFER
		export
			{NONE} allocate, allocate_and_clear, make_from_pointer, resize, deallocate, detach
		end

feature -- Unmap

	close is
			-- Remove the mapping.
		require
			open: is_open
		do
			detach
		ensure
			closed: not is_open
		end


feature -- Queries

	is_open: BOOLEAN is
			-- Is the memory mapped
		do
			Result := ptr /= default_pointer
		end

invariant

	size_positive: is_open implies capacity > 0

	ptr_valid: is_open implies ptr /= default_pointer and not is_open implies ptr = default_pointer

end
