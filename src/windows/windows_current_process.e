indexing

	description: "Class that covers Windows current process related routines."
	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	WINDOWS_CURRENT_PROCESS


inherit

	EPX_CURRENT_PROCESS


feature -- Access

	current_process: INTEGER is
			-- Pseudo handle to represent the current process
		do
			Result := posix_getcurrentprocess
		end


end
