note

	description: "Class that describes service names, i.e. an entry %
	%in /etc/services."

	author: "Berend de Boer"


class

	SUS_SERVICE


inherit

	SUS_BASE

	EPX_SERVICE


create

	make_from_name,
	make_from_port


end
