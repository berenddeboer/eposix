indexing

	description:

		"SMTP protocol client"

	standards: "based on RFC 2821 (protocol), RFC 2920 (pipe lining), RFC 1652 (8 bit messages)"
	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_SMTP_CLIENT


inherit

	EPX_TCP_CLIENT_WITH_REPLY_CODE_BASE
		rename
			make as make_authenticate,
			make_with_port as make_authenticate_with_port,
			socket as smtp
		redefine
			close
		end

	STDC_CURRENT_PROCESS

create

	make,
	make_with_port


feature {NONE} -- Initialization

	make (a_server_name: STRING) is
			-- Initialize.
		require
			valid_server_name: a_server_name /= Void and then not a_server_name.is_empty
		do
			make_with_port (a_server_name, 0)
		end

	make_with_port (a_server_name: STRING; a_port: INTEGER) is
			-- Initialize with a given port. If `a_port' is null the
			-- `default_port' is taken.
		require
			valid_server_name: a_server_name /= Void and then not a_server_name.is_empty
			valid_port: a_port >= 0 and then a_port <= 65535

		local
			tester: KL_STRING_EQUALITY_TESTER
		do
			make_authenticate_with_port (a_server_name, a_port, Void, Void)
			create capabilities.make (8)
			create tester
			capabilities.set_equality_tester (tester)
		end


feature -- Open/close

	close is
		do
			is_authenticated := False
			precursor
			capabilities.wipe_out
		end


feature -- Status

	is_client_identified: BOOLEAN
			-- Has the client identified itself?

	supports_8_bit_mime: BOOLEAN is
			-- Does SMTP server support 8 bit MIME messages?
		do
			Result := capabilities.has (once_8bitmime)
		end

	supports_pipelining: BOOLEAN is
			-- Does SMTP server accommodate SMTP command pipelining?
			-- I.e. a client can send multiple commands without having to
			-- read replies first.
		do
			Result := capabilities.has (once_pipelining)
		end

	is_valid_domain (a_domain: STRING): BOOLEAN is
			-- Is `a_domain' a valid domain? It must have between 1 and
			-- 255 characters, and not solely consist of white space.
		do
			Result :=
				a_domain /= Void and then
				not a_domain.is_empty and then
				a_domain.count <= 255
		end


feature -- Access

	capabilities: DS_HASH_SET [STRING]
			-- List of capabilities supported by server;
			-- retrieved by `ehlo'.
			-- To make searching for specific capabilities easier, all
			-- capabilities are in uppercase.

	default_port: INTEGER is 25

	default_port_name: STRING is
		do
			Result := once_smtp
		end

	max_message_size: INTEGER
			-- Maximum message size supported by the server;
			-- Retrieved by `ehlo', and only set if server supports this.


feature -- Commands

	ehlo (a_domain: STRING) is
			-- This command is used to identify the SMTP client to the
			-- SMTP server.  The argument field contains the
			-- fully-qualified domain name of the SMTP client if one is
			-- available.  In situations in which the SMTP client system
			-- does not have a meaningful domain name (e.g., when its
			-- address is dynamically allocated and no reverse mapping
			-- record is available), the client SHOULD send an address
			-- literal, optionally followed by information that will help
			-- to identify the client system.
		require
			ready_for_commands: is_accepting_commands
			valid_domain: is_valid_domain (a_domain)
		do
			async_put_command (commands.ehlo, a_domain)
			read_capabilities
			is_client_identified := last_reply_code = 250
		ensure
			identified: last_reply_code = 250 implies is_client_identified
		end

	expand (a_mailing_list: STRING) is
			-- This command asks the receiver to confirm that the
			-- argument identifies a mailing list, and if so, to return
			-- the membership of that list.
		require
			ready_for_commands: is_accepting_commands
			mailing_list_not_empty: a_mailing_list /= Void and then not a_mailing_list.is_empty
		do
			put_command (commands.expn, a_mailing_list)
		end

	help is
			-- This command causes the server to send helpful information
			-- to the client. The command MAY take an argument (e.g., any
			-- command name) and return more specific information as a
			-- response.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command (commands.help, Void)
		end

	mail (an_email: EPX_SMTP_MAIL) is
			-- Send an email. Check `last_reply_code' if that is successful.
			-- TODO: if server does not support 8 bit MIME messages, it does
			-- not attempt to send only 7bit US ASCII characters.
		require
			ready_for_commands: is_accepting_commands
			ready_for_email: is_client_identified
			mail_not_void: an_email /= Void
			only_8bit_mime_servers_supported: supports_8_bit_mime
		local
			c: DS_LINEAR_CURSOR [STRING]
			mail_from,
			mail_to: STRING
			message: STRING
		do
			mail_from := once "FROM:<" + an_email.sender_mailbox + once ">"
			if supports_8_bit_mime then
				mail_from.append_string (once " BODY=8BITMIME")
			end
			put_command (commands.mail, mail_from)
			debug ("eformmail")
				stderr.put_string (commands.mail + " " + mail_from + "%N")
				stderr.put_string ("MAIL reply code: " + last_reply_code.out + "%N")
			end
			c := an_email.recipients.new_cursor
			from
				c.start
			until
				c.after
			loop
				mail_to := once "TO:<" + c.item + once ">"
				put_command (commands.rcpt, mail_to)
				debug ("eformmail")
					stderr.put_string ("RCPT reply code: " + last_reply_code.out + "%N")
				end
				c.forth
			end
			put_command (commands.data, Void)
			if last_reply_code = 354 then
				message:= an_email.message.as_string
				correct_line_breaks (message)
				smtp.put_string (message)
				if
					message.count < 2 or else
					message.item (message.count) /= '%N' or else
					message.item (message.count - 1) /= '%R'
				then
					smtp.put_string (once "%R%N")
				end
				smtp.put_string (once ".%R%N")
				read_reply
			end
		end

	noop is
			-- This command does not affect any parameters or previously
			-- entered commands. It specifies no action other than that
			-- the receiver send an OK reply.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command (commands.noop, Void)
		end

	quit is
			-- This command specifies that the receiver MUST send an OK
			-- reply, and then close the transmission channel.
		require
			ready_for_commands: is_accepting_commands
		do
			put_command (commands.quit, Void)
		end

	verify (a_mailbox: STRING) is
			-- This command asks the receiver to confirm that the
			-- argument identifies a user or mailbox.
		require
			ready_for_commands: is_accepting_commands
			mailbox_not_empty: a_mailbox /= Void and then not a_mailbox.is_empty
		do
			put_command (commands.vrfy, a_mailbox)
		end


