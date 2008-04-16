indexing

	description: "Class that covers a Standard C file position."

	usage: "Only through STDC_FILE.get_position and set_position."

	author: "Berend de Boer"
	date: "$Date: 2004/01/06 $"
	revision: "$Revision: #3 $"

class

	STDC_FILE_POSITION


inherit

	CAPI_STDIO


creation {STDC_FILE}

	make


feature {NONE} -- Initialization

	make is
		do
			create buf.allocate (posix_fpos_t_size)
		end


feature {STDC_FILE} -- Access

	buf: STDC_BUFFER
			-- Actual file position


invariant

	buf_not_void: buf /= Void

end
