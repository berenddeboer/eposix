note

	description: "eposix default service launcher."

class

	WSF_DEFAULT_SERVICE_LAUNCHER [G -> WSF_EXECUTION create make end]

inherit

	EPX_WSF_FASTCGI_SERVICE_LAUNCHER [G]

create

	make,
	make_and_launch

end
