indexing

	description: "Class that implements a simple HTTP 1.1 server."

	standards: "RFC 2616"

	known_bugs:
		"1. request URI is not decoded when of the form '%% HEX HEX'."

	not_implemented:
		"Main things not done, and probably never will:%
		%1. Chunked encoding.%
		%2. Range support.%
		%3. Content negotation.%
		%4. HTTP 0.9 support still working??%
		%But it's relatively easy to add them inheriting from this server%
		%I guess."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #11 $"


class

	EPX_HTTP_SERVER


inherit

	ANY

	EPX_CURRENT_PROCESS
		export
			{NONE} all
		end

	EPX_FILE_SYSTEM
		export
			{NONE} all;
			{ANY} is_directory
		end

	EPX_MIME_TYPE_NAMES
		export
			{NONE} all
		end

	EPX_HTTP_METHODS
		export
			{NONE} all
		end

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end


create

	make,
	make_virtual


feature {NONE} -- Initialization

	do_make (a_port: INTEGER) is
			-- Initialize webserver.
		require
			valid_port: a_port >= 0 and then a_port <= 65535
		do
			create root_url.make ("file://localhost/")
			create resources.make
			create dynamic_resources.make
			create fixed_resources.make (128)
			serve_xhtml_if_supported := True
			create service.make_from_port (a_port, "tcp")
			create persistent_connections.make
		end

	make (a_port: INTEGER; a_root: STRING) is
			-- Initialize the web server with `a_root' as the '/' URL.
		require
			root_not_empty: a_root /= Void and then not a_root.is_empty
			root_exists: is_directory (a_root)
			valid_port: a_port >= 0 and then a_port <= 65535
		do
			create root.make_from_string (resolved_path_name (a_root))
			if
				root.item (root.count) = '/' or else
				root.item (root.count) = '/'
			then
				root.remove (root.count)
			end
			do_make (a_port)
		ensure
			not_virtual: not is_virtual
		end

	make_virtual (a_port: INTEGER) is
			-- Initialize the web server with no root in the file
			-- system. It will not serve files, only servlets.
			-- Use `register_url' to add recognized URLs in that case.
		require
			valid_port: a_port >= 0 and then a_port <= 65535
		do
			root := Void
			do_make (a_port)
		ensure
			virtual: is_virtual
		end

	new_host (a_loopback_only: BOOLEAN): EPX_HOST is
			-- The host name/ip address this web server listen on.
		do
			if a_loopback_only then
				create Result.make_from_ip4_loopback
			else
				create Result.make_from_ip4_any
			end
		ensure
			host_assigned: Result /= Void
			host_found: Result.found
		end


feature -- Listen and shutdown

	listen_locally is
			-- Listen on loopback interface only. No outside machines can
			-- connect to this server.
		require
			not_listening: not is_open
		local
			host: EPX_HOST
		do
			host := new_host (True)
			listen (host)
		ensure
			open: is_open
		end

	listen_globally is
			-- Listen on all interfaces for incoming connections.
		require
			not_listening: not is_open
		local
			host: EPX_HOST
		do
			host := new_host (False)
			listen (host)
		ensure
			open: is_open
		end

	listen (a_host: EPX_HOST) is
			-- Listen on interface(s) `a_host' for incoming connections.
		require
			not_listening: not is_open
		local
			hp: EPX_HOST_PORT
		do
			create hp.make (a_host, service)
			create socket.listen_by_address (hp)
			socket.set_blocking_io (False)
		ensure
			open: is_open
		end

	shutdown is
			-- Don't listen to requests anymore.
		require
			open: is_open
		do
			socket.close
			socket := Void
			from
				resources.start
			until
				resources.after
			loop
				resources.item_for_iteration.shutdown
				resources.forth
			end
		ensure
			closed: not is_open
		end


feature -- Status

	has_connected_client: BOOLEAN is
			-- Is there a client whose request we currently process?
		do
			Result := connection /= Void and then connection.is_open
		end

	is_open: BOOLEAN is
			-- Does the server listen on the given port?
		do
			Result := socket /= Void
		end

	is_virtual: BOOLEAN is
			-- Does this server serve entirely from servlets?
			-- If so, it will never read the local file system for files
			-- directly.
		do
			Result := root = Void
		end

	serve_xhtml_if_supported: BOOLEAN
			-- If client says it supports XHTML, send mime type XHTML;
			-- You don't want this in combination with a typical AJAX
			-- application for example as Mozilla seems to have serious
			-- issues with assigning text to innerHTML in such a case.


feature -- Access

	root: STDC_PATH
			-- Directory in file system where files are served from;
			-- Does not end with a back slash

	root_url: UT_URI
			-- Used to resolve relative components

	server_name: STRING is
			-- How server is known to the client
		once
			Result := "eposix/1.0"
		ensure
			server_name_not_empty: server_name /= Void and then not server_name.is_empty
		end


feature -- Change

	set_serve_xhtml_if_supported (a_enable: BOOLEAN) is
			-- Change `serve_xhtml_if_supported'.
		do
			serve_xhtml_if_supported := a_enable
		ensure
			serve_xhtml_if_supported_set: serve_xhtml_if_supported = a_enable
		end


