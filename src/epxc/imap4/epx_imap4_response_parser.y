%{
indexing

	description: "Parser for IMAP4 server responses."

	standards: "Follows RFC 3501"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


class

	EPX_IMAP4_RESPONSE_PARSER


inherit

	YY_OLD_PARSER_SKELETON [ANY]
		rename
			make as make_parser
		end

	EPX_IMAP4_RESPONSE_SCANNER
		rename
			make as make_scanner
		end


creation

	make


%}

-- my tag
%token <STRING> IMAP4_TAG

-- free text, need to set state!
%token <STRING> IMAP4_TEXT IMAP4_TEXT_MIME2
%token <STRING> IMAP4_TEXT_WITHOUT_RIGHT_BRACKET

-- nothing
%token <STRING> IMAP4_NIL

-- numbers
%token <INTEGER_REF> INT_NUMBER

--- strings
%token <STRING> QUOTED_STRING

-- atoms
%token <STRING> IMAP4_ATOM

-- flag message/mailbox
%token <STRING> FLAG_ANSWERED FLAG_FLAGGED FLAG_DELETED FLAG_RECENT
%token <STRING> FLAG_SEEN FLAG_DRAFT
%token <STRING> FLAG_NOSELECT FLAG_UNMARKED
%token <STRING> FLAG_ATOM FLAG_STAR

-- mailbox_data
%token <STRING> IMAP4_FLAGS IMAP4_LIST IMAP4_LSUB
%token <STRING> IMAP4_EXISTS IMAP4_RECENT

-- mailbox names
%token <STRING> IMAP4_INBOX

-- media types
%token <STRING> MEDIA_TYPE_APPLICATION MEDIA_TYPE_AUDIO
%token <STRING> MEDIA_TYPE_IMAGE
%token <STRING> MEDIA_TYPE_MESSAGE MEDIA_TYPE_RFC822 MEDIA_TYPE_TEXT
%token <STRING> MEDIA_TYPE_VIDEO

-- message data
%token <STRING> IMAP4_EXPUNGE IMAP4_FETCH

-- msg_att
%token <STRING> IMAP4_BODY IMAP4_BODYSTRUCTURE IMAP4_ENVELOPE
%token <STRING> IMAP4_INTERNALDATE
%token <STRING> IMAP4_RFC822 IMAP4_RFC822_HEADER IMAP4_RFC822_SIZE
%token <STRING> IMAP4_RFC822_TEXT IMAP4_UID

-- response codes
%token <STRING> IMAP4_BAD IMAP4_BYE IMAP4_OK IMAP4_NO

-- resp_text_codes
%token IMAP4_ALERT IMAP4_PARSE IMAP4_PERMANENTFLAGS
%token IMAP4_READ_ONLY IMAP4_READ_WRITE IMAP4_TRYCREATE
%token IMAP4_UIDNEXT IMAP4_UIDVALIDITY IMAP4_UNSEEN
%token IMAP4_ATOM_WITHOUT_RIGHT_BRACKET

-- section text
%token <STRING> IMAP4_MIME IMAP4_HEADER IMAP4_HEADER_FIELDS IMAP4_NOT

-- types
%type <STRING> astring
%type <STRING> atom
%type <STRING> flag
%type <STRING> flag_extension
%type <STRING> flag_keyword
%type <STRING> mailbox
%type <STRING> mailbox_delimiter
%type <STRING> one_or_more_msg_att_item_flag_item
%type <STRING> literal
%type <STRING> nstring
%type <INTEGER_REF> number
%type <INTEGER_REF> nz_number
%type <STRING> quoted
%type <STRING> resp_text
%type <STRING> string
%type <STRING> text
%type <STRING> text_mime2
%type <INTEGER_REF> zone

-- end of line
%token CRLF

%start response

%%
-------------------------------------------------------------------------------

one_or_more_address
	: address
	| one_or_more_address address
	;

address
	: '(' addr_name addr_adl addr_mailbox addr_host ')'
	;

-- Holds route from [RFC-822] route-addr if non-NIL
addr_adl
	: nstring
	;

-- NIL indicates [RFC-822] group syntax.
-- Otherwise, holds [RFC-822] domain name.
addr_host
	: nstring
	;

