indexing

	description: "EPX_MIME_HEADER with convenience routines for creating an email."

	standards: "RFC 2822"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_MIME_EMAIL_HEADER


inherit

	EPX_MIME_HEADER
		redefine
			make_default
		end


create

	make_default


feature {NONE} -- Initialization

	make_default is
		local
			now: STDC_TIME
			version: EPX_MIME_FIELD_MIME_VERSION
		do
			precursor
			create version.make (1, 0)
			add_field (version)
			create now.make_from_now
			now.to_local
			create date_field.make (now)
			add_field (date_field)
			create message_id_field.make_unique
			add_field (message_id_field)
		end


feature -- Status

	is_valid_email_address (an_email_address: STRING): BOOLEAN is
			-- Is `an_email_address' a valid email address?
		do
			-- TODO: not complete
			Result := an_email_address /= Void and then not an_email_address.is_empty
		end


feature -- Access

	date: STRING is
			-- Contents of Date field
		do
			Result := date_field.value
		ensure
			date_not_empty: Result /= Void and then not Result.is_empty
		end

	message_id: STRING is
			-- Contents of Message-Id field;
			-- Contaains a single unique message identifier.
		do
			Result := message_id_field.address_specification
		ensure
			message_id_not_empty: Result /= Void and then not Result.is_empty
		end

	reply_to: STRING is
			-- Contents of Reply-to field;
			-- Contains the mailbox(es) to which the author of the
			-- message suggests that replies be sent.
		require
			has_reply_to_field: reply_to_field /= Void
		do
			Result := reply_to_field.value
		ensure
			reply_to_not_void: Result /= Void
		end

	from_: STRING is
			-- Contents of From field;
			-- Contains the author(s) of the message, that is, the
			-- mailbox(es) of the person(s) or system(s) responsible for
			-- the writing of the message.
		require
			has_from_field: from_field /= Void
		do
			Result := from_field.value
		ensure
			from_not_void: Result /= Void
		end

	subject: STRING is
			-- Contents of Subject field
		require
			has_subject_field: subject_field /= Void
		do
			Result := subject_field.value
		ensure
			subject_not_void: Result /= Void
		end

	to: STRING is
			-- Contents of To field;
			-- Contains the address(es) of the primary recipient(s) of
			-- the message.
		require
			has_to_field: to_field /= Void
		do
			Result := to_field.value
		ensure
			to_not_void: Result /= Void
		end


feature -- Access to well-known fields

	bcc_field: EPX_MIME_UNSTRUCTURED_FIELD is
			-- Field "Bcc" if it exists, else Void.
		do
			fields.search (field_name_bcc)
			if fields.found then
				-- Oops, this may fail if user tricks us...
				Result ?= fields.found_item
			end
		ensure
			definition: fields.has (field_name_bcc) = (Result /= Void)
		end

	cc_field: EPX_MIME_UNSTRUCTURED_FIELD is
			-- Field "Cc" if it exists, else Void.
		do
			fields.search (field_name_cc)
			if fields.found then
				-- Oops, this may fail if user tricks us...
				Result ?= fields.found_item
			end
		ensure
			definition: fields.has (field_name_cc) = (Result /= Void)
		end

	date_field: EPX_MIME_FIELD_DATE
			-- Field "Date"

	from_field: EPX_MIME_UNSTRUCTURED_FIELD is
			-- Field `From' if it exists, else Void.
		do
			fields.search (field_name_from)
			if fields.found then
				-- Oops, this may fail if user tricks us...
				Result ?= fields.found_item
			end
		ensure
			definition: fields.has (field_name_from) = (Result /= Void)
		end

	message_id_field: EPX_MIME_FIELD_MESSAGE_ID
			-- Field "Message-Id"

	reply_to_field: EPX_MIME_UNSTRUCTURED_FIELD is
			-- Field "Reply_To" if it exists, else Void.
		do
			fields.search (field_name_reply_to)
			if fields.found then
				-- Oops, this may fail if user tricks us...
				Result ?= fields.found_item
			end
		ensure
			definition: fields.has (field_name_reply_to) = (Result /= Void)
		end

	subject_field: EPX_MIME_UNSTRUCTURED_FIELD is
			-- Field "Subject" if it exists, else Void.
		do
			fields.search (field_name_subject)
			if fields.found then
				-- Oops, this may fail if user tricks us...
				Result ?= fields.found_item
			end
		ensure
			definition: fields.has (field_name_subject) = (Result /= Void)
		end

	to_field: EPX_MIME_UNSTRUCTURED_FIELD is
			-- Field "To" if it exists, else Void.
		do
			fields.search (field_name_to)
			if fields.found then
				-- Oops, this may fail if user tricks us...
				Result ?= fields.found_item
			end
		ensure
			definition: fields.has (field_name_to) = (Result /= Void)
		end