feature -- Custom resources, non-files

	locate_servlet (a_path: STRING): EPX_HTTP_SERVLET is
			-- Return the servlet that handles this path or Void if there
			-- is none.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
			path_is_absolute: a_path.item (1) = '/'
		local
			dynamic_path: EPX_HTTP_DYNAMIC_PATH
		do
			fixed_resources.search (a_path)
			if fixed_resources.found then
				Result := fixed_resources.found_item
			else
				from
					dynamic_resources.start
				until
					Result /= Void or else
					dynamic_resources.after
				loop
					dynamic_path := dynamic_resources.item_for_iteration
					if dynamic_path.matches (a_path) then
						Result := dynamic_path.resource
						from
							dynamic_path.fields.start
						until
							dynamic_path.fields.after
						loop
							-- Fields in the path are added to
							-- `request_form_fields', except if they already
							-- exist. In that case we assume the user did
							-- want to change them.
							-- All fields in the path are also made available
							-- in the form or "part <fieldname>". Because if
							-- the space in the name, they can never clash
							-- with form fields.
							if not connection.request_form_fields.has (dynamic_path.fields.item_for_iteration.key) then
								connection.request_form_fields.force (dynamic_path.fields.item_for_iteration, dynamic_path.fields.item_for_iteration.key)
							end
							connection.request_form_fields.force (dynamic_path.fields.item_for_iteration, "part " + dynamic_path.fields.item_for_iteration.key)
							dynamic_path.fields.forth
						end
					end
					dynamic_resources.forth
				end
			end
		end

	register_dynamic_resource (a_path: STRING; a_servlet: EPX_HTTP_SERVLET) is
			-- Register `a_servlet' that will be called upon to provide the
			-- output when a client requests the resource `a_path'.
			-- `a_path' is a path in the form of the urlReplacement input
			-- defined in the WSDL 1.1 specification.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
			path_is_absolute: a_path.item (1) = '/'
			servlet_not_void: a_servlet /= Void
		local
			dynamic_path: EPX_HTTP_DYNAMIC_PATH
		do
			if not resources.has (a_servlet) then
				resources.put_last (a_servlet)
			end
			create dynamic_path.make_from_url (a_path, a_servlet)
			dynamic_resources.put_last (dynamic_path)
		ensure
			servlet_registered: resources.has (a_servlet)
			dynamic_resource_added: dynamic_resources.last.resource = a_servlet
		end

	register_fixed_resource (a_path: STRING; a_servlet: EPX_HTTP_SERVLET) is
			-- Register `a_servlet' that will be called upon to provide the
			-- output when a client requests the resource `a_path'.
			-- `a_path' should be an absolute path without relative components.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
			path_is_absolute: a_path.item (1) = '/'
			servlet_not_void: a_servlet /= Void
			new_path: not fixed_resources.has (a_path)
		do
			if not resources.has (a_servlet) then
				resources.put_last (a_servlet)
			end
			fixed_resources.put (a_servlet, a_path)
		ensure
			servlet_registered: resources.has (a_servlet)
			resource_recognized: fixed_resources.has (a_path)
			fixed_path_is_resource: fixed_resources.item (a_path) = a_servlet
		end

	dynamic_resources: DS_LINKED_LIST [EPX_HTTP_DYNAMIC_PATH]
			-- List of resources that have a dynamic path.

	fixed_resources: DS_HASH_TABLE [EPX_HTTP_SERVLET, STRING]
			-- List of resources that have a fixed path.

	resources: DS_LINKED_LIST [EPX_HTTP_SERVLET]
			-- All registered resources.


feature -- Execute requests

	process_next_request is
			-- Process the next request, if any.
		require
			open: is_open
		do
			accept_next_request
			if connection /= Void then
				do_process_next_request
			end
		ensure
			connection_closed_if_not_persistent: connection /= Void implies (connection.is_open implies connection.is_persistent)
		end

	process_next_requests is
			-- Process all available requests.
		require
			open: is_open
		do
			from
				accept_next_request
			until
				connection = Void
			loop
				do_process_next_request
				accept_next_request
			end
		ensure
			connection_closed_if_not_persistent: connection /= Void implies (connection.is_open implies connection.is_persistent)
		end


feature {NONE} -- Recognized commands

	process_delete (a_request_uri: UT_URI) is
			-- Handle a DELETE request.
		require
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
		local
			servlet: EPX_HTTP_SERVLET
		do
			servlet := locate_servlet (a_request_uri.path)
			if servlet /= Void then
				if servlet.are_request_form_fields_valid_for_delete (connection.request_form_fields) then
					process_delete_servlet (servlet, a_request_uri)
				else
					connection.report_not_found (a_request_uri.path)
				end
			else
				connection.report_forbidden (a_request_uri.path)
			end
		end

	process_delete_servlet (a_servlet: EPX_HTTP_SERVLET; a_request_uri: UT_URI) is
			-- Handle servlet DELETE request.
		require
			servlet_not_void: a_servlet /= Void
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
			deactivated_servlet: not a_servlet.is_activated
			request_form_fields_not_void: connection.request_form_fields /= Void
			valid_data: a_servlet.are_request_form_fields_valid_for_delete (connection.request_form_fields)
		do
			a_servlet.activate (connection, http_method_DELETE, a_request_uri.path)
			if
				send_servlet_delete_header (a_servlet) and then
				not connection.is_body_send
			then
				a_servlet.delete_body
				connection.send_body (a_servlet.as_uc_string)
			end
			a_servlet.deactivate
		ensure
			servlet_deactivated: not a_servlet.is_activated
		rescue
			if a_servlet.is_activated then
				a_servlet.deactivate
			end
		end

	process_get (a_request_uri: UT_URI) is
			-- Handle a GET request.
			-- `a_request_uri' is a fully resolved path.
		require
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
			request_form_fields_not_void: connection.request_form_fields /= Void
		local
			servlet: EPX_HTTP_SERVLET
		do
			servlet := locate_servlet (a_request_uri.path)
			if servlet /= Void then
				if servlet.are_request_form_fields_valid_for_get (connection.request_form_fields) then
					process_get_servlet (servlet, a_request_uri)
				else
					connection.report_not_found (a_request_uri.path)
				end
			elseif not is_virtual then
				process_get_file (a_request_uri)
			else
				connection.report_not_found (a_request_uri.path)
			end
		end

	process_get_servlet (a_servlet: EPX_HTTP_SERVLET; a_request_uri: UT_URI) is
			-- Send GET request to `a_servlet'.
		require
			servlet_not_void: a_servlet /= Void
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
			deactivated_servlet: not a_servlet.is_activated
			request_form_fields_not_void: connection.request_form_fields /= Void
			valid_data: a_servlet.are_request_form_fields_valid_for_get (connection.request_form_fields)
		do
			a_servlet.activate (connection, http_method_GET, a_request_uri.path)
			if
				send_servlet_get_header (a_servlet) and then
				not connection.is_body_send
			then
				a_servlet.get_body
				connection.send_body (a_servlet.as_uc_string)
			end
			a_servlet.deactivate
		ensure
			servlet_deactivated: not a_servlet.is_activated
		rescue
			if a_servlet.is_activated then
				a_servlet.deactivate
			end
		end

	process_get_file (a_request_uri: UT_URI) is
			-- `an_absolute_path' is a fully resolved resource and
			-- returned to the client if it is a file in `root'.
		require
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
		local
			resource_name: STDC_PATH
			modification_time: STDC_TIME
			if_modified_since: EPX_MIME_FIELD_IF_MODIFIED_SINCE
		do
			-- Make sure `path' is relative from `root'.
			create resource_name.make_from_string (root + a_request_uri.path)

			-- Perhaps not just check, but really, really bail out when
			-- there is still a relative component left in the path?
				check
					no_relative_components: resource_name.is_resolved
				end

			if is_directory (resource_name) then
				resource_name.set_basename (root + path_separator.out + default_html_page_name)
			end

			if is_readable (resource_name) then
				if connection.request_fields.has (field_name_if_modified_since) then
					if_modified_since ?= connection.request_fields.item (field_name_if_modified_since)
				end
				if if_modified_since /= Void then
					-- TODO: we also should check If-None-Match actually
					create modification_time.make_from_unix_time (status (resource_name).modification_time)
					-- Many clients send DOS times
					modification_time.to_dos_seconds
					modification_time.to_utc
					-- According to RFC2616 clients must send exact
					-- strings, because of buggy servers. Well, let's add
					-- another buggy server.
					if modification_time <= if_modified_since.date_time then
						connection.report_unmodified
						--send_file (resource_name)
					else
						send_file (resource_name)
					end
				else
					send_file (resource_name)
				end
			else
				if is_existing (resource_name) then
					connection.report_forbidden (a_request_uri.path)
				else
					connection.report_not_found (a_request_uri.path)
				end
			end
		end

	process_head (a_request_uri: UT_URI) is
			-- Handle a HEAD request.
		require
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
		local
			servlet: EPX_HTTP_SERVLET
		do
			servlet := locate_servlet (a_request_uri.path)
			if servlet /= Void then
				if servlet.are_request_form_fields_valid_for_head (connection.request_form_fields) then
					process_head_servlet (servlet, a_request_uri)
				else
					connection.report_not_found (a_request_uri.path)
				end
			elseif not is_virtual then
				process_head_file (a_request_uri)
			else
				connection.report_not_found (a_request_uri.path)
			end
		end

	process_head_servlet (a_servlet: EPX_HTTP_SERVLET; a_request_uri: UT_URI) is
			-- Handle servlet HEAD request.
		require
			servlet_not_void: a_servlet /= Void
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
			deactivated_servlet: not a_servlet.is_activated
			request_form_fields_not_void: connection.request_form_fields /= Void
			valid_data: a_servlet.are_request_form_fields_valid_for_head (connection.request_form_fields)
		do
			a_servlet.activate (connection, http_method_HEAD, a_request_uri.path)
			send_servlet_head_header (a_servlet)
			a_servlet.deactivate
		ensure
			servlet_deactivated: not a_servlet.is_activated
		rescue
			if a_servlet.is_activated then
				a_servlet.deactivate
			end
		end

	process_head_file (a_request_uri: UT_URI) is
			-- `an_absolute_path' is a fully resolved resource. Status is
			-- returned to the client if it is a file in `root'.
		require
			have_connection: has_connected_client
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
		local
			resource_name: STDC_PATH
			last_modified: STDC_TIME
			stat: ABSTRACT_STATUS_PATH
		do
			-- Make sure `path' is relative from `root'.
			create resource_name.make_from_string (root + a_request_uri.path)

			-- Perhaps not just check, but really, really bail out when
			-- there is still a relative component left in the path?
				check
					no_relative_components: resource_name.is_resolved
				end

			if is_readable (resource_name) then
				-- Parse MIME header here
				-- Handle:
				-- Accept-Encoding if present
				connection.write_response_code (200)
				stat := status (resource_name)
				connection.add_field (field_name_content_length, stat.size.out)
				create last_modified.make_from_unix_time (stat.modification_time)
				last_modified.to_utc
				connection.add_field (field_name_last_modified, last_modified.rfc_date_string)
				connection.write_mime_header (file_name_to_mime_type (resource_name))
				-- And blank line to separate body
				connection.add_new_line
				connection.send_header
			else
				if is_existing (resource_name) then
					connection.report_forbidden (a_request_uri.path)
				else
					connection.report_not_found (a_request_uri.path)
				end
			end
		end

	process_post (a_request_uri: UT_URI) is
			-- Handle a POST request.
		require
			have_connection: has_connected_client
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
			have_request_body: connection.request_body /= Void
			request_form_fields_not_void: connection.request_form_fields /= Void
		local
			servlet: EPX_HTTP_SERVLET
		do
			servlet := locate_servlet (a_request_uri.path)
			if servlet /= Void then
				if servlet.are_request_form_fields_valid_for_post (connection.request_form_fields) then
					process_post_servlet (servlet, a_request_uri)
				else
					connection.report_not_found (a_request_uri.path)
				end
			else
				connection.report_forbidden (a_request_uri.path)
			end
		end

	process_post_servlet (a_servlet: EPX_HTTP_SERVLET; a_request_uri: UT_URI) is
			-- Handle servlet POST request.
		require
			servlet_not_void: a_servlet /= Void
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
			deactivated_servlet: not a_servlet.is_activated
			request_form_fields_not_void: connection.request_form_fields /= Void
			have_request_body: connection.request_body /= Void
			valid_data: a_servlet.are_request_form_fields_valid_for_post (connection.request_form_fields)
		do
			a_servlet.activate (connection, http_method_POST, a_request_uri.path)
			if
				send_servlet_post_header (a_servlet) and then
				not connection.is_body_send
			then
				a_servlet.post_body
				connection.send_body (a_servlet.as_uc_string)
			end
			a_servlet.deactivate
		ensure
			servlet_deactivated: not a_servlet.is_activated
		rescue
			if a_servlet.is_activated then
				a_servlet.deactivate
			end
		end

	process_put (a_request_uri: UT_URI) is
			-- Handle a PUT request.
		require
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
			have_request_body: connection.request_body /= Void
			request_form_fields_not_void: connection.request_form_fields /= Void
		local
			servlet: EPX_HTTP_SERVLET
		do
			servlet := locate_servlet (a_request_uri.path)
			if servlet /= Void then
				if servlet.are_request_form_fields_valid_for_put (connection.request_form_fields) then
					process_put_servlet (servlet, a_request_uri)
				else
					connection.report_not_found (a_request_uri.path)
				end
			else
				connection.report_forbidden (a_request_uri.path)
			end
		end

	process_put_servlet (a_servlet: EPX_HTTP_SERVLET; a_request_uri: UT_URI) is
			-- Handle servlet POST request.
		require
			servlet_not_void: a_servlet /= Void
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
			deactivated_servlet: not a_servlet.is_activated
			request_form_fields_not_void: connection.request_form_fields /= Void
			have_request_body: connection.request_body /= Void
			valid_data: a_servlet.are_request_form_fields_valid_for_put (connection.request_form_fields)
		do
			a_servlet.activate (connection, http_method_POST, a_request_uri.path)
			if
				send_servlet_put_header (a_servlet) and then
				not connection.is_body_send
			then
				a_servlet.put_body
				connection.send_body (a_servlet.as_uc_string)
			end
			a_servlet.deactivate
		ensure
			servlet_deactivated: not a_servlet.is_activated
		rescue
			if a_servlet.is_activated then
				a_servlet.deactivate
			end
		end


