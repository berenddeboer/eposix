indexing

	description: "List of once strings for IMAP4rev1 commands."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_IMAP4_COMMANDS


feature

	imap4_command_check: STRING is "CHECK"
	imap4_command_close: STRING is "CLOSE"
	imap4_command_copy: STRING is "COPY"
	imap4_command_create: STRING is "CREATE"
	imap4_command_delete: STRING is "DELETE"
	imap4_command_examine: STRING is "EXAMINE"
	imap4_command_expunge: STRING is "EXPUNGE"
	imap4_command_fetch: STRING is "FETCH"
	imap4_command_list: STRING is "LIST"
	imap4_command_lsub: STRING is "LSUB"
	imap4_command_login: STRING is "LOGIN"
	imap4_command_logout: STRING is "LOGOUT"
	imap4_command_noop: STRING is "NOOP"
	imap4_command_select: STRING is "SELECT"
	imap4_command_store: STRING is "STORE"


end
