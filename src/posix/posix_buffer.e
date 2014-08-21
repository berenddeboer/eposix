note

	description: "Class that covers Posix dynamic memory routines."

	author: "Berend de Boer"

class

	POSIX_BUFFER

inherit

	STDC_BUFFER

	POSIX_BASE
		undefine
			copy,
			is_equal
		end


create

	allocate,
	allocate_and_clear,
	make_from_pointer


end