--  NIL indicates end of [RFC-822] group; if non-NIL and addr_host is
--  NIL, holds [RFC-822] group name.
-- Otherwise, holds [RFC-822] local-part.
addr_mailbox
	: nstring
	;

-- Holds phrase from [RFC-822] mailbox if non-NIL
addr_name
	: nstring
	;

astring
	: atom
		{ $$ := $1 }
	| string
		{ $$ := $1 }
	;

-- @@BdB: incomplete
-- include all the specially parsed keywords here
-- missing: INBOX keyword, believe I must have it here as well
atom
	: IMAP4_ATOM
		{ $$ := $1 }
	| IMAP4_BAD
		{ $$ := $1 }
	| IMAP4_BODY
		{ $$ := $1 }
	| IMAP4_BODYSTRUCTURE
		{ $$ := $1 }
	| IMAP4_BYE
		{ $$ := $1 }
	| IMAP4_ENVELOPE
		{ $$ := $1 }
	| IMAP4_EXISTS
		{ $$ := $1 }
	| IMAP4_EXPUNGE
		{ $$ := $1 }
	| IMAP4_FETCH
		{ $$ := $1 }
	| IMAP4_FLAGS
		{ $$ := $1 }
	| IMAP4_INTERNALDATE
		{ $$ := $1 }
	| IMAP4_HEADER
		{ $$ := $1 }
	| IMAP4_HEADER_FIELDS
		{ $$ := $1 }
	| IMAP4_LIST
		{ $$ := $1 }
	| IMAP4_LSUB
		{ $$ := $1 }
	| IMAP4_MIME
		{ $$ := $1 }
	| IMAP4_NIL
		{ $$ := $1 }
	| IMAP4_NO
		{ $$ := $1 }
	| IMAP4_NOT
		{ $$ := $1 }
	| IMAP4_OK
		{ $$ := $1 }
	| IMAP4_RECENT
		{ $$ := $1 }
	| IMAP4_RFC822
		{ $$ := $1 }
	| IMAP4_RFC822_HEADER
		{ $$ := $1 }
	| IMAP4_RFC822_SIZE
		{ $$ := $1 }
	| IMAP4_RFC822_TEXT
		{ $$ := $1 }
	| IMAP4_TAG
		{ $$ := $1 }
	| IMAP4_TEXT
		{ $$ := $1 }
	| IMAP4_UID
		{ $$ := $1 }
	;

body
	: '(' body_type_1part ')'
	| '(' body_type_mpart ')'
	;

one_or_more_body
	: body
	| one_or_more_body body
	;

one_or_more_body_extension
	: body_extension
	| one_or_more_body_extension body_extension
	;

-- Future expansion. Client implementations MUST accept body_extension
-- fields.
body_extension
	: nstring
	| number
	| '(' one_or_more_body_extension ')'
	;

optional_body_ext_1part
	: -- empty
	| body_ext_1part
	;

body_ext_1part
	: body_fld_md5
	| body_fld_md5 body_fld_dsp
	| body_fld_md5 body_fld_dsp body_fld_lang
	| body_fld_md5 body_fld_dsp body_fld_lang one_or_more_body_extension
	;

optional_body_ext_mpart
	: -- empty
	| body_ext_mpart
	;

body_ext_mpart
	: body_fld_param
	| body_fld_param body_fld_dsp body_fld_lang
	| body_fld_param body_fld_dsp body_fld_lang one_or_more_body_extension
	;

body_fields
	: body_fld_param body_fld_id body_fld_desc body_fld_enc body_fld_octets
	;

body_fld_desc
	: nstring
	;

body_fld_dsp
	: '(' string body_fld_param ')'
	| nil
	;

body_fld_enc
	: nstring
	;

body_fld_id
	: nstring
	;

body_fld_lang
	: nstring
	| '(' one_or_more_string ')'
	;

body_fld_lines
	: number
	;

body_fld_md5
	: nstring
	;

body_fld_octets
	: number
	;

body_fld_param
	: '(' one_or_more_body_fld_param_item ')'
	| nil
	;

one_or_more_body_fld_param_item
	: body_fld_param_item
	| one_or_more_body_fld_param_item body_fld_param_item
	;

body_fld_param_item
	: string string
	;

