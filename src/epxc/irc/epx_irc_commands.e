note

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

	invite: STRING = "INVITE"
	join: STRING = "JOIN"
	kick: STRING = "KICK"
	list: STRING = "LIST"
	lusers: STRING = "LUSERS"
	mode: STRING = "MODE"
	motd: STRING = "MOTD"
	names: STRING = "NAMES"
	notice: STRING = "NOTICE"
	nick: STRING = "NICK"
	part: STRING = "PART"
	pass: STRING = "PASS"
	ping: STRING = "PING"
	pong: STRING = "PONG"
	privmsg: STRING = "PRIVMSG"
	quit: STRING = "QUIT"
	topic: STRING = "TOPIC"
	user: STRING = "USER"
	version: STRING = "VERSION"

end
