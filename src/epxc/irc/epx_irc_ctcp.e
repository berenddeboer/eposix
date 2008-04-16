indexing

	description:

		"Recognises and handles CTCP queries and requests"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2007/05/18 $"
	revision: "$Revision: #2 $"


class

	EPX_IRC_CTCP


inherit

	EPX_IRC_MESSAGE_HANDLER

	EPX_IRC_CTCP_ENCODING
		export
			{NONE} all
		end

	EPX_IRC_CTCP_COMMANDS
		export
			{NONE} all
		end


creation

	make


feature -- Status

	is_extended_message (a_message: EPX_IRC_MESSAGE): BOOLEAN is
			-- Does `a_message' have CTCP encoded data?
		do
			Result :=
				a_message.parameters.count = 2 and then
				(a_message.nick_name /= Void) and then
				(a_message.command.is_equal (commands.privmsg) or else
				 a_message.command.is_equal (commands.notice)) and then
				(a_message.parameters.item (2).has (ctcp_x_delimiter))
		end


feature {EPX_IRC_CLIENT} -- Handling

	handle (a_message: EPX_IRC_MESSAGE) is
			-- Respond to message if this is a message this instance can handle.
		local
			extended_messages: DS_LIST [EPX_IRC_CTCP_MESSAGE]
			c: DS_LINEAR_CURSOR [EPX_IRC_CTCP_MESSAGE]
			chat: EPX_IRC_DCC_CHAT_ACCEPTOR
			ip_address: EPX_IP4_ADDRESS
			unsigned_int: INTEGER_64
		do
			if is_extended_message (a_message) then
				-- Extract all embedded CTCP messages.
				extended_messages := extract_extended_messages (a_message.parameters.item (2))
				-- And respond to them if needed
				-- TODO: should do this by using EXP_IRC_CTCP_HANDLER
				-- More consistent design.
				from
					c := extended_messages.new_cursor
					c.start
				until
					c.after
				loop
					if c.item.tag.is_equal (ctcp_dcc) then
						if
							not c.item.parameters.is_empty and then
							c.item.parameters.item (1).is_equal (ctcp_dcc_type_chat) and then
							c.item.parameters.item (2).as_lower.is_equal (ctcp_dcc_chat_argument) and then
							c.item.parameters.item (3).is_integer and then
							c.item.parameters.item (4).is_integer
						then
							unsigned_int := c.item.parameters.item (3).to_integer_64
							create ip_address.make_from_integer (unsigned_int.to_integer)
							debug ("test")
								print ("got ip address: ")
								print (ip_address.out)
								print ("%N")
							end
							create chat.make (a_message.nick_name, ip_address, c.item.parameters.item (4).to_integer)
							client.dcc_chat_requests.force_last (chat)
						end
					end
					c.forth
				end
			end
		end


end
