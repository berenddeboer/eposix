note

	description: "[
			Component to launch the service using the default connector

					EPX_WGI_FASTCGI_CONNECTOR for this class
		]"


class

	EPX_WSF_FASTCGI_SERVICE_LAUNCHER [G -> WSF_EXECUTION create make end]


inherit

	WSF_SERVICE_LAUNCHER [G]


inherit {NONE}

	EPX_WGI_FASTCGI_CONNECTOR_OPTIONS


create

	make,
	make_and_launch


feature {NONE} -- Initialization

	initialize
		local
			my_options: like options_template
		do
			create my_options
			if attached {INTEGER} options.option ("port") as port then
				my_options.port := port
			end
			if attached {STRING} options.option ("bind") as bind then
				my_options.bind := bind
			end
			if attached {EPX_KILL_SIGNAL_HANDLER} options.option ("terminate_signal") as terminate_signal then
				my_options.terminate_signal := terminate_signal
			end
			if attached {BOOLEAN} options.option ("no_fork") as no_fork then
				my_options.no_fork := no_fork
			end
			create connector.make (my_options)
		end


feature -- Execution

	launch
		do
			connector.launch
		end


feature -- Status report

	connector: EPX_WGI_FASTCGI_CONNECTOR [G]
			-- Default service name


end
