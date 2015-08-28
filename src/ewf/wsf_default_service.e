note
	description: "Service using default connector launcher: eposix fastcgi"

deferred class

	WSF_DEFAULT_SERVICE [G -> WSF_EXECUTION create make end]

inherit

	WSF_DEFAULT_SERVICE_I [WSF_DEFAULT_SERVICE_LAUNCHER [G]]

end
