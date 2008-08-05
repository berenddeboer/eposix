indexing

	description:

		"Class that can access an IRC server."

	library: "eposix"
	standards: "RFC 2812"
	bugs: "Assume that it is not connected via an sslclient socket"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_IRC_CLIENT


inherit

	EPX_TCP_CLIENT_BASE
		redefine
			close,
			make_with_port,
			open
		end

	EPX_IRC_NAMES

	EPX_IRC_COLOR
		export
			{NONE} all
		end

	EPX_IRC_CTCP_ENCODING
		export
			{NONE} all
		end


create

	make,
	make_with_port


feature {NONE} -- Initialisation

	make_with_port (a_server_name: STRING; a_port: INTEGER; a_user_name, a_password: STRING) is
			-- Initialize with a given port. If `a_port' is null the
			-- `default_port' is taken.
			-- `a_user_name' is set as the default nick name if it is a
			-- valid nick name and no longer than 9 characters.
		local
			pong_handler: EPX_IRC_PONG
			motd_handler: EPX_IRC_MOTD
			ctcp_handler: EPX_IRC_CTCP
			tester: EPX_IRC_NICK_NAME_EQUALITY_TESTER
		do
			precursor (a_server_name, a_port, a_user_name, a_password)
			if is_valid_nick_name (a_user_name) and then a_user_name.count <= 9 then
				nick_name := a_user_name
			end
			real_name := a_user_name
			create message_of_the_day.make (256)
			create { DS_LINKED_LIST [EPX_IRC_MESSAGE_HANDLER] } system_handlers.make
			create pong_handler.make (Current)
			system_handlers.put_last (pong_handler)
			create motd_handler.make (Current)
			system_handlers.put_last (motd_handler)
			create nickserv_handler.make (Current)
			system_handlers.put_last (nickserv_handler)
			create ctcp_handler.make (Current)
			system_handlers.put_last (ctcp_handler)
			create { DS_LINKED_LIST [EPX_IRC_DCC_CHAT_ACCEPTOR] } dcc_chat_requests.make
			create { DS_LINKED_LIST [EPX_IRC_MESSAGE_HANDLER] } message_handlers.make
			create nickserv_passwords.make (1)
			create tester
			nickserv_passwords.set_key_equality_tester (tester)
		end


feature -- Access

	default_port: INTEGER is 6667
			-- Default IRCD port

	default_port_name: STRING is
		do
			Result := once_ircd
		end

	last_joined_channel: EPX_IRC_CHANNEL
			-- Last channel joined by `join';
			-- Be aware: only an attempt was made to join it, check
			-- `last_joined_channel'.`is_open' to see if channel could
			-- actually be joined.

	last_message: EPX_IRC_MESSAGE
			-- Last received message

	last_response: STRING
			-- Last received line (unparsed)

	message_handlers: DS_LIST [EPX_IRC_MESSAGE_HANDLER]
			-- User defined handlers for incoming messages

	message_of_the_day: STRING
			-- Message of the day if server has sent one, else empty.

	nick_name: STRING
			-- Nick name;
			-- default is `user_name'.

	nickserv_handler: EPX_IRC_NICKSERV
			-- Communicates with NickServ to supply a password when the
			-- nick name is set or is changed

	nickserv_passwords: DS_HASH_TABLE [STRING, STRING]
			-- Password for a given nick name to be sent to NickServ if
			-- it asks for a password

	real_name: STRING
			-- Real user name;
			-- default is `user_name'.


