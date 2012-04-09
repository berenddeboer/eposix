note

	description: "[
			Component to launch the service using the default connector

					libFCGI for this class

			How-to:

				s: WSF_DEFAULT_SERVICE_LAUNCHER
				create s.make_and_launch (agent execute)

				execute (req: WSF_REQUEST; res: WSF_RESPONSE)
					do
						-- ...
					end
		]"


class

	EPX_WSF_FASTCGI_SERVICE_LAUNCHER


inherit

	WSF_SERVICE_LAUNCHER
		rename
			make as make_service,
			make_and_launch as make_and_launch_service,
			make_and_launch_with_options as make_and_launch_service_with_options,
			options as unsupported_string_options
		end


inherit {NONE}

	EPX_WGI_FASTCGI_CONNECTOR_OPTIONS


create
	make,
	make_and_launch,
	make_callback,
	make_callback_and_launch

feature {NONE} -- Initialization

	make (a_service: like service; a_callback: like {WSF_CALLBACK_SERVICE}.callback; an_options: like options)
		require
			a_options_attached: an_options /= Void
			signal_handler_attached: an_options.terminate_signal /= Void
			callback_not_void: a_callback /= Void
		do
			options := an_options
			make_service (a_service, Void)
		end

	make_and_launch (a_service: like service; a_callback: like {WSF_CALLBACK_SERVICE}.callback)
		do
			make (a_service, a_callback, Void)
			launch
		end

	make_and_launch_with_options (a_service: like service; a_callback: like {WSF_CALLBACK_SERVICE}.callback; an_options: attached like options)
		require
			a_options_attached: an_options /= Void
			signal_handler_attached: an_options.terminate_signal /= Void
		do
			make (a_service, a_callback, an_options)
			launch
		end

	initialize
		do
			if options = Void then
				create options
				options.port := 9000
			end
			create connector.make (Current, options)
		end


feature -- Access

	connector: detachable EPX_WGI_FASTCGI_CONNECTOR
			-- Default service name

	options: like options_template
			-- Custom options


feature -- Execution

	launch
		do
			if attached connector as conn then
				conn.launch
			end
		end

end
