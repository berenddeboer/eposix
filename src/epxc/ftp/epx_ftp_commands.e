indexing

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

	cdup: STRING is "CDUP"
	cwd: STRING is "CWD"
	dele: STRING is "DELE"
	help: STRING is "HELP"
	list: STRING is "LIST"
	nlst: STRING is "NLST"
	logout: STRING is "QUIT"
	mkd: STRING is "MKD"
	mode: STRING is "MODE"
	noop: STRING is "NOOP"
	passive: STRING is "PASV"
	password: STRING is "PASS"
	port: STRING is "PORT"
	quit: STRING is "QUIT"
	retr: STRING is "RETR"
	rmd: STRING is "RMD"
	rnfr: STRING is "RNFR"
	rnto: STRING is "RNTO"
	stat: STRING is "STAT"
	stor: STRING is "STOR"
	syst: STRING is "SYST"
	type: STRING is "TYPE"
	user: STRING is "USER"

end
