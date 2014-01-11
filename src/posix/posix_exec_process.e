note

	description: "POSIX child processes created by call to exec."

	author: "Berend de Boer"


class

	POSIX_EXEC_PROCESS


inherit

	EPX_EXEC_PROCESS
		export
			{ANY} stdin, stdout, stderr
		end


create

	make,
	make_capture_input,
	make_capture_output,
	make_capture_io,
	make_capture_all,
	make_from_command_line


end