feature {NONE} -- GET helper

	add_file_expires_date (a_mime_type: STRING; a_last_modification: STDC_TIME) is
			-- Add an Expires header based on the mime type. Without this
			-- field, certain brain dead browsers, you know which, will
			-- attempt to download the same image again and again and
			-- again, even if used multiple times on the same page.
			-- Only adds an Expires header for images.
		require
			mime_type_not_empty: a_mime_type /= Void and then not a_mime_type.is_empty
			last_modification_not_void: a_last_modification /= Void
		local
			now,
			one_day: STDC_TIME
		do
			if
				a_mime_type.is_equal (mime_type_image_gif) or else
				a_mime_type.is_equal (mime_type_image_png)
			then
				create now.make_from_now
				now.to_utc
				create one_day.make_from_unix_time (30 * 24 * 3600)
				connection.add_field (field_name_expires, (now + one_day).rfc_date_string)
				-- To avoid flicker with AJAX apps, see discussion at:
				-- http://www.aspnetresources.com/blog/cache_control_extensions.aspx
				-- Tried this, doesn't work:
				-- add_field (field_name_cache_control, "post-check=3600,pre-check=43200")
				-- And this one is recommended in the comments, however it
				-- did not work for me either.
				--add_field (field_name_cache_control, "max-age=2592000")
				-- And this one didn't work as well:
				connection.add_field (field_name_cache_control, "max-age=2592000; post-check=3600, pre-check=43200")
			end
		end

	file_name_to_mime_type (a_file_name: STRING): STRING is
			-- Try to get some suitable mime type. Needs to be
			-- rewritten. Doesn't look like the way to go.
			-- Perhaps parse/use Apache's /etc/mime.types?
			-- If not recognized, `a_file_name' will be served as
			-- text/hmtl or application/xhtml+xml.
		require
			a_file_name_not_empty: a_file_name /= Void and then not a_file_name.is_empty
		local
			file_name: STDC_PATH
		do
			create file_name.make_from_string (a_file_name)
			file_name.parse (<<once_css, once_png, once_gif, once_xhtml, once_xml, once_xsl, once_xslt, once_js>>)
			if STRING_.same_string (file_name.suffix, once_css) then
				Result := mime_type_text_css
			elseif STRING_.same_string (file_name.suffix, once_js) then
				Result := mime_type_text_javascript
			elseif STRING_.same_string (file_name.suffix, once_gif) then
				Result := mime_type_image_gif
			elseif STRING_.same_string (file_name.suffix, once_png) then
				Result := mime_type_image_png
			elseif STRING_.same_string (file_name.suffix, once_xhtml) then
				Result := mime_type_application_xhtml_plus_xml
			elseif
				STRING_.same_string (file_name.suffix, once_xml) or else
				STRING_.same_string (file_name.suffix, once_xsl) or else
				STRING_.same_string (file_name.suffix, once_xslt)
			then
				Result := mime_type_application_xml
			end
		end

	send_file (a_file_name: STRING) is
			-- Send the file `a_file_name' to `connection'.
			-- Errors are ignored.
		require
			client_connected: has_connected_client
			file_name_not_empty: a_file_name /= Void and then not a_file_name.is_empty
		local
			retried: BOOLEAN
			file: EPX_FILE_DESCRIPTOR
			last_modified: STDC_TIME
			file_status: EPX_STATUS
			mime_type: STRING
		do
			if not retried then
				-- Parse MIME header here
				-- Handle:
				-- Accept-Encoding if present
				create file.open_read (a_file_name)
				connection.write_response_code (200)
				file_status := file.status
				connection.add_field (field_name_content_length, file_status.size.out)
				create last_modified.make_from_unix_time (file_status.modification_time)
				last_modified.to_utc
				connection.add_field (field_name_last_modified, last_modified.rfc_date_string)
				-- Add Unix time of last modified date as ETag.
				connection.add_field (field_name_etag, last_modified.value.out)
				mime_type := file_name_to_mime_type (a_file_name)
				if mime_type /= Void then
					add_file_expires_date (mime_type, last_modified)
				end
				connection.write_mime_header (mime_type)
				-- And blank line to separate body
				connection.add_new_line
				connection.send_header
				if connection.is_open then
					connection.client.append (file)
				end
				file.close
			end
		rescue
			if exceptions.is_developer_exception then
				if not retried then
					retried := True
					retry
				end
			end
		end

	send_servlet_get_header (servlet: EPX_HTTP_SERVLET): BOOLEAN is
			-- Was asking servlet to prepare header and sending it to the
			-- client successful?
		require
			client_connected: has_connected_client
			header_not_send: not connection.is_header_send
			servlet_not_void: servlet /= Void
		local
			retried: INTEGER
			error_message: STRING
		do
			inspect retried
			when 0 then
				servlet.get_header
				if not connection.is_header_send then
					if not connection.response_header_ends_with_body_separator then
						connection.add_new_line
					end
					if connection.has_client_disconnected then
						connection.close
					else
						connection.send_header
					end
				end
				Result := connection.is_open
			when 1 then
				if not connection.is_header_send then
					connection.report_internal_server_error (error_message)
				end
			else
				Result := False
			end
		ensure
			header_send: Result implies connection.is_header_send
			still_open: Result implies connection.is_open
		rescue
			if exceptions.is_developer_exception then
				retried := retried + 1
				error_message := exceptions.developer_exception_name
				-- Bomb if header already sent???
				if not connection.is_header_send then
					retry
				end
			end
		end

	send_servlet_head_header (servlet: EPX_HTTP_SERVLET) is
			-- Send header to client, ignore exceptions that result from
			-- writing to a client that has disconnected.
		require
			client_connected: has_connected_client
			header_not_send: not connection.is_header_send
			servlet_not_void: servlet /= Void
		local
			retried: INTEGER
			error_message: STRING
		do
			inspect retried
			when 0 then
				servlet.head_header
				if not connection.is_header_send then
					if not connection.response_header_ends_with_body_separator then
						connection.add_new_line
					end
					if connection.has_client_disconnected then
						connection.close
					else
						connection.send_header
					end
				end
			when 1 then
				if not connection.is_header_send then
					connection.report_internal_server_error (error_message)
				end
			else
				-- exit
			end
		rescue
			if exceptions.is_developer_exception then
				retried := retried + 1
				error_message := exceptions.developer_exception_name
				-- Bomb if header already sent???
				if not connection.is_header_send then
					retry
				end
			end
		end


