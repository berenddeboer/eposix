indexing

	description:

		"Describes NT security descriptor"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	WINDOWS_SECURITY_DESCRIPTOR


inherit

	WINDOWS_BASE

	WAPI_WINDOWS


create

	make


feature {NONE} -- Initialization

	make is
			-- Initializes a security descriptor to have no SACL, no
			-- DACL, no owner, no primary group, and all control flags
			-- set to FALSE (NULL). Thus, except for its revision level,
			-- it is empty.
		do
			create psd.allocate (posix_security_descriptor_size)
			safe_win_call (posix_initializesecuritydescriptor (psd.ptr, SECURITY_DESCRIPTOR_REVISION))
		end


feature -- Access

	ptr: POINTER is
			-- Pointer to allocated memory block
		do
			Result := psd.ptr
		ensure
			ptr_not_nil: Result /= default_pointer
		end


feature -- Change

	allow_access_to_everyone is
			-- Create a DACL that allows access to everyone.
		do
			safe_win_call (posix_setsecuritydescriptordacl(
				psd.ptr, -- address of security
				True, -- flag for presence of discretionary ACL
				default_pointer, -- discretionary ACL of NULL gives everyone access
				False  -- flag for default discretionary ACL
				))
		end


feature {NONE} -- Implementation

	psd: STDC_BUFFER


invariant

	have_psd: psd /= Void

end
