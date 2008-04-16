indexing

	description: "Class that covers the pipe abstractions."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	ABSTRACT_PIPE

inherit

	STDC_BASE


feature -- Pipe operations

	close is
		do
			if fdout.is_owner then
				fdout.close
			end
			if fdin.is_owner then
				fdin.close
			end
		end


feature -- Access

	fdout: ABSTRACT_FILE_DESCRIPTOR
			-- Outgoing end of pipe

	fdin: ABSTRACT_FILE_DESCRIPTOR
			-- Incoming end of pipe


invariant

	valid_pipe: fdin /= Void and fdout /= Void

end
