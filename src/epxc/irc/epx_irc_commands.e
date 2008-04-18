indexing

	description:

		"IRC commands"

	library: "eposix"
	standards: "RFC 2812"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_IRC_COMMANDS


feature -- Access

	invite: STRING is "INVITE"
	join: STRING is "JOIN"
	kick: STRING is "KICK"
	list: STRING is "LIST"
	lusers: STRING is "LUSERS"
	mode: STRING is "MODE"
	motd: STRING is "MOTD"
	names: STRING is "NAMES"
	notice: STRING is "NOTICE"
	nick: STRING is "NICK"
	part: STRING is "PART"
	pass: STRING is "PASS"
	ping: STRING is "PING"
	pong: STRING is "PONG"
	privmsg: STRING is "PRIVMSG"
	quit: STRING is "QUIT"
	topic: STRING is "TOPIC"
	user: STRING is "USER"
	version: STRING is "VERSION"

end
