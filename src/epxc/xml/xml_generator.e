indexing

	description: "Class that generates an XML string."

	notes: "This is not DOM, but a kind of streaming XML generation."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	XML_GENERATOR

obsolete "Class was renamed to EPX_XML_WRITER."

inherit

	EPX_XML_WRITER

create

	make,
	make_with_capacity,
	make_fragment,
	make_fragment_with_capacity

end
