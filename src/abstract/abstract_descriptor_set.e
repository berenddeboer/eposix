note

	description: "Abstraction for the descriptor sets used by the select() call."

	library: "eposix"
	author: "Berend de Boer"


deferred class

	ABSTRACT_DESCRIPTOR_SET


inherit

	ABSTRACT_NET_BASE


feature {NONE} -- Initialization

	make
		do
			create fd_set.allocate (abstract_api.posix_fd_set_size)
			wipe_out
		end


feature -- Status

	is_set (a_descriptor: ABSTRACT_DESCRIPTOR): BOOLEAN
			-- Is `a_descriptor' included in this set?
		require
			valid_descriptor: is_valid_descriptor (a_descriptor)
		do
			Result := abstract_api.posix_fd_isset (a_descriptor.fd, fd_set.ptr)
		end

	is_valid_descriptor (a_descriptor: ABSTRACT_DESCRIPTOR): BOOLEAN
			-- Is `a_descriptor' a descriptor that can be added or
			-- removed from this set, or checked for its presence?
			-- Precondition depends on platform, but for all platforms
			-- `a_descriptor' must be open.
		deferred
		end


feature -- Access

	handle: POINTER
			-- Memory area where descriptor bits are stored
		do
			Result := fd_set.handle
		ensure
			handle_not_nil: Result /= default_pointer
		end

	highest_descriptor_value: INTEGER
			-- Highest descriptor value seen by `put'; it is not updated
			-- when `remove' is called, so it might not optimal.


feature -- Change

	put (a_descriptor: ABSTRACT_DESCRIPTOR)
			-- Add `a_descriptor' to this set.
		require
			valid_descriptor: is_valid_descriptor (a_descriptor)
		do
			abstract_api.posix_fd_set (a_descriptor.fd, fd_set.ptr)
			highest_descriptor_value := highest_descriptor_value.max (a_descriptor.fd)
		ensure
			set: is_set (a_descriptor)
			highest_descriptor_value_updated: highest_descriptor_value >= a_descriptor.fd
		end

	remove (a_descriptor: ABSTRACT_DESCRIPTOR)
			-- Remove `a_descriptor' from this set.
		require
			valid_descriptor: is_valid_descriptor (a_descriptor)
		do
			abstract_api.posix_fd_clr (a_descriptor.fd, fd_set.ptr)
		ensure
			unset: not is_set (a_descriptor)
		end

	wipe_out
			-- Remove all descriptors such that `is_set' returns False
			-- for every descriptor.
		do
			abstract_api.posix_fd_zero (fd_set.ptr)
		end


feature {NONE} -- Implementation

	fd_set: STDC_BUFFER
			-- The buffer that holds the file descriptors


invariant

	fd_set_not_void: fd_set /= Void
	highest_descriptor_value_not_negative: highest_descriptor_value >= 0

end
