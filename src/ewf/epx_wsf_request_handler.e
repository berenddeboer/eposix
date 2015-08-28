note

	description:

		"Child that handles a single request"

	library: "eposix wsf library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_WSF_REQUEST_HANDLER [G -> WGI_EXECUTION create make end]


inherit

	POSIX_FORK_ROOT

	WGI_CONNECTOR


create

	make


feature {NONE} -- Initialisation

	make (a_socket: attached ABSTRACT_TCP_SOCKET)
		require
			socket_not_void: a_socket /= Void
			open: a_socket.is_open
		do
			socket := a_socket
		end


feature -- Access

	name: STRING_8 = "eposix fastcgi"
			-- Name of Current connector

	version: STRING_8 = "0.1"
			-- Version of Current connector

	socket: attached ABSTRACT_TCP_SOCKET


feature -- Execution

	execute
		local
			rescued: BOOLEAN
			fcgi: EPX_FAST_CGI
			req: WGI_REQUEST_FROM_TABLE
			res: WGI_RESPONSE_STREAM
			input: WGI_INPUT_STREAM
			output: WGI_OUTPUT_STREAM
			error: WGI_ERROR_STREAM
			exec: detachable WGI_EXECUTION
		do
			if not rescued then
				create fcgi.make (socket)
				fcgi.read_all_parameters
				if fcgi.parameters.has ({WGI_META_NAMES}.server_name) then
					create {EPX_WGI_FASTCGI_INPUT_STREAM} input.make (fcgi)
					create {EPX_WGI_FASTCGI_OUTPUT_STREAM} output.make (fcgi)
					create {EPX_WGI_FASTCGI_ERROR_STREAM} error.make (fcgi)
					create req.make (fcgi.parameters, input, Current)
					-- TODO: pass error stream
					create res.make (output, error)
					create {G} exec.make (req, res)
					exec.execute
					exec.clean
				end
				fcgi.close
			else
				-- TODO: fix, don't write trace to browser
				if attached (create {EXCEPTION_MANAGER}).last_exception as e and then attached e.trace as l_trace then
					if error /= Void then
						error.put_error (l_trace)
					end
					stderr.put_string (l_trace)
					if res /= Void then
						if not res.status_is_set then
							res.set_status_code ({HTTP_STATUS_CODE}.internal_server_error, Void)
						end
						if res.message_writable then
							res.put_string ("See server log for more details.")
						end
					end
				end
			end
		rescue
			rescued := True
			retry
		end


invariant

	socket_not_void: socket /= Void

end