feature -- Status

	is_authenticated: BOOLEAN

	is_blocking_io: BOOLEAN is
			-- Is blocking i/o enabled?
		require
			open: is_open
		do
			Result := tcp_socket.is_blocking_io
		end

	is_nick_name_in_use: BOOLEAN
			-- Is current nick name already in use on the server?
			-- Set if reply received from server.

	log_response: BOOLEAN is
			-- Should received responses to written to `log_filename'?
		do
			Result := log_file /= Void
		ensure
			definition: Result = (log_file /= Void)
		end

	print_response: BOOLEAN
			-- Should received responses to put to stdout?


feature -- Modes

	is_invisible: BOOLEAN
			-- Is client invisible?

	is_receiving_wallops: BOOLEAN


feature -- Change

	set_nick_name (a_nick_name: STRING) is
			-- Set `nick_name'.
		require
			valid_nick_name: is_valid_nick_name (a_nick_name)
		do
			nick_name := a_nick_name
			if is_open then
				put_message (commands.nick, nick_name)
			end
		end

	set_nick_name_password (a_nick_name, a_password: STRING) is
			-- Remember the `a_password' for `a_nick_name' such that when
			-- NickServ asks for one, it can be automatically sent.
		require
			valid_nick_name: is_valid_nick_name (a_nick_name)
			no_password_set_for_this_nick_name: not nickserv_passwords.has (a_nick_name)
		do
			nickserv_passwords.force (a_password, a_nick_name)
		ensure
			password_set_for_this_nick_name: nickserv_passwords.has (a_nick_name)
		end

	set_log_filename (a_filename: STRING) is
			-- Set `log_filename', create the file with that name and
			-- start writing responses to that file.
			-- We assume the file can be created...
		do
			create log_file.create_write (a_filename)
		ensure
			logging_responses: log_response
		end

	set_print_response (a_print_response: BOOLEAN) is
			-- Set `print_response'.
		do
			print_response := a_print_response
		ensure
			set: print_response = a_print_response
		end

	set_real_name (a_real_name: STRING) is
			-- Set `real_name', do before `open'.
		require
			not_authenticated: not is_authenticated
		do
			real_name := a_real_name
		end


feature -- Open/close

	open is
			-- Open connection and set non-blocking i/o.
		do
			precursor
			if tcp_socket /= Void then
				set_blocking_io (False)
			end
		end

	close is
			-- Close connection to server.
		do
			is_authenticated := False
			precursor
		end


feature -- Reading

	handle_system_responses is
			-- Respond to an incoming message.
		require
			open: is_open
			last_message_not_void: last_message /= Void
		do
			from
				system_handlers.start
			until
				system_handlers.after
			loop
				system_handlers.item_for_iteration.handle (last_message)
				system_handlers.forth
			end
		end

	handle_user_responses is
			-- Call user defined handles for the incoming message.
		require
			open: is_open
			last_message_not_void: last_message /= Void
		do
			from
				message_handlers.start
			until
				message_handlers.after
			loop
				message_handlers.item_for_iteration.handle (last_message)
				message_handlers.forth
			end
		end

	read_all is
			-- Read all available responses. If i/o is blocking, this
			-- routine will never return unless the server closed the
			-- connection.
		do
			from
				read
			until
				end_of_input or else
				last_response = Void
			loop
				read
			end
		end

	read is
			-- Read a single response. Returns immediately of
			-- non-blocking i/o is enabled (the default), else it waits
			-- until a line of input has been read.
			-- Sets `last_response' and `last_message' to Void if reading
			-- would block or if the server sends an empty line.
			-- Else they contain the last line sent by the server and the
			-- parsed message.
		do
			socket.read_line
			if tcp_socket.last_blocked or else tcp_socket.last_string.is_empty then
				last_response := Void
				last_message := Void
			else
				last_response := socket.last_string
				if print_response then
					print (without_color (last_response))
					print ("%N")
				end
				if log_response then
					log_file.put_string (last_response)
					log_file.put_character ('%N')
					log_file.flush
				end
				create last_message.make_parse (last_response)
				if
					last_message.has_reply_code and then
					last_message.reply_code = reply_codes.ERR_NICKNAMEINUSE
				then
					is_nick_name_in_use := True
				end
				handle_system_responses
				handle_user_responses
			end
		end

	set_blocking_io (enable: BOOLEAN) is
			-- Set `is_blocking_io'.
		require
			open: is_open
		do
			tcp_socket.set_blocking_io (enable)
		ensure
			blocking_set: enable = is_blocking_io
		end


feature -- Connection registration

	authenticate is
		local
			user_param: STRING
			mode: INTEGER
		do
			-- Make sure input queue is cleared, else perhaps server
			-- might have an issue responding to us.
			set_blocking_io (False)
			read_all
			if password /= Void then
				put_message (commands.pass, password)
			end
			put_message (commands.nick, nick_name)
			if is_receiving_wallops then
				mode := flip_bits (mode, 4, True)
			end
			if is_invisible then
				mode := flip_bits (mode, 8, True)
			end
			user_param := user_name + " " + mode.out + " * :" + real_name
			put_message (commands.user, user_param)
		end

	quit (a_message: STRING) is
			-- Quit with optional reason.
			-- A server usually allows only one quit message per 5
			-- minutes or so, to avoid being it used to spam people. If
			-- you quit within that time, a generic quit is displayed.
		do
			if a_message = Void or else a_message.is_empty then
				put_message (commands.quit, Void)
			else
				put_message (commands.quit, ":" + a_message)
			end
		end


feature -- Channel operations

	all_names is
			-- List all visible nick names.
		do
			put_message (commands.names, Void)
		end

	join (a_channel_name: STRING) is
			-- Join a channel. Sets `last_joined_channel', a class which
			-- makes working with a channel or multiple channels must
			-- easier.
		require
			valid_channel_name: is_valid_channel_name (a_channel_name)
		do
			put_message (commands.join, a_channel_name)
			create last_joined_channel.make (Current, a_channel_name)
			system_handlers.put_last (last_joined_channel)
		end

	list_all is
			-- List all channels.
		do
			put_message (commands.list, Void)
		end

	names (a_channel_name: STRING) is
			-- List all visible nick names in channel `a_channel_name'.
		require
			valid_channel_name: is_valid_channel_name (a_channel_name)
		do
			put_message (commands.names, a_channel_name)
		end

	part (a_channel_name, a_part_message: STRING) is
			-- Leave channel `a_channel_name' while sending optional
			-- message `a_part_message'.
		require
			valid_channel_name: is_valid_channel_name (a_channel_name)
			is_valid_text: is_valid_text (a_part_message)
		do
			put_message (commands.part, combine_param_and_full_text (a_channel_name, a_part_message))
		end

	part_all is
			-- Leave all channels.
		do
			put_message (commands.join, "0")
		end

	set_topic (a_channel_name, a_topic: STRING) is
			-- Set topic for channel `a_channel_name' to `a_topic'.
			-- You must have channel operator privileges for this.
		require
			valid_channel_name: is_valid_channel_name (a_channel_name)
			is_valid_text: is_valid_text (a_topic)
		do
			put_message (commands.topic, combine_param_and_full_text (a_channel_name, a_topic))
		end