feature {NONE} -- DELETE/POST/PUT helper

	send_servlet_delete_header (servlet: EPX_HTTP_SERVLET): BOOLEAN is
			-- Was asking servlet to prepare header and sending it to the
			-- client successful?
		require
			client_connected: has_connected_client
			header_not_send: not connection.is_header_send
			servlet_not_void: servlet /= Void
		local
			retried: INTEGER
			error_message: STRING
		do
			inspect retried
			when 0 then
				servlet.delete_header
				if not connection.is_header_send then
					if not connection.response_header_ends_with_body_separator then
						connection.add_new_line
					end
					connection.send_header
				end
				Result := connection.is_open
			when 1 then
				if not connection.is_header_send then
					connection.report_internal_server_error (error_message)
				end
			else
				Result := False
			end
		ensure
			header_send: Result implies connection.is_header_send
			still_open: Result implies connection.is_open
		rescue
			if exceptions.is_developer_exception then
				retried := retried + 1
				error_message := exceptions.developer_exception_name
				-- Bomb if header already sent???
				if not connection.is_header_send then
					retry
				end
			end
		end

	send_servlet_post_header (servlet: EPX_HTTP_SERVLET): BOOLEAN is
			-- Was asking servlet to prepare header and sending it to the
			-- client successful?
		require
			client_connected: has_connected_client
			header_not_send: not connection.is_header_send
			servlet_not_void: servlet /= Void
		local
			retried: INTEGER
			error_message: STRING
		do
			inspect retried
			when 0 then
				servlet.post_header
				if not connection.is_header_send then
					if not connection.response_header_ends_with_body_separator then
						connection.add_new_line
					end
					connection.send_header
				end
				Result := connection.is_open
			when 1 then
				if not connection.is_header_send then
					connection.report_internal_server_error (error_message)
				end
			else
				Result := False
			end
		ensure
			header_send: Result implies connection.is_header_send
			still_open: Result implies connection.is_open
		rescue
			if exceptions.is_developer_exception then
				retried := retried + 1
				error_message := exceptions.developer_exception_name
				-- Bomb if header already sent???
				if not connection.is_header_send then
					retry
				end
			end
		end

	send_servlet_put_header (servlet: EPX_HTTP_SERVLET): BOOLEAN is
			-- Was asking servlet to prepare header and sending it to the
			-- client successful?
		require
			client_connected: has_connected_client
			header_not_send: not connection.is_header_send
			servlet_not_void: servlet /= Void
		local
			retried: INTEGER
			error_message: STRING
		do
			inspect retried
			when 0 then
				servlet.put_header
				if not connection.is_header_send then
					if not connection.response_header_ends_with_body_separator then
						connection.add_new_line
					end
					connection.send_header
				end
				Result := connection.is_open
			when 1 then
				if not connection.is_header_send then
					connection.report_internal_server_error (error_message)
				end
			else
				Result := False
			end
		ensure
			header_send: Result implies connection.is_header_send
			still_open: Result implies connection.is_open
		rescue
			if exceptions.is_developer_exception then
				retried := retried + 1
				error_message := exceptions.developer_exception_name
				-- Bomb if header already sent???
				if not connection.is_header_send then
					retry
				end
			end
		end


