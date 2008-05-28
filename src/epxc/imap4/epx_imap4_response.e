indexing

	description: "IMAP4rev1 server response."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_IMAP4_RESPONSE


create

	make


feature {NONE} -- Initialization

	make is
		do
			create response_code.make_empty
			create response_text_code.make_empty
			create mailboxes.make (4096)
		end


feature -- Result of last command

	is_bad: BOOLEAN is
			-- Is `response_code' equal to "BAD"?
		do
			Result := response_code = response_code_bad
		end

	bye_response_text: STRING
			-- Last response text for last received BYE.

	is_no: BOOLEAN is
			-- Is `response_code' equal to "NO"?
		do
			Result := response_code = response_code_no
		end

	is_ok: BOOLEAN is
			-- Is `response_code' equal to "OK"?
		do
			Result := response_code = response_code_ok
		end

	response_code: STRING
			-- Response code send by server.

	response_text_code: STRING
			-- Optional response text code send by server.

	response_text: STRING
			-- Response text send by server.


feature -- System responses

	delimiter: STRING
			-- Hierarchy delimiter. Empty if no delimiter, or delimiter
			-- not known.

	greeting_message: STRING
			-- Greeting message send by IMAP server.

	mailboxes: DS_HASH_TABLE [EPX_IMAP4_MAILBOX, STRING]
			-- Available mailboxes.


feature -- Mail box responses

	current_mailbox: EPX_IMAP4_MAILBOX
			-- Object where mailbox responses are stored into.


feature -- Set response data

	set_bad is
		do
			response_code := response_code_bad
		ensure
			bad: is_bad
		end

	set_bye is
		do
			response_code := response_code_bye
		end

	set_bye_response_text (a_text: STRING) is
		do
			if a_text = Void then
				bye_response_text := Void
			else
				create bye_response_text.make_from_string (a_text)
			end
		ensure
			bye_response_text_set: a_text = bye_response_text or else bye_response_text.is_equal (a_text)
		end

	set_no is
		do
			response_code := response_code_no
		ensure
			no: is_no
		end

	set_ok is
		do
			response_code := response_code_ok
		ensure
			ok: is_ok
		end

	set_response_text (a_text: STRING) is
		do
			if a_text = Void then
				create response_text.make_empty
			else
				create response_text.make_from_string (a_text)
			end
		ensure
			bye_response_text_set:
				(a_text = Void and then response_text /= Void and then response_text.is_empty) or else
				response_text.is_equal (a_text)
		end


feature -- Set system data

	set_delimiter (a_delimiter: STRING) is
		require
			delimiter_void_or_one_character: a_delimiter = Void or else a_delimiter.count = 1
		do
			delimiter := a_delimiter
		end

	set_greeting_message (a_message: STRING) is
		require
			greeting_message_not_empty: a_message /= Void and then not a_message.is_empty
		do
			greeting_message := a_message
		end


feature -- Set `current_mailbox'

	clear_current_mailbox is
			-- Unselect `current_mailbox'.
		do
			current_mailbox := Void
		ensure
			current_mailbox_void: current_mailbox = Void
		end

	set_current_mailbox (a_mailbox: EPX_IMAP4_MAILBOX) is
			-- Set `current_mailbox' to a known mailbox.
		require
			a_mailbox_not_void: a_mailbox /= Void
			known_mailbox: mailboxes.has_item (a_mailbox)
		do
			current_mailbox := a_mailbox
		ensure
			current_mailbox_set: current_mailbox = a_mailbox
		end

	set_new_current_mailbox (a_mailbox_name: STRING) is
			-- Set `current_mailbox' to a new mailbox.
		require
			a_mailbox_name_not_empty: a_mailbox_name /= Void and then not a_mailbox_name.is_empty
			mailbox_unknown: not mailboxes.has (a_mailbox_name)
		do
			create current_mailbox.make (a_mailbox_name)
			mailboxes.put (current_mailbox, current_mailbox.name)
		ensure
			current_mailbox_set: current_mailbox.name.is_equal (a_mailbox_name)
		end


feature -- Set message data

	new_current_message (a_sequence_number: INTEGER) is
			-- Make sure `current_message' contains a new, empty message
			-- if `a_sequence_number' is different from
			-- `current_message'.`sequence_number'.
		do
			if
				current_message = Void or else
				a_sequence_number = 0 or else
				current_message.sequence_number /= a_sequence_number
			then
				create current_message.make
				current_message.set_sequence_number (a_sequence_number)
			end
		ensure
			current_message_reset:
				current_message /= old current_message or else
				current_message.sequence_number = a_sequence_number
		end

	current_message: EPX_IMAP4_MESSAGE
			-- Object where message responses are stored into.


feature {NONE} -- Response codes

	response_code_bad: STRING is "BAD"

	response_code_bye: STRING is "BYE"

	response_code_no: STRING is "NO"

	response_code_ok: STRING is "OK"


invariant

	delimiter_void_or_one_character: delimiter = Void or else delimiter.count = 1
	mailboxes_not_void: mailboxes /= Void
	current_mailbox_known: current_mailbox /= Void implies mailboxes.has_item (current_mailbox)
	response_code_not_void: response_code /= Void
	response_text_code_not_void: response_text_code /= Void

end
