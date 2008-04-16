indexing

	description: "Class that covers Windows file system code."

	author: "Berend de Boer"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #3 $"

class

	WINDOWS_FILE_SYSTEM


inherit

	WINDOWS_BASE

	EPX_FILE_SYSTEM

	KL_IMPORTED_INTEGER_ROUTINES
		export
			{NONE} all
		end


feature -- windows drive letters...

	current_drive: CHARACTER is
			-- return a drive letter like A or C
		local
			r: INTEGER
		do
			-- drive letters range from 1 to 26
			-- Ord('A') = 65
			r := 64 + posix_getdrive
			Result := INTEGER_.to_character (r)
		end


end
