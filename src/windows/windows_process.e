indexing

	description: "Class that covers MS Windows process related routines."

	author: "Berend de Boer"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #5 $"


deferred class

	WINDOWS_PROCESS


inherit

	ABSTRACT_PROCESS
		undefine
			raise_posix_error
		end

	WINDOWS_BASE


feature -- Signal this process

	Terminate_exit_code: INTEGER is 1


end
