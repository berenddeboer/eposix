indexing

	description: "Class that covers Windows pipe."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	WINDOWS_PIPE

inherit

	EPX_PIPE
		redefine
			fdin,
			fdout
		end


create

	make,
	make_inheritable_read,
	make_inheritable_write


feature -- creation

	make_inheritable_read is
			-- Creates a read pipe suitable to communicate with a child process.
		local
			sa: WINDOWS_SECURITY_ATTRIBUTES
			tmp_read: INTEGER
		do
			create sa.make
			sa.set_inherit_handle (True)
			safe_win_call (posix_createpipe ($hread, $hwrite, sa.ptr, 0))
			-- make sure our handle isn't inherited
			tmp_read := hread
			safe_win_call (posix_duplicatehandle (posix_getcurrentprocess, tmp_read, posix_getcurrentprocess, $hread, 0, False, DUPLICATE_SAME_ACCESS))
			safe_win_call (posix_closehandle (tmp_read))
			set_file_descriptors
		end

	make_inheritable_write is
			-- Creates a write pipe suitable to communicate with a child process.
		local
			sa: WINDOWS_SECURITY_ATTRIBUTES
			tmp_write: INTEGER
		do
			create sa.make
			sa.set_inherit_handle (True)
			safe_win_call (posix_createpipe ($hread, $hwrite, sa.ptr, 0))
			-- make sure our handle isn't inherited
			tmp_write := hwrite
			safe_win_call (posix_duplicatehandle (posix_getcurrentprocess, tmp_write, posix_getcurrentprocess, $hwrite, 0, False, DUPLICATE_SAME_ACCESS))
			safe_win_call (posix_closehandle (tmp_write))
			set_file_descriptors
		end


feature -- Access

	fdin: WINDOWS_FILE_DESCRIPTOR

	fdout: WINDOWS_FILE_DESCRIPTOR


end