body_type_1part
	: body_type_basic optional_body_ext_1part
	| body_type_msg optional_body_ext_1part
	| body_type_text optional_body_ext_1part
	;

-- MESSAGE subtype MUST NOT be "RFC822"
body_type_basic
	: media_basic body_fields
	;

body_type_mpart
	: one_or_more_body media_subtype optional_body_ext_mpart
	;

body_type_msg
	: media_message body_fields envelope body body_fld_lines
	;

body_type_text
	: media_text body_fields body_fld_lines
	;

-- @@BdB: or base64
continue_req
	: '+' resp_text CRLF
	;

date_time
	: '"' date_day_fixed '-' date_month '-' date_year time zone '"'
	;

date_day_fixed
	: INT_number
		{ $$ := $1 }
	;

date_month
	: INT_NUMBER
		{ $$ := $1 }
	;

date_year
	: INT_NUMBER
		{ $$ := $1 }
	;

envelope
	: '(' env_date env_subject env_from env_sender env_reply_to env_to env_cc env_bcc env_in_reply_to env_message_id ')'
	;

env_cc
	: '(' one_or_more_address ')'
	| nil
	;

env_bcc
	: '(' one_or_more_address ')'
	| nil
	;

env_date
	: nstring
	;

env_from
	: '(' one_or_more_address ')'
	| nil
	;

env_in_reply_to
	: nstring
	;

env_message_id
	: nstring
	;

env_subject
	: nstring
	;

env_reply_to
	: '(' one_or_more_address ')'
	| nil
	;

env_sender
	: '(' one_or_more_address ')'
	| nil
	;

env_to
	: '(' one_or_more_address ')'
	| nil
	;

flag
	: FLAG_ANSWERED
		{ $$ := $1 }
	| FLAG_FLAGGED
		{ $$ := $1 }
	| FLAG_DELETED
		{ $$ := $1 }
	| FLAG_SEEN
		{ $$ := $1 }
	| FLAG_DRAFT
		{ $$ := $1 }
	| FLAG_RECENT -- should not be included according to RFC 3501, but the Binc IMAP server does
		{ $$ := $1 }
	| flag_keyword
		{ $$ := $1 }
	| flag_extension
		{ $$ := $1 }
	;

one_or_more_flag
	: flag
	| one_or_more_flag flag
	;

flag_extension
	: FLAG_ATOM
		{ $$ := $1 }
	;

flag_keyword
	: atom
		{ $$ := $1 }
	;

flag_perm
	: flag
	| FLAG_STAR
	;

zero_or_more_flag_perm
	: -- empty
	| one_or_more_flag_perm
	;

one_or_more_flag_perm
	: flag_perm
	| one_or_more_flag_perm flag_perm
	;

flag_list
	: '(' one_or_more_flag ')'
	;

one_or_more_header_fld_name
	: header_fld_name
	| one_or_more_header_fld_name header_fld_name
	;

header_fld_name
	: astring
	;

header_list
	: '(' one_or_more_header_fld_name ')'
	;

literal
	: '{' number '}' CRLF
		{ read_literal ($2.item); $$ := last_string }
	;

mailbox
	: IMAP4_INBOX
		{ $$ := $1 }
	| astring
		{ $$ := $1 }
	;

-- @@BdB: incomplete
mailbox_data
	: IMAP4_FLAGS flag_list
	| IMAP4_LIST mailbox_list
	| IMAP4_LSUB mailbox_list
	| number IMAP4_EXISTS
		{
			if response.current_mailbox /= Void then
				response.current_mailbox.set_count ($1.item)
			end
		}
	| number IMAP4_RECENT
		{
			if response.current_mailbox /= Void then
				response.current_mailbox.set_recent ($1.item)
			end
		}
	;

-- QUOTED is actually a single quoted char (delimiter?)
mailbox_delimiter
	: quoted
		{ $$ := $1 }
	| nil
	;

mailbox_list
	: '(' mailbox_list_flag_zero_or_more ')' mailbox_delimiter mailbox
		{
			if $4 = Void or else $4.count = 1 then
				response.set_delimiter ($4)
			end
			-- @@BdB: here add mailbox to response.mailboxes
		}
	;

