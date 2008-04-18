indexing

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

  ctcp_finger: STRING is "FINGER"
		-- Obsolete

  ctcp_version: STRING is "VERSION"
		-- This is used to get information about the name of the other
		-- client and the version of it.

  ctcp_time: STRING is "TIME"


feature -- Known extended data

	ctcp_dcc: STRING is "DCC"


feature -- DCC specifics

	ctcp_dcc_type_chat: STRING is "CHAT"
	ctcp_dcc_type_send: STRING is "SEND"

	ctcp_dcc_chat_argument: STRING is "chat"

end
