indexing

	description: "Creates a temporary file that is removed when closed %
	%or when the program terminates. The file is anonymous, i.e. `name' does not have a value."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

class

	STDC_TEMPORARY_FILE


inherit

	STDC_BINARY_FILE
		rename
			make as old_make
		export
			{NONE} create_read_write, create_write, open, open_append, open_read, open_read_write, attach_to_stream, name, old_make
		end


create

	make


feature {NONE} -- Initialization

	make is
			-- Create an anonymous temporary file and open it.
			-- Up to TMP_MAX temporary files can be opened.  Eh, they
			-- say. Testing revealed that on Windows with BCC5.5 supplied
			-- with ISE Eiffel 5.3, the limit was 50 files open at a
			-- given time. This limit is defined in _nfile.h and the
			-- constant is _NFILE_.
			-- With Microsoft C the limit was 512 files. It is defined in
			-- STDIO.H and the constant is _NSTREAM_.
			-- With lcc the limit seems to be 40 files.
		local
			a_stream: like stream
		do
			do_make
			a_stream := posix_tmpfile
			if a_stream = default_pointer then
				raise_posix_error
			else
				capacity := 1
				set_handle (a_stream, True)
				is_open_write := True
				is_open_read := True
			end
		ensure
			file_is_open:
				raise_exception_on_error implies
					(is_open_read and is_open_write)
			owner_set: is_open implies is_owner
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

end