mailbox_list_flag_zero_or_more
	: -- empty
	| mailbox_list_flag_one_or_more
	;

mailbox_list_flag_one_or_more
	: mailbox_list_flag
	| mailbox_list_flag_one_or_more mailbox_list_flag
	;

mailbox_list_flag
	: FLAG_NOSELECT
	| FLAG_UNMARKED
	| flag_extension
	;

-- works because QUOTED_STR excludes special media type strings...
media_basic
	: media_basic_type media_subtype
	| QUOTED_STRING media_subtype
	| literal media_subtype
	;

-- @@BdB: MEDIA_TYPE_MESSAGE gives shift/reduce conflict
media_basic_type
	: MEDIA_TYPE_APPLICATION
	| MEDIA_TYPE_AUDIO
	| MEDIA_TYPE_IMAGE
--	| MEDIA_TYPE_MESSAGE
	| MEDIA_TYPE_VIDEO
	;

media_message
	: MEDIA_TYPE_MESSAGE MEDIA_TYPE_RFC822
	;

media_subtype
	: string
	;

media_text
	: MEDIA_TYPE_TEXT media_subtype
	;

message_data
	: nz_number IMAP4_EXPUNGE
	| nz_number IMAP4_FETCH msg_att
	;

msg_att
	: '(' one_or_more_msg_att_item ')'
	;

one_or_more_msg_att_item
	: msg_att_item
	| one_or_more_msg_att_item msg_att_item
	;

msg_att_item
	: IMAP4_ENVELOPE envelope
	| IMAP4_FLAGS '('
		{
			if response.current_message /= Void then
				response.current_message.clear_flags
			end
		}
		zero_or_more_msg_att_item_flag ')'
	| IMAP4_INTERNALDATE { expect_date_time } date_time
	| IMAP4_RFC822 nstring
		{
			if response.current_message /= Void then
				response.current_message.set_message ($2)
			end
		}
	| IMAP4_RFC822_HEADER nstring
		{
			if response.current_message /= Void then
				response.current_message.set_message_header ($2)
			end
		}
	| IMAP4_RFC822_SIZE number
		{
			if response.current_message /= Void then
				response.current_message.set_message_size ($2.item)
			end
		}
	| IMAP4_RFC822_TEXT nstring
		{
			if response.current_message /= Void then
				response.current_message.set_message_body ($2)
			end
		}
	| IMAP4_BODY body
	| IMAP4_BODYSTRUCTURE body
	| IMAP4_BODY section nstring
	| IMAP4_BODY section msg_att_item_number nstring
	| IMAP4_UID uniqueid
	;

zero_or_more_msg_att_item_flag
	: -- empty
	| one_or_more_msg_att_item_flag
	;

one_or_more_msg_att_item_flag
	: one_or_more_msg_att_item_flag_item
		{
			if response.current_message /= Void then
				response.current_message.append_flag ($1)
			end
		}
	| one_or_more_msg_att_item_flag one_or_more_msg_att_item_flag_item
		{
			if response.current_message /= Void then
				response.current_message.append_flag ($2)
			end
		}
	;

one_or_more_msg_att_item_flag_item
	: flag
		{ $$ := $1 }
	| FLAG_RECENT
		{ $$ := $1 }
	;

msg_att_item_number
	: '<' number '>'
	;

nil
	: IMAP4_NIL
	;

nstring
	: string
		{ $$ := $1 }
	| nil
	;

number
	: INT_NUMBER
		{ $$ := $1 }
	;

nz_number
	: INT_NUMBER
		{ $$ := $1 }
	;

-- because certain media types are handled special
-- we'll have to return them here as quoted string when they're just
-- that
quoted
	: QUOTED_STRING
		{ $$ := $1 }
	| MEDIA_TYPE_APPLICATION
		{ $$ := $1 }
	| MEDIA_TYPE_AUDIO
		{ $$ := $1 }
	| MEDIA_TYPE_MESSAGE
		{ $$ := $1 }
	| MEDIA_TYPE_RFC822
		{ $$ := $1 }
	| MEDIA_TYPE_TEXT
		{ $$ := $1 }
	;

response
	: response_item_list response_done
	| response_done
	;

response_item_list
	: response_item
	| response_item_list response_item
	;

