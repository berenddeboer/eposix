indexing

	description: "Class that covers Standard C dynamic memory routines."

	warning: "This class is obsolete. Use STDC_BUFFER instead."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	STDC_DYNAMIC_MEMORY

obsolete "Use STDC_BUFFER instead."

inherit

	STDC_BUFFER


create

	allocate,
	allocate_and_clear,
	make_from_pointer


end -- class STDC_DYNAMIC_MEMORY
