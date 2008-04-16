indexing

	description:

		"Windows.h routines that are made available after the _WIN32_WINNT macro has been set to 0x0500 or higher."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #2 $"


class

	WAPI_WINDOWS5


feature -- Jobs

	posix_createjobobject (lpJobAttributes, lpName: POINTER): INTEGER is
			-- Create or opens a job object.
		external "C"
		end



end
