indexing

	description: "Class that covers a Standard C file position."

	usage: "Only through STDC_FILE.get_position and set_position."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	STDC_FILE_POSITION


inherit

	CAPI_STDIO


create {STDC_FILE}

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
