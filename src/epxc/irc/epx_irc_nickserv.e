indexing

	description:

		"Recognize NickServ requests for passwords and respond if password known"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_IRC_NICKSERV


inherit

	EPX_IRC_MESSAGE_HANDLER

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end


create

	make


feature {EPX_IRC_CLIENT} -- Handling

	handle (a_message: EPX_IRC_MESSAGE) is
			-- Respond to message if this is a message this instance can handle.
		local
			password_request,
			password_accepted: BOOLEAN
		do
			if
				a_message.nick_name /= Void and then
				a_message.command.is_equal (commands.notice) and then
				STRING_.same_string (a_message.nick_name.as_upper, NickServ) and then
				a_message.parameters.count = 2 and then
				STRING_.same_string (a_message.parameters.item (1), client.nick_name)
			then
				password_request :=
					a_message.parameters.item (2).has_substring (once_msg_command) and then
					a_message.parameters.item (2).has_substring (once_identify)
				password_accepted :=
					not password_request and then
					a_message.parameters.item (2).has_substring (once_password_accepted)
				if password_request then
					client.nickserv_passwords.search (client.nick_name)
					if client.nickserv_passwords.found then
						client.privmsg ("NickServ", "IDENTIFY " + client.nickserv_passwords.found_item)
						is_password_sent := True
					end
				elseif password_accepted then
					is_password_accepted := True
				end
			end
		end


feature -- Status

	is_password_accepted: BOOLEAN
			-- Has NickServ accepted the password?

	is_password_sent: BOOLEAN
			-- Has NickServ requested a password and has it been sent?


feature -- Access

	NickServ: STRING is "NICKSERV"
			-- the NickServ nick name


feature {NONE} -- Once strings

	once_password_accepted: STRING is "Password accepted"

	once_msg_command: STRING is "/msg"

	once_identify: STRING is "IDENTIFY"

end