feature {NONE} -- Execute requests

	accept_new_incoming_request is
			-- If socket has a new client connection, make it available
			-- in `connection'.
		require
			open: is_open
		local
			my_client: ABSTRACT_TCP_SOCKET
		do
			connection := Void
			my_client := socket.accept
			if my_client /= Void then
				-- At least on Windows, the socket is
				-- non-blocking. Perhaps it inherits this property from
				-- the parent.
				-- Unfortunately, non-blocking i/o is hard to deal with in
				-- the parser at the moment, so turn it off until we can
				-- properly support it, because we really should. Clients
				-- should not be able to block us.
				my_client.set_continue_on_error
				my_client.set_blocking_io (True)
				create connection.make (Current, my_client)
			end
		end

	accept_next_persistent_request is
			-- Loop through the persistent connections and return the
			-- first one that has become readable.
		local
			c: EPX_HTTP_CONNECTION
			now: STDC_TIME
			last_action: STDC_TIME
		do
			-- Close any open connections that have been open for more
			-- than 15s without a new request.
			from
				create now.make_from_now
				connection := Void
				persistent_connections.start
			until
				persistent_connections.after or else
				connection /= Void
			loop
				c := persistent_connections.item_for_iteration
				if c.last_response_send_time /= Void then
					last_action := c.last_response_send_time
				elseif c.last_request_receive_time /= Void then
					last_action := c.last_request_receive_time
				else
					last_action := Void
				end
				if
					(not c.is_open) or else
					(last_action /= Void and then now.value - last_action.value > max_keep_alive) then
					persistent_connections.remove_at
					c.close
				elseif c.is_readable then
					connection := c
				else
					persistent_connections.forth
				end
			end
		end

	accept_next_request is
			-- Accept the next request, if there is one and put it in
			-- `connection'. If there is no connection `connection' will
			-- be Void.
		require
			open: is_open
		do
			-- Prefer handling persistent connections above new
			-- connections.
			accept_next_persistent_request
			if connection = Void then
				accept_new_incoming_request
			end
			debug ("httpd")
				if connection /= Void then
					stderr.put_string (connection.client.remote_address.address.out)
					stderr.write_character (':')
					stderr.put_string (connection.client.remote_address.port.out)
					stderr.put_string (" => ")
					stderr.put_string (connection.client.local_address.address.out)
					stderr.write_character (':')
					stderr.put_string (connection.client.local_address.port.out)
					stderr.write_character ('%N')
				end
			end
		end

	do_process_next_request is
			-- Process request just returned by `accept_request'.
		require
			request_available: connection /= Void
		do
			connection.clear_request_state
			connection.parse_request
			if connection.is_request_parsed then
				process_method (connection.method, connection.request_uri)
			end
			if not connection.is_persistent then
				connection.close
			elseif connection.is_open and then not persistent_connections.has (connection) then
				persistent_connections.force_last (connection)
			end
		ensure
			connection_closed_if_not_persistent: connection /= Void implies (connection.is_open implies connection.is_persistent)
		end

	process_method (a_method: STRING; a_request_uri: UT_URI) is
			-- Call proper routine when `a_method' is an implemented
			-- method.
		require
			client_connected: has_connected_client
			method_not_empty: a_method /= Void and then not a_method.is_empty
			request_uri_valid: a_request_uri /= Void and then a_request_uri.is_path_resolved and then a_request_uri.has_absolute_path
			request_fields_set: connection.request_fields /= Void
		do
			-- As we have parsed all input, this is a good point to say
			-- that subsequent output to the client can be non-blocking.
			-- Yeah, but why??? It only complicates our end. We surely
			-- don't want to retry if the client doesn't read fast
			-- enough.
			--client.set_blocking_io (False)

			-- dispatch
			if STRING_.same_string (a_method, http_method_GET) then
				process_get (a_request_uri)
			elseif STRING_.same_string (a_method, http_method_POST) then
				if connection.request_body /= Void then
					process_post (a_request_uri)
				else
					connection.report_bad_request ("request body expected")
				end
			elseif STRING_.same_string (a_method, http_method_PUT) then
				if connection.request_body /= Void then
					process_put (a_request_uri)
				else
					connection.report_bad_request ("request body expected")
				end
			elseif STRING_.same_string (a_method, http_method_HEAD) then
				process_head (a_request_uri)
			elseif STRING_.same_string (a_method, http_method_DELETE) then
				process_delete (a_request_uri)
			else
				connection.report_not_implemented (a_method)
			end
		end

	max_keep_alive: INTEGER is 30
			-- How many seconds a client connection may remain open
			-- without sending a new request


