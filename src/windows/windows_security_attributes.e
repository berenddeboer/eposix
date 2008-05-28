indexing

	description: "Describes NT SECURITY_ATTRIBUTES struct."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	WINDOWS_SECURITY_ATTRIBUTES


inherit

	WINDOWS_BASE

	WAPI_WINDOWS


create

	make


feature {NONE} -- Initialiation

	make is
			-- Create default security attribute structure. Handle
			-- is not inherited and security descriptor is not set.
		do
			create psa.allocate_and_clear (posix_security_attributes_size)
			posix_set_security_attributes_nlength (ptr, posix_security_attributes_size)
		ensure
			not_inherited: not inherit_handle
			no_descriptor: security_descriptor = default_pointer
		end


feature -- Access

	inherit_handle: BOOLEAN is
		do
			Result := posix_security_attributes_binherithandle (ptr)
		end

	ptr: POINTER is
			-- Pointer to allocated memory block
		do
			Result := psa.ptr
		ensure
			ptr_not_nil: Result /= default_pointer
		end

	security_descriptor: POINTER is
			-- Security descriptor for an object, coctrolling how it is
			-- shared.
		do
			Result := posix_security_attributes_lpsecuritydescriptor (ptr)
		end


feature -- Change

	set_inherit_handle (value: BOOLEAN) is
		do
			posix_set_security_attributes_binherithandle (ptr, value)
		ensure
			inherit_handle_set: inherit_handle = value
		end

	set_security_descriptor (a_descriptor: WINDOWS_SECURITY_DESCRIPTOR) is
		do
			posix_set_security_attributes_lpsecuritydescriptor (ptr, a_descriptor.ptr)
		ensure
			descriptor_set: security_descriptor = a_descriptor.ptr
		end


feature {NONE} -- Implementation

	psa: STDC_BUFFER


invariant

	have_psa: psa /= Void

end
