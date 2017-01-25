note

	description:

		"NetLogger API Reserved field names"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"


class

	NET_LOGGER_RESERVED_NAMES


feature -- Access

	event: STRING = "event"
			-- Log event name

	timestamp: STRING = "ts"
			-- Timestamp

	level: STRING = "level"
			-- Logging level

	status: STRING = "status"
			-- Integer status code

	prog: STRING = "prog"
			-- Program name

	user: STRING = "user"

	host: STRING = "host"

	local_host: STRING = "localHost"

	remote_host: STRING = "remoteHost"

	msg: STRING = "msg"
			-- Error/status message string

end