feature -- Connected client state

	connection: EPX_HTTP_CONNECTION
			-- The connection we're currently dealing with

	persistent_connections: DS_LINKED_LIST [EPX_HTTP_CONNECTION]
			-- Connections currently not closed


feature -- Obsoletes

	add_field (a_field_name, a_content: STRING) is
		obsolete "2006-02-06: use connection.add_field instead."
		do
			connection.add_field (a_field_name, a_content)
		end

	add_new_line is
		obsolete "2006-02-06: use connection.add_new_line instead."
		do
			connection.add_new_line
		end

	client: ABSTRACT_TCP_SOCKET is
		obsolete "2006-02-06: use connection.client instead."
		do
			Result := connection.client
		end

	is_body_send: BOOLEAN is
		obsolete "2006-02-06: use connection.is_body_send instead."
		do
			Result := connection.is_body_send
		end

	is_header_send: BOOLEAN is
		obsolete "2006-02-06: use connection.is_header_send instead."
		do
			Result := connection.is_header_send
		end

	request_body: EPX_MIME_BODY is
		obsolete "2006-02-06: use connection.request_body instead."
		do
			Result := connection.request_body
		end

	request_fields: DS_HASH_TABLE [EPX_MIME_FIELD, STRING] is
		obsolete "2006-02-06: use connection.request_fields instead."
		do
			Result := connection.request_fields
		end

	response_header_ends_with_body_separator: BOOLEAN is
		obsolete "2006-02-06: use connection.response_header_ends_with_body_separator instead."
		do
			Result := connection.response_header_ends_with_body_separator
		end

	request_form_fields: DS_HASH_TABLE [EPX_KEY_VALUE, STRING] is
		obsolete "2006-02-06: use connection.request_form_fields instead."
		do
			Result := connection.request_form_fields
		end

	send_body (a_body: STRING) is
		obsolete "2006-02-06: use connection.send_body instead."
		do
			connection.send_body (a_body)
		end

	send_header is
		obsolete "2006-02-06: use connection.send_header instead."
		do
			connection.send_header
		end


