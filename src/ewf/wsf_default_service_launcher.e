note

	description: "eposix default service launcher."

class

	WSF_DEFAULT_SERVICE_LAUNCHER

inherit

	EPX_WSF_FASTCGI_SERVICE_LAUNCHER

create
	make,
	make_and_launch,
	make_callback,
	make_callback_and_launch,
	make_and_launch_service -- obsolete

end
