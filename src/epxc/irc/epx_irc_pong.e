indexing

	description:

		"Replies with PONG after receiving a PING"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	EPX_IRC_PONG


inherit

	EPX_IRC_MESSAGE_HANDLER


create

	make


feature {EPX_IRC_CLIENT} -- Handling

	handle (a_message: EPX_IRC_MESSAGE) is
			-- Respond to message if this is a message this instance can handle.
		do
			if
				a_message.command.is_equal (commands.ping) and then
				not a_message.parameters.is_empty
			then
				client.pong (a_message.parameters.last)
			end
		end

end
