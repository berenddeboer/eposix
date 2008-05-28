indexing

	description: "IMAP4rev1 mailbox as seen by a client."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_IMAP4_MAILBOX


create

	make


feature {NONE} -- Initialization

	make (a_name: STRING) is
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
			count := -1
			recent := -1
			unseen := -1
		end


feature -- Mailbox data

	identifier: INTEGER
			-- Associated with every mailbox is a unique identifier
			-- validity value, which is sent in an UIDVALIDITY response
			-- code in an OK untagged response at mailbox selection time.

	is_writable: BOOLEAN
			-- Is mailbox opened for writing?

	name: STRING
			-- Name of the mailbox.


feature -- Messages in mailbox

	count: INTEGER
			-- The number of messages in the mailbox (EXISTS response).
			-- Value is -1 if unknown.

	recent: INTEGER
			-- The number of messages with the \Recent flag set.
			-- Value is -1 if unknown.

	unseen: INTEGER
			-- Message sequence number of the first unseen message in the
			-- mailbox.
			-- Value is -1 if unknown.


feature -- Set mailbox data

	set_identifier (a_mailbox_identifier: INTEGER) is
			-- Set `identifier'.
		do
			identifier := a_mailbox_identifier
		ensure
			mailbox_identifier_set: identifier = a_mailbox_identifier
		end

	set_is_writable (a_is_writable: BOOLEAN) is
			-- Set `is_writable'
		do
			is_writable := a_is_writable
		ensure
			is_writable_set: is_writable = a_is_writable
		end


feature -- Set messages in mailbox data

	set_count (a_count: INTEGER) is
			-- Set `count'.
		require
			valid_count: a_count >= -1
		do
			count := a_count
		ensure
			count_set: count = a_count
		end

	set_recent (a_recent: INTEGER) is
			-- Set `recent'.
		require
			valid_recent: a_recent >= -1
		do
			recent := a_recent
		ensure
			recent_set: recent = a_recent
		end

	set_unseen (a_unseen: INTEGER) is
			-- Set `unseen'.
		require
			valid_unseen: a_unseen >= -1
		do
			unseen := a_unseen
		ensure
			unseen_set: unseen = a_unseen
		end


invariant

	name_not_empty: name /= Void and then not name.is_empty
	valid_count: count >= -1
	valid_recent: recent >= -1
	valid_unseen: unseen >= -1

end
