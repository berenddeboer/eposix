note

	description: "Describes Windows PROCESS_INFORMATION struct."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	WINDOWS_PROCESS_INFORMATION


inherit

	WINDOWS_BASE

	WAPI_WINDOWS


create

	make


feature -- creation

	make
		do
			create ppi.allocate_and_clear (posix_process_information_size)
		end


feature -- state

	pid: INTEGER
		do
			Result := posix_process_information_dwprocessid (ptr)
		end

	dwProcessId: INTEGER
		obsolete "Use pid instead."
		do
			Result := pid
		end

	process_handle: INTEGER
		do
			Result := posix_process_information_hprocess (ptr)
		end

	hProcess: INTEGER
		obsolete "Use process_handle instead."
		do
			Result := process_handle
		end

	thread_handle: INTEGER
		do
			Result := posix_process_information_hthread (ptr)
		end

	hThread: INTEGER
		obsolete "Use thread_handle instead."
		do
			Result := thread_handle
		end


feature -- Pointer to state

	ptr: POINTER
			-- Pointer to the process struct.
		do
			Result := ppi.ptr
		end


feature {NONE} -- Private state

	ppi: STDC_BUFFER


invariant

	have_ppi: ppi /= Void

end
