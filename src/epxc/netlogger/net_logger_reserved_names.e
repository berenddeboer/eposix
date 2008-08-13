indexing

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

	event: STRING is "event"
			-- Log event name

	timestamp: STRING is "ts"
			-- Timestamp

	level: STRING is "level"
			-- Logging level

	status: STRING is "status"
			-- Integer status code

	prog: STRING is "prog"
			-- Program name

	user: STRING is "user"

	host: STRING is "host"

	local_host: STRING is "localHost"

	remote_host: STRING is "remoteHost"

	msg: STRING is "msg"
			-- Error/status message string

end
