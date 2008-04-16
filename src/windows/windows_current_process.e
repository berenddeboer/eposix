indexing

	description: "Class that covers Windows current process related routines."
	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #4 $"


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
