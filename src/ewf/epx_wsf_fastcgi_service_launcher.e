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
			make_callback as make_callback_service,
			make_callback_and_launch as make_callback_and_launch_service,
			options as unsupported_string_options
		redefine
			execute
		end


inherit {NONE}

	EPX_WGI_FASTCGI_CONNECTOR_OPTIONS


create
	make,
	make_and_launch,
	make_callback,
	make_callback_and_launch

feature {NONE} -- Initialization

	make (a_service: like service; a_options: like options)
		do
			make_from_service (a_service)
			options := a_options
			initialize
		ensure
			service_set: service = a_service
			options_set: options = a_options
			launchable: launchable
		end

	make_and_launch (a_service: like service; a_options: like options)
		do
			make (a_service, a_options)
			launch
		end

	make_callback (a_callback: like {WSF_CALLBACK_SERVICE}.callback; a_options: like options)
		do
			make (create {WSF_CALLBACK_SERVICE}.make (a_callback), a_options)
		end

	make_callback_and_launch (a_callback: like {WSF_CALLBACK_SERVICE}.callback; a_options: like options)
		do
			make (create {WSF_CALLBACK_SERVICE}.make (a_callback), a_options)
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
			-- Custom options; we want this to be type safe


feature -- Execution

	launch
		do
			if attached connector as conn then
				conn.launch
			end
		end

feature {WGI_CONNECTOR} -- Implementation: Execution

	execute (req: WGI_REQUEST; res: WGI_RESPONSE)
			-- Delegate the WGI processing to the WSF_SERVICE object
			-- <Precursor>
		local
			w_res: detachable WSF_RESPONSE
			w_req: detachable EPX_WSF_REQUEST
		do
			create w_res.make_from_wgi (res)
			create w_req.make_from_wgi (req)
			service.execute (w_req, w_res)
			w_req.destroy
		rescue
			if w_res /= Void then
				if not (w_res.status_committed or w_res.header_committed) then
					w_res.set_status_code ({HTTP_STATUS_CODE}.internal_server_error)
				end
				w_res.flush
			end
			if w_req /= Void then
				w_req.destroy
			end
		end

end