response_item
	: continue_req
	| response_data
	;

-- @@BdB: incomplete
response_data
	: '*' resp_cond_state CRLF
-- resp_cond_bye is handled as response_fatal
--	| '*' resp_cond_bye
	| '*' mailbox_data CRLF
	| '*' message_data CRLF
	;

response_done
	: response_tagged
	| response_fatal
	;

response_fatal
	: '*' IMAP4_BYE
		{
			-- not needed, server closes connection, so we get a proper eof:
			--end_of_file_after_end_of_line := True
			response.set_bye
			scan_resp_text
		}
		resp_text CRLF
		{ response.set_bye_response_text ($4) }
		optional_tagged_ok
	;

optional_tagged_ok
	: -- empty
	| IMAP4_TAG
		{ end_of_file_after_end_of_line := True }
		IMAP4_OK
		{ response.set_ok; scan_resp_text }
		resp_text
		{ response.set_response_text ($5) }
		CRLF
	;

response_tagged
	: IMAP4_TAG
		{ end_of_file_after_end_of_line := True }
		resp_cond_state CRLF
	;

-- handled as response_fatal, not sure why it's here
-- resp_cond_bye
-- 	: IMAP4_BYE { expect_resp_text} resp_text
-- 	;

resp_cond_state
	: IMAP4_OK
		{ response.set_ok; scan_resp_text }
		resp_text
		{ response.set_response_text ($3) }
	| IMAP4_NO
		{ response.set_no; scan_resp_text }
		resp_text
		{ response.set_response_text ($3) }
	| IMAP4_BAD
		{ response.set_bad; scan_resp_text }
		resp_text
		{ response.set_response_text ($3) }
	;

resp_text
	: optional_resp_text_code text_mime2
		{ $$ := $2 }
	| optional_resp_text_code text
		{ $$ := $2 }
	| optional_resp_text_code
	;

optional_resp_text_code
	: -- empty
	|  '[' resp_text_code ']' { expect_resp_text }
	;

-- @@BdB: incomplete
resp_text_code
	: IMAP4_ALERT
	| IMAP4_PARSE
	| IMAP4_PERMANENTFLAGS '(' zero_or_more_flag_perm ')'
	| IMAP4_READ_ONLY
		{
			if response.current_mailbox /= Void then
				response.current_mailbox.set_is_writable (False)
			end
		}
	| IMAP4_READ_WRITE
		{
			if response.current_mailbox /= Void then
				response.current_mailbox.set_is_writable (True)
			end
		}
	| IMAP4_UIDNEXT number
	| IMAP4_UIDVALIDITY number
		{
			if response.current_mailbox /= Void then
				response.current_mailbox.set_identifier ($2.item)
			end
		}
	| IMAP4_UNSEEN number
		{
			if response.current_mailbox /= Void then
				response.current_mailbox.set_unseen ($2.item)
			end
		}
	| IMAP4_ATOM_WITHOUT_RIGHT_BRACKET optional_text_without_right_bracket
	;

optional_text_without_right_bracket
	: -- empty
	| IMAP4_TEXT_WITHOUT_RIGHT_BRACKET
	;

one_or_more_string
	: string
	| one_or_more_string string
	;

-- @@BdB: 2 shift/reduce conflicts with dot_section_text
-- problem is, we don't know if it's a section_number or section_text
-- that follows.
section
	: '[' ']'
	| '[' section_text ']'
	| '[' nz_number zero_or_more_section_number ']'
--	| '[' nz_number zero_or_more_section_number dot_section_text ']'
	;

zero_or_more_section_number
	: -- empty
	| one_or_more_section_number
	;

one_or_more_section_number
	: '.' nz_number
	| one_or_more_section_number '.' nz_number
	;

-- dot_section_text
-- 	: '.' section_text
-- 	| '.' IMAP4_MIME
-- 	;

section_text
	: IMAP4_HEADER
	| IMAP4_HEADER_FIELDS header_list
	| IMAP4_HEADER_FIELDS IMAP4_NOT header_list
	| IMAP4_TEXT
	;

string
	: quoted
		{ $$ := $1 }
	| literal
		{ $$ := $1 }
	;

text
	: IMAP4_TEXT
		{ $$ := $1 }
	;

