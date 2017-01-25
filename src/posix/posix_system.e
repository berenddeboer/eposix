note

	description: "Class that covers POSIX current system info related routines."
	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	POSIX_SYSTEM

inherit

	EPX_SYSTEM


feature -- Sysconf queries, run-time determined

	child_max: INTEGER
			-- The number of simultaneous processes per real user ID.
		do
			Result := posix_sc_child_max
		end

	clock_ticks: INTEGER
			-- The number of clock ticks per second.
		do
			Result := posix_sc_clk_tck
		end

	has_job_control: BOOLEAN
			-- Job control functions are supported.
		do
			Result := posix_sc_job_control /= 0
		end

	has_saved_ids: BOOLEAN
			-- Each process has a saved set-user-ID and a saved set-group-ID.
		do
			Result := posix_sc_saved_ids /= 0
		end

	ngroups_max: INTEGER
			-- The number of simultaneous supplementary group IDs.
		do
			Result := posix_sc_ngroups_max
		end

	page_size: INTEGER
			-- granularity in bytes of memory mapping and process memory locking.
		do
			Result := posix_sc_pagesize
		end

	posix_version: INTEGER
			-- Indicates the 4-digit year and 2-digit month that the
			-- standard was approved.
		do
			Result := posix_sc_version
		end


feature -- Compile-time determined queries

	supports_asynchronous_io: BOOLEAN
			-- True if the message passing API is supported.
		do
			Result := posix_asynchronous_io
		end

	supports_file_synchronization: BOOLEAN
			-- True if file synchronization is supported.
		do
			Result := def_fsync
		end

	supports_memory_mapped_files: BOOLEAN
			-- True if memory mapped files are supported.
		do
			Result := posix_mapped_files
		end

	supports_memory_locking: BOOLEAN
			-- True if memory locking is supported.
		do
			Result := posix_memlock
		end

	supports_memlock_range: BOOLEAN
			-- True if memory range locking is supported.
		do
			Result := posix_memlock_range
		end

	supports_memory_protection: BOOLEAN
			-- True if memory protection is supported.
		do
			Result := posix_memory_protection
		end

	supports_message_passing: BOOLEAN
			-- True if the message passing API is supported.
		do
			Result := posix_message_passing
		end

	supports_priority_scheduling: BOOLEAN
			-- True if priority scheduling is supported.
		do
			Result := posix_priority_scheduling
		end

	supports_semaphores: BOOLEAN
			-- True if semaphores are supported.
		do
			Result := posix_semaphores
		end

	supports_shared_memory_objects: BOOLEAN
			-- True if shared memory objects are supported.
		do
			Result := posix_shared_memory_objects
		end

	supports_synchronized_io: BOOLEAN
			-- True if synchronized io is supported.
		do
			Result := def_synchronized_io
		end

	supports_timers: BOOLEAN
			-- True if timers are supported.
		do
			Result := posix_timers
		end

	supports_threads: BOOLEAN
			-- True if thread are supported.
		do
			Result := posix_threads
		end


end
