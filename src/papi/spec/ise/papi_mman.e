indexing

	description: "Class that covers Posix mmap.h."

	author: "Berend de Boer"
	date: "$Date: 2007/05/18 $"
	revision: "$Revision: #1 $"

class

	PAPI_MMAN


feature -- C binding

	posix_mmap(addr: POINTER; len, prot, flags, fildes, off: INTEGER): POINTER is
			-- Map a file descriptor into memory
		require
			valid_len: len > 0
			offset_positive: off >= 0
			valid_fildes: fildes >= 0

		external "C blocking"



		end

	posix_munmap(addr: POINTER; len: INTEGER): INTEGER is
			-- Unmap previously mapped addresses

		external "C blocking"



		end


feature {NONE} -- shared memory

	posix_shm_open (a_name: POINTER; oflag, mode: INTEGER): INTEGER is
			-- Open a Shared Memory Object
		require
			valid_name: a_name /= default_pointer

		external "C blocking"



		end

	posix_shm_unlink (a_name: POINTER): INTEGER is
			-- Remove a shared memory object
		require
			valid_name: a_name /= default_pointer

		external "C blocking"



		end


feature -- private constants

	MAP_FAILED: POINTER is
			-- symbol MAP_FAILED
		external "C"
		alias "const_map_failed"
		end


feature -- protection constants

	PROT_READ: INTEGER is
		external "C"
		alias "const_prot_read"
		end

	PROT_WRITE: INTEGER is
		external "C"
		alias "const_prot_write"
		end

	PROT_EXEC: INTEGER is
		external "C"
		alias "const_prot_exec"
		end

	PROT_NONE: INTEGER is
		external "C"
		alias "const_prot_none"
		end


feature -- Sharing types

	MAP_SHARED: INTEGER is
			-- Changes are shared
		external "C"
		alias "const_map_shared"
		end

	MAP_PRIVATE: INTEGER is
			-- Changes are private
		external "C"
		alias "const_map_private"
		end

	MAP_FIXED: INTEGER is
		-- Interpret `addr' exactly
		external "C"
		alias "const_map_fixed"
		end


end -- class PAPI_MMAN
