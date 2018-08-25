note

	description: "Class that covers Single Unix Spec file descriptor routines."

	author: "Berend de Boer"


class

	SUS_FILE_DESCRIPTOR


inherit

	SUS_BASE

	POSIX_FILE_DESCRIPTOR


create

	open,
	open_read,
	open_write,
	open_read_write,
	open_truncate,
	create_read_write,
	create_write,
	create_with_mode,
	make_as_duplicate,
	make_from_file,
	attach_to_fd


end