feature {EPX_HTTP_SERVLET, EPX_HTTP_CONNECTION} -- Execute request implementation

	to_absolute_uri (a_raw_request_uri: STRING): UT_URI is
			-- `a_raw_request_uri' is the URI send by the client. If it does
			-- not conform to the specs, Void is returned, else an
			-- absolute URI is returned.
		require
			request_uri_not_empty: a_raw_request_uri /= Void and then not a_raw_request_uri.is_empty
		local
			retried: BOOLEAN
			s: STRING
		do
			if
				not retried and then
				not url_encoder.has_excluded_characters (a_raw_request_uri)
			then
				create Result.make (a_raw_request_uri)
				if Result.path = Void then
					Result.set_path ("/")
				end
				if Result.has_absolute_path then
					-- Make `s' relative from `root_url'
					create s.make_from_string (a_raw_request_uri)
					if s.item (1) = '/' then
						s.remove (1)
					end
					create Result.make_resolve (root_url, s)
					-- 2006-11-20: Result.unescape_components
				else
					-- error case: path given is not absolute
					Result := Void
				end
			else
				Result := Void
			end
		ensure
			absolute_path:
				Result = Void or else
				(Result.is_path_resolved and then Result.has_absolute_path)
		rescue
			if not retried and then exceptions.is_developer_exception then
				-- We can get an exception for a really dirty URL.
				retried := True
				retry
			end
		end


