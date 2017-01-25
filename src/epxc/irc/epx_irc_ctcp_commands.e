note

	description:

		"Known CTCP requests and extended data"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_IRC_CTCP_COMMANDS


feature -- Known requests

  ctcp_finger: STRING = "FINGER"
		-- Obsolete

  ctcp_version: STRING = "VERSION"
		-- This is used to get information about the name of the other
		-- client and the version of it.

  ctcp_time: STRING = "TIME"


feature -- Known extended data

	ctcp_dcc: STRING = "DCC"


feature -- DCC specifics

	ctcp_dcc_type_chat: STRING = "CHAT"
	ctcp_dcc_type_send: STRING = "SEND"

	ctcp_dcc_chat_argument: STRING = "chat"

end
