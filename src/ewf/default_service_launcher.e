note

	description: "[
			Component to launch the service using the default connector

					eposix FastCGI for this class

			How-to:

				s: DEFAULT_SERVICE_LAUNCHER
				create s.make_and_launch (agent execute)

				execute (req: WSF_REQUEST; res: WSF_RESPONSE)
					do
						-- ...
					end
		]"


class

	DEFAULT_SERVICE_LAUNCHER


inherit

	DEFAULT_SERVICE_LAUNCHER_I
		rename
			make as make_service,
			make_and_launch as make_and_launch_service,
			make_and_launch_with_options as make_and_launch_service_with_options
		redefine
			wgi_execute
		end

inherit {NONE}

	EPX_WGI_FASTCGI_CONNECTOR_OPTIONS


create

	make,
	make_and_launch,
	make_and_launch_with_options


feature {NONE} -- Initialization

	make (a_terminate_signal: EPX_KILL_SIGNAL_HANDLER; an_action: like action; an_options: like options)
		require
			signal_handler_attached: a_terminate_signal /= Void
			actions_not_void: an_action /= Void
		do
			terminate_signal := a_terminate_signal
			make_service (an_action, an_options)
		end

	make_and_launch (a_terminate_signal: EPX_KILL_SIGNAL_HANDLER; a_action: like action)
		do
			make (a_terminate_signal, a_action, Void)
			launch
		end

	make_and_launch_with_options (a_terminate_signal: EPX_KILL_SIGNAL_HANDLER; a_action: like action; a_options: attached like options)
		require
			signal_handler_attached: a_terminate_signal /= Void
			a_options_attached: a_options /= Void
		do
			make (a_terminate_signal, a_action, a_options)
			launch
		end

	initialize
		do
			if options = Void then
				create options
				options.port := 9000
			end
			create connector.make (terminate_signal, Current, options)
		end


feature -- Execution

	launch
		do
			if attached connector as conn then
				conn.launch
			end
		end


feature {WGI_CONNECTOR} -- WGI Execution

	wgi_execute (req: WGI_REQUEST; res: WGI_RESPONSE)
		local
			w_req: detachable EPX_WSF_REQUEST
			w_res: detachable WSF_RESPONSE
		do
			create w_res.make_from_wgi (res)
			create w_req.make_from_wgi (req)
			execute (w_req, w_res)
			w_req.destroy
		rescue
			if w_res /= Void then
				w_res.flush
			end
			if w_req /= Void then
				w_req.destroy
			end
		end


feature -- Access

	terminate_signal: attached EPX_KILL_SIGNAL_HANDLER

	connector: detachable EPX_WGI_FASTCGI_CONNECTOR
			-- Default service name


invariant

	signal_handler_attached: terminate_signal /= Void

end