feature {NONE} -- Special reading

	read_capabilities is
			-- Read response to ehlo command.
		require
			open: is_open
		local
			no_more_lines: BOOLEAN
			line: STRING
			capability: STRING
		do
			from
				last_reply_code := 0
			until
				smtp.end_of_input or else
				no_more_lines
			loop
				smtp.read_line
				if not smtp.end_of_input then
					line := smtp.last_string
					if is_line_with_reply_code (line) then
						no_more_lines := line.item (4) = ' '
						if no_more_lines then
							last_reply_code := line.substring (1, 3).to_integer
							last_reply := line
						end
						if line.count >= 5 then
							capability := line.substring (5, line.count)
							capability.to_upper
							if
								capability.count > 5 and then
								capability.substring (1, 5).is_equal (once_size_space) and then
								capability.substring (6, capability.count).is_integer
							then
								max_message_size := capability.substring (6, capability.count).to_integer
								capabilities.force_last (once_size)
							else
								capabilities.force_last (capability)
							end
						end
					end
				end
			end
		end


feature {NONE} -- Authentication not relevant for SMTP

	is_authenticated: BOOLEAN

	authenticate is
		do
			read_until_server_ready_for_input
			is_authenticated := last_reply_code = 220
		end


feature {NONE} -- Lowest level SMTP server interaction

	commands: EPX_SMTP_COMMANDS is
			-- SMTP commands
		once
			create Result
		ensure
			not_void: Result /= Void
		end

	correct_line_breaks (a_message: STRING) is
			-- Change all lone LFs to CR LF.
			-- Replace all occurrences of "CR LF ." with "CR LF . .".
			-- See section 4.5.2 Transparency in RFC 2821.
		require
			message_not_void: a_message /= Void
		local
			p: INTEGER
			i: INTEGER
			c: CHARACTER
		do
			p := a_message.index_of ('.', 1)
			if p /= 0 then
				from
					i := p
				variant
					a_message.count - (i - 1)
				until
					i > a_message.count
				loop
					c := a_message.item (i)
					inspect c
					when '%N' then
						if i > 1 and then a_message.item (i - 1) /= '%R' then
							a_message.insert_character ('%R', i)
							i := i + 2
						else
							i := i + 1
						end
					when '.' then
						if
							i >= 3 and then
							a_message.item (i - 1) = '%N' and then
							a_message.item (i - 2) = '%R'
						then
							a_message.insert_character ('.', i)
							i := i + 2
						else
							i := i + 1
						end
					else
						i := i + 1
					end
				end
			end
		ensure
			not_this_forbidden_sequence: a_message.substring_index ("%R%N.%R%N", 1) = 0
			no_forbidden_sequence: True -- no "%R%N" follows any occurence of "%R%N."
			no_line_lfs: -- all %N preceded by %RF
		end


feature {NONE} -- Once strings

	once_8bitmime: STRING is "8BITMIME"
	once_pipelining: STRING is "PIPELINING"
	once_size: STRING is "SIZE"
	once_size_space: STRING is "SIZE "


invariant

	capabilities_not_void: capabilities /= Void

end
