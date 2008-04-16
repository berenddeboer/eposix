indexing

	description: "Class that covers the POSIX stream code."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $";
	revision: "$Revision: #8 $"

deferred class

	POSIX_FILE


inherit

	STDC_FILE

	POSIX_BASE

	PAPI_STDIO


feature  -- special makes

	make_from_file_descriptor (
			a_file_descriptor: ABSTRACT_FILE_DESCRIPTOR;
			a_mode: STRING) is
			-- Open a stream from a given file descriptor.
			-- The stream will become leading so when the file
			-- descriptor is closed, it will not close, you have to close
			-- the stream to close the file descriptor.
			-- The stream will also inherit the error handling setting
			-- of `a_file_descriptor'.
		require
			is_closed: not is_open
			valid_fildes:
				a_file_descriptor /= Void and then
				a_file_descriptor.is_open
			valid_mode: True -- `a_mode' is a valid posix mode
		local
			cmode: POINTER
			a_stream: like stream
		do
			do_make
			inherit_error_handling (a_file_descriptor)
			cmode := sh.string_to_pointer (a_mode)
			a_stream := posix_fdopen (a_file_descriptor.value, cmode)
			sh.unfreeze_all
			if a_stream = default_pointer then
				raise_posix_error
			else
				mode := a_mode
				capacity := 1
				set_handle (a_stream, True)
				if a_file_descriptor.is_owner then
					a_file_descriptor.unown
				end
				is_open_read := True
				is_open_write:= True
			end
		ensure
			opened:
				raise_exception_on_error implies is_open
			can_read:
				raise_exception_on_error implies is_open_read
			can_write:
				raise_exception_on_error implies is_open_write
			owner:
				raise_exception_on_error implies is_owner
			stream_is_leading:
				raise_exception_on_error implies
					not a_file_descriptor.is_owner
			open_files_unchanged:
				security.files.is_open_files_increased (False, old security.files.open_files)
		end


end
