indexing

	description:

		"Abstraction of email that can be send with EPX_SMTP_CLIENT."

	usage: "Create an instance of this class and pass it to EPX_SMTP_CLIENT.mail."
	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	EPX_SMTP_MAIL


create

	make


feature {NONE} -- Initialization

	make (a_sender_mailbox, a_recipient_mailbox: STRING; a_message: EPX_MIME_PART) is
			-- Initialize with given sender mailbox and recipient
			-- mailbox. They may be totally unrelated to the contents of
			-- `a_message', and for spams they usually are.
			-- `a_message' is a MIME formatted message. But it's easier
			-- to use EPX_MIME_EMAIL, which inherits from EPX_MIME_PART,
			-- to create an email message instead of a plain
			-- EPX_MIME_PART.
		require
			message_not_void: a_message /= Void
		do
			sender_mailbox := a_sender_mailbox
			create recipients.make
			recipients.put_last (a_recipient_mailbox)
			message := a_message
		end


feature -- Access

	sender_mailbox: STRING
			-- Sender of this message

	recipients: DS_LINKED_LIST [STRING]
			-- Individual recipient of the mail data

	message: EPX_MIME_PART
			-- The actual email

feature -- Change

	add_recipient (a_recipient_mailbox: STRING) is
			-- Add a recipient to `recipients'.
		do
			recipients.put_last (a_recipient_mailbox)
		ensure
			one_more_recipient: recipients.count = old recipients.count + 1
		end


invariant

	message_not_void: message /= Void

	recipients_not_void: recipients /= Void

end
