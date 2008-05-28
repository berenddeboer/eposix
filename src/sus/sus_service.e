indexing

	description: "Class that describes service names, i.e. an entry %
	%in /etc/services."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	SUS_SERVICE


inherit

	SUS_BASE

	EPX_SERVICE


create

	make_from_name,
	make_from_port


end
