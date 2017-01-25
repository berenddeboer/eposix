note

	description:

		"FTP commands"

	standards: "RFC 959"
	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	EPX_FTP_COMMANDS

feature -- Access

	cdup: STRING = "CDUP"
	cwd: STRING = "CWD"
	dele: STRING = "DELE"
	help: STRING = "HELP"
	list: STRING = "LIST"
	nlst: STRING = "NLST"
	logout: STRING = "QUIT"
	mkd: STRING = "MKD"
	mode: STRING = "MODE"
	noop: STRING = "NOOP"
	passive: STRING = "PASV"
	password: STRING = "PASS"
	port: STRING = "PORT"
	quit: STRING = "QUIT"
	retr: STRING = "RETR"
	rmd: STRING = "RMD"
	rnfr: STRING = "RNFR"
	rnto: STRING = "RNTO"
	stat: STRING = "STAT"
	stor: STRING = "STOR"
	syst: STRING = "SYST"
	type: STRING = "TYPE"
	user: STRING = "USER"

end
