note

	description:

		"Commands that can be send to an SMTP server"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	EPX_SMTP_COMMANDS


feature -- Access

	data: STRING = "DATA"
	ehlo: STRING = "EHLO"
	expn: STRING = "EXPN"
	helo: STRING = "HELO"
	help: STRING = "HELP"
	mail: STRING = "MAIL"
	noop: STRING = "NOOP"
	quit: STRING = "QUIT"
	rcpt: STRING = "RCPT"
	rset: STRING = "RSET"
	vrfy: STRING = "VRFY"


end
