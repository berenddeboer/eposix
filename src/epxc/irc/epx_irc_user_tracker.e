indexing

	description:

		"Tracks user joining and leaving a given channel"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_IRC_USER_TRACKER


inherit

	EPX_IRC_CHANNEL_HANDLER

	EPX_EXTERNAL_HELPER
		export
			{NONE} all
		end


create

	make


feature {EPX_IRC_CHANNEL, EPX_IRC_CHANNEL_HANDLER} -- Handling

	handle (a_message: EPX_IRC_MESSAGE) is
			-- Respond to message if this is a message this instance can handle.
			-- `a_message' is always destined for `channel'.
		local
			names_string: STRING
			names: ARRAY [STRING]
			i: INTEGER
			nick_name: STRING
		do
			if
				a_message.nick_name /= Void
			then
				if a_message.command.is_equal (commands.join) then
					channel.user_joined (a_message)
					elseif
						a_message.command.is_equal (commands.part) or else
						a_message.command.is_equal (commands.quit)
					then
					channel.users.search (a_message.nick_name)
					if channel.users.found then
						channel.user_left (a_message)
					end
				elseif a_message.command.is_equal (commands.nick) then
					channel.users.search (a_message.nick_name)
					if channel.users.found then
						channel.user_nick_name_change (a_message)
					end
				end
			elseif
				a_message.reply_code = RPL_NAMREPLY and then
				a_message.parameters.count = 4
			then
				names_string := a_message.parameters.item (4)
				names := sh.split_on (names_string, ' ')
				from
					i := names.lower
				until
					i > names.upper
				loop
					nick_name := names.item (i)
					sh.trim (nick_name)
					if not nick_name.is_empty then
						-- @: channel operator
						-- %: half operator
						-- !: service
						-- +: voiced
						-- .: founder
						if
							nick_name.item (1) = '@' or else
							nick_name.item (1) = '%%' or else
							nick_name.item (1) = '!' or else
							nick_name.item (1) = '+' or else
							nick_name.item (1) = '.'
						then
							nick_name.remove (1)
						end
						if not nick_name.is_empty then
							channel.user_in_channel (nick_name)
						end
					end
					i := i + 1
				end
			end
		end


end