text_mime2
	: IMAP4_TEXT_MIME2
		{ $$ := $1 }
	;

time
	: INT_NUMBER ':' INT_NUMBER ':' INT_NUMBER
	;

-- Strictly ascending
uniqueid
	: nz_number
	;

zone
	: INT_NUMBER
		{ $$ := $1 }
	| '-' INT_NUMBER
		{ $$ := $2; $$.set_item (-1 * $$.item) }
	;

-------------------------------------------------------------------------------
%%

feature {NONE} -- Initialization

	make (a_response: EPX_IMAP4_RESPONSE) is
			-- Parse server response into `a_response'.
		require
			a_response_not_void: a_response /= Void
		do
			make_scanner
			make_parser
			response := a_response
		end


feature {NONE} -- Response

	response: EPX_IMAP4_RESPONSE
			-- Server response is stored here.


feature -- Character reading

	end_of_input: BOOLEAN is
			-- True if `read_character' hits end-of-file.
		do
			Result :=
				last_character = yyEnd_of_file_character and
				not input_buffer.filled
		end


feature {NONE} -- Scanning literals

	read_literal (nbytes: INTEGER) is
			-- Literal is expected to follow in next lines.
			-- This function seems to be at least 3 times faster than the
			-- commented-out function below when the input comes from an
			-- EPX_CHARACTER_INPUT_STREAM.
		require
			nbytes_not_negative: nbytes >= 0
		local
			i: INTEGER
			epx_input_buffer: EPX_STREAM_BUFFER
			file: EPX_CHARACTER_INPUT_STREAM
			buffer: STDC_BUFFER
			remaining: INTEGER
		do
			-- You would expect that a string filled with '%U' would skip
			-- filling itself when it got its memory through
			-- calloc. Unfortunately, that doesn't happen it seems.
			create last_string.make_filled ('%U', nbytes)
			-- First we read the bytes currently in our `input_buffer' cache.
			from
				i := 1
			until
				yy_end > input_buffer.count or else
				i > nbytes
			loop
				last_string.put (yy_content.item (yy_end), i)
				yy_end := yy_end + 1
				i := i + 1
			end
			-- And next the bytes coming through our socket
			-- Branch depending if we have an EPX_STREAM_BUFFER or not.
			remaining := (nbytes - i) + 1
			if remaining > 0 then
				epx_input_buffer ?= input_buffer
				if epx_input_buffer = Void then
					from
					until
						end_of_input or else
						i > nbytes
					loop
						read_character
						if not end_of_input then
							last_string.put (last_character, i)
							i := i + 1
						end
					end
				else
					file := epx_input_buffer.file
					create buffer.allocate (131072)
					from
					until
						remaining = 0 or else
						file.end_of_input
					loop
						file.read_buffer (buffer, 0, remaining.min (buffer.capacity))
						if not file.end_of_input then
							buffer.put_to_string (last_string, i, 0, file.last_read - 1)
							remaining := remaining - file.last_read
							i := i + file.last_read
						end
					end
					buffer.deallocate
				end
			end
		ensure
			last_string_not_void: last_string /= Void
			last_string_complete: last_string.count = nbytes or else end_of_input
		end

-- 	read_literal (nbytes: INTEGER) is
-- 			-- Literal is expected to follow in next lines.
-- 		require
-- 			nbytes_not_negative: nbytes >= 0
-- 		local
-- 			i: INTEGER
-- 		do
-- 			from
-- 				i := 1
-- 				--create last_string.make (nbytes)
-- 				create last_string.make_filled ('%U', nbytes)
-- 			until
-- 				end_of_input or else
-- 				i > nbytes
-- 			loop
-- 				read_character
-- 				--last_string.append_character (last_character)
-- 				last_string.put (last_character, i)
-- 				i := i + 1
-- 			end
-- -- 			debug ("imap4")
-- -- 				print ("@@@@@@@@read literal: %N")
-- -- 				print (last_string)
-- -- 				print ("%N")
-- -- 			end
-- 		ensure
-- 			last_string_not_void: last_string /= Void
-- 			last_string_complete: last_string.count = nbytes or else end_of_input
-- 		end


invariant

	response_not_void: response /= Void

end
