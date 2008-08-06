indexing

	description: "IMAP4rev1 client."

	standards: "RFC 3501"

	problems: "Does not readily handle responses for multiple messages, i.e. 2:4 sequences and such."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #9 $"


class

	EPX_IMAP4_CLIENT


inherit

	ANY

	EPX_CURRENT_PROCESS
		export
			{NONE} all
		end

	EPX_IMAP4_COMMANDS
		export
			{NONE} all
		end


create

	make,
	make_with_port,
	make_secure


feature {NONE} -- Initialization

	make (a_host: STRING) is
			-- Initialize client and try to open connection to imap server.
			-- Check `is_open' if could connect to server.
			-- If not, `a_host' might not be resolvable.
		require
			host_not_empty: a_host /= Void and then not a_host.is_empty
		do
			make_with_port (a_host, 0, False)
		ensure
			unauthenticated: state.is_not_authenticated
			use_plain: not is_secure_connection
		end

	make_with_port (a_host: STRING; a_port: INTEGER; a_secure: BOOLEAN) is
			-- Initialize client and try to open connection to imap
			-- server at `a_host'.
			-- If `a_port' is zero, use the default port for an insecure
			-- or secure connection, depending on `a_secure'.
			-- Check `is_open' if could connect to server.  If not,
			-- `a_host' might not be resolvable.
		require
			host_not_empty: a_host /= Void and then not a_host.is_empty
			valid_port: a_port >= 0 and then a_port <= 65535
		do
			create state.make
			create response.make
			host_name := a_host
			port := a_port
			is_secure_connection := a_secure
			open
		ensure
			unauthenticated: state.is_not_authenticated
			secure: a_secure = is_secure_connection
		end

	make_secure (a_host: STRING) is
			-- Initialize client and try to open connection to imap server.
			-- Check `is_open' if could connect to server.
			-- If not, `a_host' might not be resolvable.
		require
			host_not_empty: a_host /= Void and then not a_host.is_empty
		do
			make_with_port (a_host, 0, True)
		ensure
			unauthenticated: state.is_not_authenticated
			use_ssl: is_secure_connection
		end

	make_ssl (a_host: STRING) is
		obsolete "2004-03-13: use make_secure instead"
		do
			make_secure (a_host)
		end


feature -- Open/close

	open is
			-- Open connection to an imap server. On success `is_open' is
			-- True. If there is a failure, check `error_message' for any
			-- human readable error message.
		require
			closed: not is_open
		do
			if is_secure_connection then
				open_ssl
			else
				open_tcp
			end
		end

	close is
			-- Close connection to imap server.
		require
			open: is_open
		do
			response.clear_current_mailbox
			socket.close
			state.set_not_authenticated
		ensure
			closed: not is_open
			unauthenticated: state.is_not_authenticated
		end


feature {NONE} -- Open

	open_ssl is
			-- Open SSL3 connection to an imap server.
		require
			closed: not is_open
		local
			service: EPX_SERVICE
			greeting_message: STRING
			openssl: EPX_OPENSSL
		do
			if port = 0 then
				create service.make_from_name_with_default (once "imaps", once "tcp", 993)
				port := service.port
			end
			create openssl.make_ssl3_client (host_name, port)
			openssl.execute
			socket := openssl
			socket.read_line
			if not socket.end_of_input then
				create greeting_message.make_from_string (socket.last_string)
				response.set_greeting_message (greeting_message)
			else
				socket.close
				socket := Void
			end
		end

	open_tcp is
			-- Open plain tcp connection to an imap server.
		require
			closed: not is_open
		local
			host: EPX_HOST
			service: EPX_SERVICE
			greeting_message: STRING
			tcp: EPX_TCP_CLIENT_SOCKET
		do
			if host_port = Void then
				create host.make_from_name (host_name)
				if host.found then
					if port = 0 then
						create service.make_from_name (once "imap", once "tcp")
					else
						create service.make_from_port (port, once "tcp")
					end
					create host_port.make (host, service)
				else
					error_message := "Host not found, error code is " + host.not_found_reason.out
				end
			end
			if host_port /= Void then
				create tcp.make
				tcp.set_continue_on_error
				tcp.open_by_address (host_port)
				if tcp.is_open then
					socket := tcp
					socket.read_line
					create greeting_message.make_from_string (socket.last_string)
					response.set_greeting_message (greeting_message)
				else
					error_message := tcp.errno.message
				end
			end
		end


feature -- Access

	error_message: STRING
			-- Human readable error message when `open' fails; warning:
			-- might be Void even when there is an error!

	host_name: STRING
			-- Name of server running the imap daemon

	port: INTEGER
			-- Port at `host_name'

	response: EPX_IMAP4_RESPONSE
			-- Responses received by server.

	state: EPX_IMAP4_STATE
			-- Current state, one of four


feature -- Status

	is_open: BOOLEAN is
			-- Is client connected to IMAP server?
		do
			Result :=
				socket /= Void and then
				socket.is_open_read and then
				socket.is_open_write
		ensure
			definition: is_open implies
				socket /= Void and then
				socket.is_open_read and then
				socket.is_open_write
		end

	is_secure_connection: BOOLEAN
			-- Do we have a secure connection to server?


feature -- Not-authenticated state commands

	login (a_user_name, a_password: STRING) is
			-- Login to the IMAP server using `a_user_name' and
			-- `a_password'. If login successful, then `state' will be
			-- set to `Authenticated_state'. If login was unsuccessful,
			-- see `login_failure_reason' for a human readable error message.
		require
			open: is_open
			unauthenticated: state.is_not_authenticated
			user_name_not_empty: a_user_name /= Void and then not a_user_name.is_empty
			user_name_does_not_contain_double_quote: not a_user_name.has ('"')
			password_not_empty: a_password /= Void and then not a_password.is_empty
			password_does_not_contain_double_quote: not a_password.has ('"')
		do
			construct_command (imap4_command_login, <<a_user_name, a_password>>, True)
			send_command
			if response.is_ok then
				state.set_authenticated
			end
		ensure
			authenticated: response.is_ok implies state.is_authenticated
		end

	noop is
			-- Since any command can return a status update as untagged
			-- data, the NOOP command can be used as a periodic poll for
			-- new messages or message status updates during a period of
			-- inactivity. The NOOP command can also be used to reset
			-- any inactivity autologout timer on the server.
			-- A `noop' can be issued in any state.
		require
			open: is_open
		do
			construct_command (imap4_command_noop, Void, False)
			send_command
		ensure
			state_unchanged: state = old state
		end


feature -- Authenticated state commands

	create_mailbox (a_mailbox_name: STRING) is
			-- The CREATE command creates a mailbox with the given name.
			-- An OK response is returned only if a new mailbox with that
			-- name has been created.  It is an error to attempt to
			-- create INBOX or a mailbox with a name that refers to an
			-- extant mailbox.
		require
			allowed_state:
				state.is_authenticated or else
				state.is_selected
			valid_mailbox_name: is_valid_mailbox_name (a_mailbox_name)
		do
			construct_command (imap4_command_create, <<a_mailbox_name>>, True)
			send_command
		end

	delete_mailbox (a_mailbox_name: STRING) is
			-- The DELETE command permanently removes the mailbox with
			-- the given name.
		require
			allowed_state:
				state.is_authenticated or else
				state.is_selected
			a_mailbox_name_is_valid: is_valid_mailbox_name (a_mailbox_name)
		do
			construct_command (imap4_command_delete, <<a_mailbox_name>>, True)
			send_command
		end

	examine (a_mailbox_name: STRING) is
			-- The EXAMINE command is identical to SELECT and returns the
			-- same output; however, the selected mailbox is identified
			-- as read-only. No changes to the permanent state of the
			-- mailbox, including per-user state, are permitted.
		require
			allowed_state:
				state.is_authenticated or else
				state.is_selected
			valid_mailbox_name: is_valid_mailbox_name (a_mailbox_name)
		do
			if response.mailboxes.has (a_mailbox_name) then
				response.set_current_mailbox (response.mailboxes.item (a_mailbox_name))
			else
				response.set_new_current_mailbox (a_mailbox_name)
			end
			construct_command (imap4_command_examine, <<a_mailbox_name>>, True)
			send_command
			if response.is_ok then
				state.set_selected
			else
				response.clear_current_mailbox
			end
		ensure
			state_changed: response.is_ok implies state.is_selected
		end

	get_delimiter is
			-- Make sure `response'.`delimiter' has the correct value.
		require
			allowed_state:
				state.is_authenticated or else
				state.is_selected
		do
			construct_command (imap4_command_list, <<once "", once "">>, True)
			send_command
		end

	list_all is
			-- `list_all' returns the complete set of all names available
			-- to the client.
		require
			allowed_state:
				state.is_authenticated or else
				state.is_selected
		do
			construct_command (imap4_command_list, <<once "", once "*">>, True)
			send_command
		end

	list_subscribed is
			-- `list_subscribed' returns the complete set of names that
			-- the user has declared as being "active" or "subscribed".
		require
			allowed_state:
				state.is_authenticated or else
				state.is_selected
		do
			construct_command (imap4_command_lsub, <<once "", once "*">>, True)
			send_command
		end

	select_mailbox (a_mailbox_name: STRING) is
			-- The SELECT command selects a mailbox so that messages in
			-- the mailbox can be accessed.
			-- If `response'.`is_ok' then `response'.`current_mailbox'
			-- contains some information about the selected mailbox.
		require
			allowed_state:
				state.is_authenticated or else
				state.is_selected
			valid_mailbox_name: is_valid_mailbox_name (a_mailbox_name)
		do
			if response.mailboxes.has (a_mailbox_name) then
				response.set_current_mailbox (response.mailboxes.item (a_mailbox_name))
			else
				response.set_new_current_mailbox (a_mailbox_name)
			end
			construct_command (imap4_command_select, <<a_mailbox_name>>, True)
			send_command
			if response.is_ok then
				state.set_selected
			else
				response.clear_current_mailbox
			end
		ensure
			state_changed: response.is_ok implies state.is_selected
		end


feature -- Selected state commands

	check_mailbox is
			-- The CHECK command requests a checkpoint of the currently
			-- selected mailbox. A checkpoint refers to any
			-- implementation-dependent housekeeping associated with the
			-- mailbox (e.g. resolving the server's in-memory state of
			-- the mailbox with the state on its disk) that is not
			-- normally executed as part of each command. A checkpoint
			-- MAY take a non-instantaneous amount of real time to
			-- complete. If a server implementation has no such
			-- housekeeping considerations, CHECK is equivalent to NOOP.
			-- There is no guarantee that an EXISTS untagged response
			-- will happen as a result of CHECK.  NOOP, not CHECK, SHOULD
			-- be used for new mail polling.
		require
			mailbox_selected: state.is_selected
		do
			construct_command (imap4_command_check, Void, False)
			send_command
		end

	close_mailbox is
			-- This command permanently removes from the currently
			-- selected mailbox all messages that have the \Deleted flag
			-- set, and returns to authenticated state from selected
			-- state.
		require
			mailbox_selected: state.is_selected
		do
			construct_command (imap4_command_close, Void, False)
			send_command
			state.set_authenticated
			response.clear_current_mailbox
		ensure
			authenticated: state.is_authenticated
		end

	copy_message (sequence_number: INTEGER; to_mailbox_name: STRING) is
			-- Copy message with sequence_number `sequence_number' to the
			-- mailbox `to_mailbox_name'.
		require
			mailbox_selected: state.is_selected
			sequence_number_valid: is_valid_sequence_number (sequence_number)
			to_mailbox_name_is_valid: is_valid_mailbox_name (to_mailbox_name)
		do
			construct_command (imap4_command_copy, <<sequence_number.out, quoted (to_mailbox_name)>>, False)
			send_command
		end

	delete_message (sequence_number: INTEGER) is
			-- Delete message with sequence_number `sequence_number' from
			-- the current mailbox.
		require
			mailbox_selected: state.is_selected
			sequence_number_valid: is_valid_sequence_number (sequence_number)
		do
			construct_command (imap4_command_store, <<sequence_number.out, once "+FLAGS.SILENT", once "(\Deleted)">>, False)
			send_command
		end

	expunge is
			-- The EXPUNGE command permanently removes all messages that
			-- have the \Deleted flag set from the currently selected
			-- mailbox.
		require
			mailbox_selected: state.is_selected
		do
			construct_command (imap4_command_expunge, Void, False)
			send_command
		end

	fetch (a_set: STRING; a_format: STRING) is
			-- Fetch messages described by `a_set' in format described by
			-- `a_format'. Data is stored into a new
			-- `response'.`current_message' object.
		require
			mailbox_selected: state.is_selected
			set_not_empty: a_set /= Void and then not a_set.is_empty
		do
			if a_set.is_integer then
				response.new_current_message (a_set.to_integer)
			else
				response.new_current_message (0)
			end
			construct_command (imap4_command_fetch, <<a_set, a_format>>, False)
			send_command
		ensure
			have_current_message: response.current_message /= Void
		end

	fetch_body (sequence_number: INTEGER) is
			-- Fetch message body, return raw RFC822 body in
			-- `last_body'.
		require
			mailbox_selected: state.is_selected
			sequence_number_valid: is_valid_sequence_number (sequence_number)
		do
			response.new_current_message (sequence_number)
			construct_command (imap4_command_fetch, <<sequence_number.out, once "RFC822.TEXT">>, False)
			send_command
		ensure
			have_current_message: response.current_message /= Void
		end

	fetch_header (sequence_number: INTEGER) is
			-- Fetch just the message header (no flags for example),
			-- return raw RFC822 header in
			-- `response'.`current_message'.`header'.
		require
			mailbox_selected: state.is_selected
			sequence_number_valid: is_valid_sequence_number (sequence_number)
		do
			response.new_current_message (sequence_number)
			construct_command (imap4_command_fetch, <<sequence_number.out, once "RFC822.HEADER">>, False)
			send_command
		ensure
			have_current_message: response.current_message /= Void
		end

	fetch_header_and_flags (sequence_number: INTEGER) is
			-- Fetch the message header and flags.
			-- Raw RFC822 header is in
			-- `response'.`current_message'.`header'; flags are in
			-- `response'.`current_message'.`flags'.
		require
			mailbox_selected: state.is_selected
			sequence_number_valid: is_valid_sequence_number (sequence_number)
		do
			response.new_current_message (sequence_number)
			construct_command (imap4_command_fetch, <<sequence_number.out, once "(FLAGS RFC822.HEADER)">>, False)
			send_command
		ensure
			have_current_message: response.current_message /= Void
		end

	fetch_message (sequence_number: INTEGER) is
			-- Fetch message, return raw RFC822 message in `response'.`message'.
		require
			mailbox_selected: state.is_selected
			sequence_number_valid: is_valid_sequence_number (sequence_number)
		do
			response.new_current_message (sequence_number)
			construct_command (imap4_command_fetch, <<sequence_number.out, once "RFC822">>, False)
			send_command
		ensure
			have_current_message: response.current_message /= Void
		end

	fetch_size (sequence_number: INTEGER) is
			-- Fetch message, return raw RFC822 size in `response'.`message_size'.
		require
			mailbox_selected: state.is_selected
			sequence_number_valid: is_valid_sequence_number (sequence_number)
		do
			response.new_current_message (sequence_number)
			construct_command (imap4_command_fetch, <<sequence_number.out, once "RFC822.SIZE">>, False)
			send_command
		ensure
			have_current_message: response.current_message /= Void
		end

	logout is
			-- Inform the server that the client is done with the
			-- connection.
		require
			open: is_open
			not_logged_out: not state.is_logged_out
		do
			construct_command (imap4_command_logout, Void, False)
			send_command
			state.set_logged_out
			response.clear_current_mailbox
		ensure
			logged_out: state.is_logged_out
		end

	mark_unseen (sequence_number: INTEGER) is
			-- Remove the \Seen flag from the given message.
			-- It does not update `current_message'.`flags' as it runs
			-- silently.
		require
			mailbox_selected: state.is_selected
			sequence_number_valid: is_valid_sequence_number (sequence_number)
		do
			response.new_current_message (sequence_number)
			construct_command (imap4_command_store, <<sequence_number.out, once "-FLAGS.SILENT", once "(\Seen)">>, False)
			send_command
		ensure
			have_current_message: response.current_message /= Void
		end


