note

	description: "IMAP4rev1 message data as retrieved by a client."

	author: "Berend de Boer"


class

	EPX_IMAP4_MESSAGE


create

	make


feature {NONE} -- Initialization

	make
		do
			message := ""
			body := ""
			header := ""
			create {DS_HASH_SET [STRING]} flags.make_equal (16)
		end


feature -- Access

	flags: DS_SET [STRING]
			-- Retrieved message flags;
			-- If empty, no flags have been retrieved, or no flags have
			-- been set.

	message: STRING
			-- Last received message in RFC822 format

	body: STRING
			-- Last received message body;
			-- Independent from `message', only set when a raw RFC822
			-- body is sent.

	header: STRING
			-- Last received message header;
			-- Independent from `message', only set when a raw RFC822
			-- header is sent.

	sequence_number: INTEGER
			-- Message sequence number, if not zero.

	size: INTEGER
			-- Last received message size;
			-- Independent from `message', only set when a raw RFC822
			-- size is sent.


feature -- Status

	is_seen: BOOLEAN
			-- If flags have been retrieved, is "\Seen" among them?
		do
			Result := flags.has (flag_seen)
		end


feature -- Set message data

	append_flag (a_flag: STRING)
		do
			flags.force_last (a_flag)
		ensure
			has_flag: flags.has (a_flag)
		end

	clear_flags
			-- Make sure there are no items in `flags'.
		do
			flags.wipe_out
		ensure
			flags_reset: flags.is_empty
		end

	set_message (a_message: STRING)
			-- Set `message'.
		do
			message := a_message
		end

	set_message_body (a_body: STRING)
			-- Set `message_body'.
		do
			body := a_body
		end

	set_message_header (a_header: STRING)
			-- Set `message_header'.
		do
			header := a_header
		end

	set_message_size (a_size: INTEGER)
			-- Set `message_size'.
		require
			valid_size: a_size >= 0
		do
			size := a_size
		ensure
			message_size_set: size = a_size
		end

	set_sequence_number (a_sequence_number: INTEGER)
		require
			valid_sequence_number: a_sequence_number >= 1
		do
			sequence_number := a_sequence_number
		end


feature {NONE} -- Message flags

	flag_seen: STRING = "\Seen"


invariant

	sequence_number_not_negative: sequence_number >= 0
	size_not_negative: size >= 0

end
