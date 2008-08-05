indexing

	description:

		"Class that can process an incoming message."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	EPX_IRC_MESSAGE_HANDLER


inherit

	ANY

	EPX_IRC_REPLY_CODES
		export
			{NONE} all
		end


feature {NONE} -- Initialization

	make (a_client: EPX_IRC_CLIENT) is
			-- Initialize.
		require
			client_not_void: a_client /= Void
		do
			client := a_client
		end


feature -- Access

	client: EPX_IRC_CLIENT
			-- Client to which this handler is connected


feature {EPX_IRC_CLIENT, EPX_IRC_MESSAGE_HANDLER} -- Handling

	handle (a_message: EPX_IRC_MESSAGE) is
			-- Respond to message if this is a message this instance can handle.
		require
			a_message_not_void: a_message /= Void
			client_open: client.is_open
		deferred
		end


feature {NONE} -- Implementation

	commands:  EPX_IRC_COMMANDS is
		once
			create Result
		ensure
			not_void: Result /= Void
		end


invariant

	client_not_void: client /= Void

end
