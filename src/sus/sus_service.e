indexing

	description: "Class that describes service names, i.e. an entry %
	%in /etc/services."

	author: "Berend de Boer"
	date: "$Date: 2003/03/20 $"
	revision: "$Revision: #4 $"


class

	SUS_SERVICE


inherit

	SUS_BASE

	EPX_SERVICE


creation

	make_from_name,
	make_from_port


end
