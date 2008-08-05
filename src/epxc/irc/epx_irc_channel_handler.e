indexing

	description:

		"Class that can process an incoming message for a specific channel."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	EPX_IRC_CHANNEL_HANDLER


inherit

	ANY

	EPX_IRC_REPLY_CODES
		export
			{NONE} all
		end


feature {NONE} -- Initialization

	make (a_channel: EPX_IRC_CHANNEL) is
			-- Initialize.
		require
			channel_not_void: a_channel /= Void
		do
			channel := a_channel
		end


feature -- Access

	channel: EPX_IRC_CHANNEL
			-- Channel to which this handler is connected


feature {EPX_IRC_CHANNEL, EPX_IRC_CHANNEL_HANDLER} -- Handling

	handle (a_message: EPX_IRC_MESSAGE) is
			-- Respond to message if this is a message this instance can handle.
			-- `a_message' is always destined for `channel'.
		require
			a_message_not_void: a_message /= Void
			channel_open: channel.is_open
		deferred
		end


feature {NONE} -- Implementation

	commands: EPX_IRC_COMMANDS is
		once
			create Result
		ensure
			not_void: Result /= Void
		end


invariant

	channel_not_void: channel /= Void

end