feature -- Sending messages

	ctcp (a_nick_name, a_text: STRING) is
			-- Send a message to `a_nick_name' using the CTCP
			-- protocol. CTCP is the client-to-client protocol and it
			-- uses a special form of `privmsg' to communicate with
			-- `a_nick_name'.
			-- `a_text' should not already be CTCP encoded.
		require
			valid_nick_name: is_valid_nick_name (a_nick_name)
		do
			-- `a_text' is basically send surrounded with the CTCP
			-- M-Quote character (Ctrl+P), and the text that must be
			-- quoted, is quoted.
			put_message (commands.privmsg, combine_param_and_ctcp_text (a_nick_name, a_text))
		end

	notice (a_target, a_text: STRING) is
			-- Send a message to a channel or a nick name. Automatic
			-- replies will never be send in response to `notice', this
			-- is the main difference with `privmsg'.
		require
			target_not_empty: a_target /= Void and then not a_target.is_empty
			is_valid_text: is_valid_text (a_text)
		do
			put_message (commands.notice, combine_param_and_full_text (a_target, a_text))
		end

	privmsg (a_target, a_text: STRING) is
			-- Send `a_text' to a channel or a nick name. It is equal to
			-- the /msg command.
		require
			target_not_empty: a_target /= Void and then not a_target.is_empty
			is_valid_text: is_valid_text (a_text)
		do
			put_message (commands.privmsg, combine_param_and_full_text (a_target, a_text))
		end