feature {NONE} -- Implementation

	default_html_page_name: STRING is "index.html"
			-- Page retrieved when a directory is passed as resource

	service: EPX_SERVICE
			-- Port on which this server listens

	socket: EPX_TCP_SERVER_SOCKET
			-- Listening socket

	url_encoder: expanded EPX_URL_ENCODING
			-- Decoding of encoded passed values


feature {NONE} -- Once STRINGs, Eiffel's worst feature

	once_file_url_prefix: STRING is "file://localhost"
	once_http_url_prefix: STRING is "http://localhost"


feature {NONE} -- File extensions

	once_css: STRING is ".css"
	once_js: STRING is ".js"
	once_png: STRING is ".png"
	once_gif: STRING is ".gif"
	once_xhtml: STRING is ".xhtml"
	once_xml: STRING is ".xml"
	once_xsl: STRING is ".xsl"
	once_xslt: STRING is ".xslt"


invariant

	root_is_void_or_not_empty: root /= Void implies not root.is_empty
	root_is_absolute: root /= Void implies root.is_absolute
	root_is_resolved: root /= Void implies root.is_resolved
	root_not_ends_with_slash: root /= Void implies root.item (root.count) /= '/'
	-- Check is expensive at run-time:
	--root_is_void_or_exists: root /= Void implies is_directory (root)
	root_url_not_void: root_url /= Void
	root_url_is_absolute: root_url.is_absolute

	socket_not_void: socket /= Void implies socket.is_open
	socket_non_blocking: socket /= Void implies not socket.is_blocking_io
	persistent_connections_not_void: persistent_connections /= Void

	dynamic_resources_not_void: dynamic_resources /= Void
	fixed_resources_not_void: fixed_resources /= Void
	resources_not_void: resources /= Void

	service_not_void: service /= Void


end
