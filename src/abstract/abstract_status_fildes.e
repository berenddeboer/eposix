indexing

	description: "Class that gets stat structure through fstat call."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	ABSTRACT_STATUS_FILDES


inherit

	ABSTRACT_STATUS


feature {ABSTRACT_FILE_DESCRIPTOR} -- creation

	make (a_fd: ABSTRACT_FILE_DESCRIPTOR) is
		require
			open_file_descriptor: a_fd.is_open
		do
			make_stat
			fd := a_fd
			refresh
		end


feature -- Status

	is_open: BOOLEAN is
			-- Can status be refreshed?
		do
			Result := fd.is_open
		end


feature -- Change

	refresh is
			-- Refresh the cached status information.
		do
			safe_call (abstract_fstat (fd.value, stat.ptr))
		end


feature -- state

	fd: ABSTRACT_FILE_DESCRIPTOR



feature {NONE} -- abstract API

	abstract_fstat (fildes: INTEGER; a_stat: POINTER): INTEGER is
			-- Gets file status
		require
			valid_stat_buffer: a_stat /= default_pointer
		deferred
		ensure
			-- Result = -1 implies errno.is_not_ok
		end


invariant

	valid_fd: fd /= Void


end -- class ABSTRACT_STATUS_FILDES
