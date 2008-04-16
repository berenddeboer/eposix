indexing

	description: "Class that covers MS Windows process related routines."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


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