feature -- Change

	set_bcc (a_name, an_email: STRING) is
			-- Set blind carbon copy recipient of email.
		require
			email_not_empty: an_email /= Void and then not an_email.is_empty
		do
			set_email_field (Void, field_name_bcc, a_name, an_email)
		end

	set_cc (a_name, an_email: STRING) is
			-- Set carbon copy recipient of email.
		require
			email_not_empty: an_email /= Void and then not an_email.is_empty
		do
			set_email_field (Void, field_name_cc, a_name, an_email)
		end

	set_from (a_name, an_email: STRING) is
			-- Set author responsible for writing the message.
			-- Should be set only to a mailbox that belongs to the
			-- author(s) of the message.
		require
			email_not_empty: an_email /= Void and then not an_email.is_empty
		do
			set_email_field (from_field, field_name_from, a_name, an_email)
		ensure
			from_field_set: from_field /= Void
			from_name_set: a_name /= Void implies from_.has_substring (a_name)
			from_email_set: from_.has_substring (an_email)
		end

	set_reply_to (a_name, an_email: STRING) is
			-- Set the mailbox to which the author of the message
			-- suggests that replies be sent.
		require
			email_not_empty: an_email /= Void and then not an_email.is_empty
		do
			set_email_field (reply_to_field, field_name_reply_to, a_name, an_email)
		ensure
			reply_to_field_set: reply_to_field /= Void
			reply_to_name_set: a_name /= Void implies reply_to.has_substring (a_name)
			reply_to_email_set: reply_to.has_substring (an_email)
		end

	set_subject (a_subject: STRING) is
			-- Set subject of email.
		require
			subject_not_empty: a_subject /= Void and then not a_subject.is_empty
		local
			field: EPX_MIME_UNSTRUCTURED_FIELD
		do
			field := subject_field
			if field = Void then
				create field.make (field_name_subject, a_subject)
				add_field (field)
			else
				field.set_value (a_subject)
			end
		ensure
			subject_field_set: subject_field /= Void
			subject_set: subject.is_equal (a_subject)
		end

	set_to (a_name, an_email: STRING) is
			-- Set recipient of email.
		require
			email_not_empty: an_email /= Void and then not an_email.is_empty
		do
			set_email_field (to_field, field_name_to, a_name, an_email)
		ensure
			to_field_set: to_field /= Void
			to_name_set: a_name /= Void implies to.has_substring (a_name)
			to_email_set: to.has_substring (an_email)
		end


feature {NONE} -- Implementation

	set_email_field (a_field: EPX_MIME_UNSTRUCTURED_FIELD; a_field_name, a_name, an_email: STRING) is
			-- Set field which takes an email address.
		require
			valid_email_address: is_valid_email_address (an_email)
		local
			field: EPX_MIME_UNSTRUCTURED_FIELD
			value: STRING
		do
			if a_name = Void or else a_name.is_empty then
				value := an_email
			else
				value := a_name + once " <" + an_email + once ">"
			end
			field := a_field
			if field = Void then
				create field.make (a_field_name, value)
				add_field (field)
			else
				field.set_value (value)
			end
		ensure
			field_exists: fields.has (a_field_name)
		end


invariant

	has_date_field: date_field /= Void
	has_message_id_field: message_id_field /= Void

end
