note

	description: "Class that gets Single Unix Spec stat structure through%
	%stat call."

	author: "Berend de Boer"

class

	SUS_STATUS_PATH


inherit

	SUS_STATUS

	POSIX_STATUS_PATH


create {SUS_FILE_SYSTEM}

	make,
	make_may_fail


end
