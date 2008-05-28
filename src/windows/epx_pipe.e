indexing

	description: "portable layer Windows pipe implementation."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_PIPE


inherit

	ABSTRACT_PIPE
		undefine
			raise_posix_error
		end

	WINDOWS_BASE


create

	make


feature -- Initialization

	make is
			-- Create pipe
		do
			safe_win_call (posix_createpipe ($hread, $hwrite, default_pointer, 0))
			set_file_descriptors
		end


feature {NONE} -- set file descriptor

	set_file_descriptors is
		do
			create {WINDOWS_PIPE_DESCRIPTOR} fdin.attach_to_fd (hwrite, True)
			create {WINDOWS_PIPE_DESCRIPTOR} fdout.attach_to_fd (hread, True)
		end


feature {NONE} -- Implementation

	hread,
	hwrite: INTEGER
			-- Non-local variables needed for $ operator in SmallEiffel

end