feature -- Selected state queries

	is_valid_sequence_number (a_number: INTEGER): BOOLEAN is
			-- Is `a_number' a valid sequence number for `current_mailbox'?
		require
			mailbox_selected: state.is_selected
		do
			Result :=
				a_number >= 1 and
				a_number <= response.current_mailbox.count
		end

	is_valid_mailbox_name (a_name: STRING): BOOLEAN is
			-- Is `a_mailbox_name' a valid mailbox name?
			-- It should not be empty, and it should not have the double
			-- quote character in its name.
		do
			Result :=
				a_name /= Void and then
				not a_name.is_empty and then
				not a_name.has ('"')
		end


feature {NONE} -- Command construction and sending

	command: STRING
			-- Entire command-line build by `construct_command'.

	command_number: INTEGER
			-- How many commands have been sent to the IMAP server.
			-- Used to build an unique tag.
			-- Incremented by `generate_new_tag'.

	construct_command (a_command: STRING; a_arguments: ARRAY [STRING]; astring: BOOLEAN) is
			-- Build a command-line for the IMAP command `a_command'
			-- using arguments in `a_arguments'. If `astring' than the
			-- arguments are enclosed within quotes.
		require
			a_command_not_empty: a_command /= Void and then not a_command.is_empty
		local
			i: INTEGER
		do
			if command = Void then
				create command.make (256)
			else
				command.wipe_out
			end
			generate_new_tag
			command.append_string (tag)
			command.append_character (' ')
			command.append_string (a_command)
			if a_arguments /= Void then
				from
					i := a_arguments.lower
				until
					i > a_arguments.upper
				loop
					command.append_character (' ')
					if astring then
						command.append_character ('%"')
						command.append_string (a_arguments.item (i))
						command.append_character ('%"')
					else
						command.append_string (a_arguments.item (i))
					end
					i := i + 1
				end
			end
			command.append_character ('%R')
			command.append_character ('%N')
		ensure
			command_contains_tag: command /= Void and then command.count > 2
			command_ends_with_crlf:
				command.item (command.count) = '%N' and then
				command.item (command.count - 1) = '%R'
		end

	generate_new_tag is
			-- Create a new unique tag in `tag'.
		do
			if tag = Void then
				create tag.make (6)
			else
				tag.wipe_out
			end
			tag.append_character ('A')
			command_number := command_number + 1
			tag.append_string (command_number.out)
		ensure
			tag_not_empty: tag /= Void and then not tag.is_empty
			command_number_incremented: command_number = old command_number + 1
		end

	send_command is
			-- Send command in `command' and parse response.
		require
			open: is_open
			command_not_empty: command /= Void and then not command.is_empty
			tag_not_empty: tag /= Void and then not tag.is_empty
		local
			parser: EPX_IMAP4_RESPONSE_PARSER
		do
			debug ("imap4")
				print ("Command: ")
				print (command)
				print ("%N")
			end
			socket.put_string (command)
			create parser.make (response)
			parser.set_input_buffer (parser.new_imap4_response_buffer (socket))
			parser.parse
			if parser.syntax_error then
				debug ("imap4")
					print ("!!!! parsing failed!%N")
					exit_with_failure
				end
				response.set_bad
			end
		end

	tag: STRING
			-- Tag that preceded the last IMAP command.


feature {NONE} -- Implementation

	host_port: EPX_HOST_PORT
			-- Resolved host

	socket: EPX_TEXT_IO_STREAM
			-- Connection to IMAP server

	quoted (s: STRING): STRING is
			-- Return `s' surrounded by double quotes.
		do
			if s = Void then
				Result := "%"%""
			else
				create Result.make (2 + s.count)
				Result.append_character ('%"')
				Result.append_string (s)
				Result.append_character ('%"')
			end
		ensure
			quoted_not_void: Result /= Void
			quoted:
				Result.count >= 2 and then
				Result.item (1) = '"' and then
				Result.item (Result.count) = '"'
		end


invariant

	host_name_not_empty: host_name /= Void and then not host_name.is_empty
	state_not_void: state /= Void
	closed_implies_unauthenticated: not is_open implies state.is_not_authenticated
	authenticated_implies_open: not state.is_not_authenticated implies is_open
	response_not_void: response /= Void

	selected_state_has_current_mailbox: state.is_selected implies response.current_mailbox /= Void
	unselected_state_has_no_current_mailbox: not state.is_selected implies response.current_mailbox = Void

end
