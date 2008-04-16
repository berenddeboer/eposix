indexing

	description: "POSIX child processes created by call to exec."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #3 $"


class

	POSIX_EXEC_PROCESS


inherit

	EPX_EXEC_PROCESS
		export
			{ANY} stdin, stdout, stderr
		end


creation

	make,
	make_capture_input,
	make_capture_output,
	make_capture_io,
	make_capture_all


end
