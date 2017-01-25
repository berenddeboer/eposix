note

	description: "List of once strings for IMAP4rev1 commands."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_IMAP4_COMMANDS


feature

	imap4_command_check: STRING = "CHECK"
	imap4_command_close: STRING = "CLOSE"
	imap4_command_copy: STRING = "COPY"
	imap4_command_create: STRING = "CREATE"
	imap4_command_delete: STRING = "DELETE"
	imap4_command_examine: STRING = "EXAMINE"
	imap4_command_expunge: STRING = "EXPUNGE"
	imap4_command_fetch: STRING = "FETCH"
	imap4_command_list: STRING = "LIST"
	imap4_command_lsub: STRING = "LSUB"
	imap4_command_login: STRING = "LOGIN"
	imap4_command_logout: STRING = "LOGOUT"
	imap4_command_noop: STRING = "NOOP"
	imap4_command_select: STRING = "SELECT"
	imap4_command_store: STRING = "STORE"


end
