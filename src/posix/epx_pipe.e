indexing

	description: "portable layer Windows pipe implementation."

	author: "Berend de Boer"
	date: "$Date: 2005/02/10 $"
	revision: "$Revision: #5 $"


class

	EPX_PIPE


inherit

	ABSTRACT_PIPE

	PAPI_UNISTD


feature -- Initialization

	make is
			-- Create pipe.
		local
			fildes: STDC_BUFFER
		do
			-- let's hope the size of our integers match with the C: int fildes[2]
			create fildes.allocate_and_clear (2 * 4)
			safe_call (posix_pipe (fildes.ptr))
			create {POSIX_FILE_DESCRIPTOR} fdin.attach_to_fd (fildes.peek_integer (0), True)
			create {POSIX_FILE_DESCRIPTOR} fdout.attach_to_fd (fildes.peek_integer (4), True)
			fildes.deallocate
		end



end