feature -- DCC

	dcc_chat_requests: DS_LIST [EPX_IRC_DCC_CHAT_ACCEPTOR]
			-- List of DCC chat requests that have been received;
			-- If not 'is_open', it means the request has not yet been
			-- accepted or the session has been closed.

	dcc_chat (a_nick_name: STRING) is
			-- Attempt to initiate a chat connection with `a_nick_name'.
			-- It is equal to /dcc chat a_nick_name.
			-- Only supports IPv4. Probably does not work behind firewall.
			-- Also doesn't work when tunneling through `sslclient'.
		require
			real_socket: not is_secure_connection
		local
			ip4: EPX_IP4_ADDRESS
			chat: EPX_IRC_DCC_CHAT_INITIATOR
		do
			ip4 ?= tcp_socket.local_address.address
				check
					is_ip4: ip4 /= Void
				end
			create chat.make_initiate (a_nick_name, ip4)
			-- TODO: WARNING, DOESN'T WORK if IP4 address > 2^31!!!
				check
					ip_address_not_negative: chat.local_ip4_address.value >= 0
				end
			ctcp (a_nick_name, "DCC CHAT chat " + chat.local_ip4_address.value.out + " " + chat.local_port.out)
			last_dcc_chat_offer := chat
		end

	last_dcc_chat_offer: EPX_IRC_DCC_CHAT_INITIATOR
			-- Last offered DCC chat session by `dcc_chat'


feature {EPX_IRC_PONG} -- Miscellaneous

	pong (a_server: STRING) is
			-- Reply to ping message.
		require
			a_server_not_empty: a_server /= Void and then not a_server.is_empty
		do
			put_message (commands.pong, a_server)
		end


feature {NONE} -- Implementation

	combine_param_and_ctcp_text (a_param, a_text: STRING): STRING is
			-- Combine `a_param' and the CTCP marked and encoded `a_text'
		require
			param_not_empty: a_param /= Void and then not a_param.is_empty
			text_not_empty: a_text /= Void and then not a_text.is_empty
		local
			s, t: STRING
		do
			t := ctcp_quote (a_text)
			create s.make (2 + t.count)
			s.append_character (ctcp_x_delimiter)
			s.append_string (t)
			s.append_character (ctcp_x_delimiter)
			Result := combine_param_and_full_text (a_param, s)
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	combine_param_and_full_text (a_param, a_text: STRING): STRING is
		require
			param_not_empty: a_param /= Void and then not a_param.is_empty
			is_valid_text: is_valid_text (a_text)
		do
			create Result.make (a_param.count + 2 + a_text.count)
			Result.append_string (a_param)
			Result.append_character (' ')
			Result.append_character (':')
			Result.append_string (a_text)
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	commands: EPX_IRC_COMMANDS is
		once
			create Result
		ensure
			not_void: Result /= Void
		end

	log_file: STDC_TEXT_FILE
			-- If set, session requests and responses are written to this
			-- file

	put_message (a_command, a_parameter: STRING) is
			-- Send `a_message' and optional `a_parameter' to server.
		require
			command_valid: is_valid_command (a_command)
			parameter_not_invalid:
				a_parameter = Void or else
				(not a_parameter.has ('%U') and
				 not a_parameter.has ('%N') and
				 not a_parameter.has ('%R'))
		local
			cmd: STRING
		do
			if a_parameter = Void or else a_parameter.is_empty then
				create cmd.make (a_command.count + 2)
			else
				create cmd.make (a_command.count + 1 + a_parameter.count + 2)
			end
			cmd.append_string (a_command)
			if a_parameter /= Void and then not a_parameter.is_empty then
				cmd.append_character (' ')
				cmd.append_string (a_parameter)
			end
			debug ("test")
				print ("->")
				print (cmd)
				print ("%N")
			end
			if log_response then
				log_file.put_string ("->")
				log_file.put_string (cmd)
				log_file.put_character ('%N')
				log_file.flush
			end
			cmd.append_character ('%R')
			cmd.append_character ('%N')
			socket.put_string (cmd)
		end

	reply_codes: EPX_IRC_REPLY_CODES is
			-- Standard reply codes
		once
			create Result
		ensure
			not_void: Result /= Void
		end

	system_handlers: DS_LIST [EPX_IRC_MESSAGE_HANDLER]
			-- System defined handlers for incoming messages


invariant

	message_of_the_day_not_void: message_of_the_day /= Void

	nick_name_not_empty: nick_name /= Void and then not nick_name.is_empty
	real_name_not_empty: real_name /= Void and then not real_name.is_empty

	last_response_and_last_message_set: (last_response = Void) = (last_message = Void)

	system_handlers_not_void: system_handlers /= Void
	message_handlers_not_void: message_handlers /= Void
	dcc_chat_requests_not_void: dcc_chat_requests /= Void

	no_support_for_sslclient: not is_secure_connection

end
