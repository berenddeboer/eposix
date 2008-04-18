indexing

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

	data: STRING is "DATA"
	ehlo: STRING is "EHLO"
	expn: STRING is "EXPN"
	helo: STRING is "HELO"
	help: STRING is "HELP"
	mail: STRING is "MAIL"
	noop: STRING is "NOOP"
	quit: STRING is "QUIT"
	rcpt: STRING is "RCPT"
	rset: STRING is "RSET"
	vrfy: STRING is "VRFY"


end
