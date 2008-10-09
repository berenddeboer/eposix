indexing

	description: "Class that implements the basics of an HTTP client."

	todos:
		"1. raise exception when Content-Length and number of octects in message body do not match (RFC2616, section 4.4.)."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


deferred class

	EPX_HTTP_CLIENT


inherit

	EPX_TCP_CLIENT_BASE
		rename
			make as make_authenticate,
			make_with_port as make_authenticate_with_port,
			service as http_service,
			socket as http
		redefine
			close
		end

	EPX_HTTP_REPLY_CODE
		rename
			reply_code as response_code
-- 		export
-- 			{NONE} response_code, is_line_with_reply_code
		end


feature {NONE} -- Initialization

	make (a_server_name: STRING) is
			-- Prepare for request to `a_server_name'.
		require
			valid_server_name: a_server_name /= Void and then not a_server_name.is_empty
		do
			make_with_port (a_server_name, 0)
		end

	make_from_port (a_server_name: STRING; a_port: INTEGER) is
		obsolete "2004-12-16 use make_with_port instead."
		do
			make_with_port (a_server_name, a_port)
		end

	make_with_port (a_server_name: STRING; a_port: INTEGER) is
			-- Prepare for request.
			-- Use `port' is 0 to use the default port (80).
		require
			valid_server_name: a_server_name /= Void and then not a_server_name.is_empty
			valid_port: a_port >= 0 and then a_port <= 65535
		do
			make_authenticate_with_port (a_server_name, a_port, Void, Void)
		end

	make_from_host (a_host: EPX_HOST) is
			-- Prepare for request to resolved `a_host'. If `port' is 0,
			-- the default port is taken, else the port can be overruled.
		require
			host_found: a_host /= Void and then a_host.found
		do
			make_from_host_and_port (a_host, 0)
		end

	make_from_host_and_port (a_host: EPX_HOST; a_port: INTEGER) is
			-- Prepare for request to `a_host'. If `port' is 0, the
			-- default port is taken, else the port can be overruled.
		require
			host_found: a_host /= Void and then a_host.found
			valid_port: a_port >= 0 and a_port <= 65535
		do
			make_with_port (a_host.name, a_port)
			host := a_host
		end

	make_secure (a_server_name: STRING) is
			-- Prepare for secure (SSL) request to `a_host'.
		require
			valid_server_name: a_server_name /= Void and then not a_server_name.is_empty
		do
			make_secure_with_port (a_server_name, 0)
		ensure
			https: is_secure_connection
		end

	make_secure_with_port (a_server_name: STRING; a_port: INTEGER) is
			-- Prepare for secure (SSL) request to `a_host'.
		require
			valid_server_name: a_server_name /= Void and then not a_server_name.is_empty
			valid_port: a_port >= 0 and a_port <= 65535
		do
			is_secure_connection := True
			make_with_port (a_server_name, a_port)
		ensure
			https: is_secure_connection
		end


feature -- Access

	default_port: INTEGER is
			-- Default port for this protocol.
		do
			if is_secure_connection then
				Result := 443
			else
				Result := 80
			end
		end

	default_port_name: STRING is
			-- Default port name for this protocol.
		do
			if is_secure_connection then
				Result := once_https
			else
				Result := once_http
			end
		end

	raw_response: STRING
			-- Raw response if `read_raw_response' has been called


feature -- Open and close

	close is
		do
			is_authenticated := False
			precursor
		end


feature -- Requests

	get (path: STRING) is
			-- Send GET request to server. Use `read_response' to fetch
			-- the response.
		require
			path_not_empty: path /= Void and then not path.is_empty
		deferred
		end


feature -- Response

	read_response is
			-- Read entire resonse.
		require
			open: is_open
		deferred
		end

	read_raw_response is
			-- Read entire resonse, but don't parse or interpret it in
			-- any way. Put the response in `raw_response'.
		require
			open: is_open
		do
			create raw_response.make (8192)
			from
				http.read_string (8192)
			until
				http.end_of_input
			loop
				raw_response.append_string (http.last_string)
				http.read_string (8192)
			end
		end


feature -- Client http version

	client_version: STRING is
			-- Client's version of the http protocol
		deferred
		ensure
			have_version: Result /= Void and then not Result.is_empty
		end


feature {NONE} -- Implementation

	authenticate is
		do
			is_authenticated := True
		end

	assert_closed is
			-- Make sure http is no longer connected.
		do
			if is_open then
				close
			end
		ensure
			http_closed: http = Void
		end

	is_authenticated: BOOLEAN


end
