indexing

	description: "Class that covers Standard C dynamic memory routines."

	warning: "This class is obsolete. Use STDC_BUFFER instead."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #2 $"

class

	STDC_DYNAMIC_MEMORY

obsolete "Use STDC_BUFFER instead."

inherit

	STDC_BUFFER


creation

	allocate,
	allocate_and_clear,
	make_from_pointer


end -- class STDC_DYNAMIC_MEMORY
