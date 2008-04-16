indexing

	description:

		"Receives and sets message_of_the_day in `client'."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/12/18 $"
	revision: "$Revision: #2 $"


class

	EPX_IRC_MOTD


inherit

	EPX_IRC_MESSAGE_HANDLER


creation

	make


feature {EPX_IRC_CLIENT} -- Handling

	handle (a_message: EPX_IRC_MESSAGE) is
			-- Respond to message if this is a message this instance can handle.
		do
			if a_message.has_reply_code then
				inspect a_message.reply_code
				when RPL_MOTDSTART then
					client.message_of_the_day.wipe_out
				when RPL_MOTD then
					if a_message.parameters.count >= 2 then
						client.message_of_the_day.append_string (a_message.parameters.item (2))
						client.message_of_the_day.append_character ('%N')
					end
				else
					-- ignore
				end
			end
		end

end
