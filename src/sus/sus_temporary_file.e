indexing

	description:

		"Unlike STDC_TEMPORARY_FILE, this class creates a temporary file given a template for the filename. The file is also not automatically removed."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	SUS_TEMPORARY_FILE


inherit

	SUS_FILE_DESCRIPTOR
		rename
			make as make_file_descriptor
		end

	SAPI_STDLIB
		export
			{NONE} all
		end


creation

	make


feature {NONE} -- Initialization

	make (a_template: STRING) is
			-- Create a temporary file with the filename based on the
			-- template `a_template'.
		require
			last_six_characters_are_XXXXXX: a_template.count >= 6 and then STRING_.same_string (a_template.substring (a_template.count - 5, a_template.count), "XXXXXX")
		local
			a_descriptor: like fd
		do
			do_make
			name.make_from_string (a_template)
			a_descriptor := posix_mkstemp (sh.string_to_pointer (name))
			sh.unfreeze_all
			if a_descriptor = -1 then
				raise_posix_error
			else
				capacity := 1
				set_handle (a_descriptor, True)
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
