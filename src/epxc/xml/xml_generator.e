indexing

	description: "Class that generates an XML string."

	notes: "This is not DOM, but a kind of streaming XML generation."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #1 $"

class

	XML_GENERATOR

obsolete "Class was renamed to EPX_XML_WRITER."

inherit

	EPX_XML_WRITER

creation

	make,
	make_with_capacity,
	make_fragment,
	make_fragment_with_capacity

end
