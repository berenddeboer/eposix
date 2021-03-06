%{
note

	description: "Scanner for IMAP4 server responses."

	standards: "RFC 3501"

	bugs: "Should return IMAP4_ATOM in more cases. Introduce more state for keywords that are only keywords in specific cases perhaps?"

	author: "Berend de Boer"


class

	EPX_IMAP4_RESPONSE_SCANNER

inherit

	YY_COMPRESSED_SCANNER_SKELETON
		redefine
			make,
			reset_start_condition
		end


inherit {NONE}

	EPX_IMAP4_RESPONSE_TOKENS
		export
			{NONE} all
		end

	UT_CHARACTER_CODES
		export
			{NONE} all
		end


create

	make

%}

%option outfile="epx_imap4_response_scanner.e"
%option nocase-sensitive
--%option nodefault


%x SC_SCAN_DATE_TIME SC_DATE_TIME
%x SC_SCAN_RESP_TEXT SC_RESP_TEXT
%x SC_RESP_TEXT_CODE SC_RESP_TEXT_CODE_TEXT
%x SC_TEXT_MIME2
%x SC_QUOTED_STRING

-- Definitions

%%
-------------------------------------------------------------------------------


----------/** characters **/---------------------------------------------------

"["           last_token := Left_bracket_code
"]"           last_token := Right_bracket_code
"("           last_token := Left_parenthesis_code
")"           last_token := Right_parenthesis_code
"{"           last_token := Left_brace_code
"}"           last_token := Right_brace_code
"-"           last_token := Minus_code


----------/** My Tag **/-------------------------------------------------------

"A"[0-9]+      last_token := IMAP4_TAG; last_string_value := text


----------/** flags **/--------------------------------------------------------
-- both message and mailbox

"\\ANSWERED"   last_token := FLAG_ANSWERED; last_string_value := text
"\\FLAGGED"    last_token := FLAG_FLAGGED; last_string_value := text
"\\DELETED"    last_token := FLAG_DELETED; last_string_value := text
"\\SEEN"       last_token := FLAG_SEEN; last_string_value := text
"\\DRAFT"      last_token := FLAG_DRAFT; last_string_value := text
"\\Noselect"   last_token := FLAG_NOSELECT; last_string_value := text
"\\Unmarked"   last_token := FLAG_UNMARKED; last_string_value := text
"\\Recent"     last_token := FLAG_RECENT; last_string_value := text
"\\*"          last_token := FLAG_STAR; last_string_value := text
"\\"[^(){ \x00-\x1f%*\"\\]+ { --"
					last_token := FLAG_ATOM
					last_string_value := text
					}


----------/** special mailbox names **/----------------------------------------

"INBOX"       last_token := IMAP4_INBOX; last_string_value := text


----------/** numbers **/------------------------------------------------------

[0-9]+         set_last_integer (text.to_integer)


----------/** media types **/--------------------------------------------------

-- special case strings

\""APPLICATION"\"   last_token := MEDIA_TYPE_APPLICATION; last_string_value := text
\""AUDIO"\"         last_token := MEDIA_TYPE_AUDIO; last_string_value := text
\""IMAGE"\"         last_token := MEDIA_TYPE_IMAGE; last_string_value := text
\""MESSAGE"\"       last_token := MEDIA_TYPE_MESSAGE; last_string_value := text
\""RFC822"\"        last_token := MEDIA_TYPE_RFC822; last_string_value := text
\""TEXT"\"          last_token := MEDIA_TYPE_TEXT; last_string_value := text
\""VIDEO"\"         last_token := MEDIA_TYPE_VIDEO; last_string_value := text


----------/** strings **/------------------------------------------------------

\"             { --"
					set_start_condition (SC_QUOTED_STRING)
					last_string := ""
					}
<SC_QUOTED_STRING>[^\"\\]+ { --"
					last_string.append_string (text)
					}
<SC_QUOTED_STRING>\\. { --"
					-- assume any character can be quoted
					last_string.append_character (text.item (2))
					}
<SC_QUOTED_STRING>\" { --"
					set_start_condition (INITIAL)
					last_string_value := last_string
					last_token := QUOTED_STRING
					}

"NIL"          last_token := IMAP4_NIL; last_string_value := text


----------/** mailbox_data **/-------------------------------------------------

"EXISTS"       last_token := IMAP4_EXISTS; last_string_value := text
"FLAGS"        last_token := IMAP4_FLAGS; last_string_value := text
"LIST"         last_token := IMAP4_LIST; last_string_value := text
"LSUB"         last_token := IMAP4_LSUB; last_string_value := text
"RECENT"       last_token := IMAP4_RECENT; last_string_value := text


----------/** message_data **/-------------------------------------------------

"EXPUNGE"      last_token := IMAP4_EXPUNGE; last_string_value := text
"FETCH"        last_token := IMAP4_FETCH; last_string_value := text


----------/** msg_att **/------------------------------------------------------

"BODY"              last_token := IMAP4_BODY; last_string_value := text
"BODYSTRUCTURE"     last_token := IMAP4_BODYSTRUCTURE; last_string_value := text
"ENVELOPE"          last_token := IMAP4_ENVELOPE; last_string_value := text
"INTERNALDATE"      last_token := IMAP4_INTERNALDATE; last_string_value := text
"RFC822"            last_token := IMAP4_RFC822; last_string_value := text
"RFC822.HEADER"     last_token := IMAP4_RFC822_HEADER; last_string_value := text
"RFC822.SIZE"       last_token := IMAP4_RFC822_SIZE; last_string_value := text
"RFC822.TEXT"       last_token := IMAP4_RFC822_TEXT; last_string_value := text
"UID"               last_token := IMAP4_UID; last_string_value := text


----------/** date_time **/----------------------------------------------------

<SC_SCAN_DATE_TIME>\"  { --"
					set_start_condition (SC_DATE_TIME)
					last_token := Double_quote_code
					}

<SC_DATE_TIME>"Jan"    set_last_integer (1)
<SC_DATE_TIME>"Feb"    set_last_integer (2)
<SC_DATE_TIME>"Mar"    set_last_integer (3)
<SC_DATE_TIME>"Apr"    set_last_integer (4)
<SC_DATE_TIME>"May"    set_last_integer (5)
<SC_DATE_TIME>"Jun"    set_last_integer (6)
<SC_DATE_TIME>"Jul"    set_last_integer (7)
<SC_DATE_TIME>"Aug"    set_last_integer (8)
<SC_DATE_TIME>"Sep"    set_last_integer (9)
<SC_DATE_TIME>"Oct"    set_last_integer (10)
<SC_DATE_TIME>"Nov"    set_last_integer (11)
<SC_DATE_TIME>"Dec"    set_last_integer (12)
<SC_DATE_TIME>\+?[0-9]+ set_last_integer (text.to_integer)
<SC_DATE_TIME>":"      last_token := Colon_code
<SC_DATE_TIME>"-"      last_token := Minus_code
<SC_DATE_TIME>\"  { --"
					set_start_condition (INITIAL)
					last_token := Double_quote_code
					}

----------/** response data/continuation **/-----------------------------------

"*"            last_token := Star_code
"+"            last_token := Plus_code


----------/** response condition **/-------------------------------------------

"BAD"          last_token := IMAP4_BAD; last_string_value := text
"BYE"          last_token := IMAP4_BYE; last_string_value := text
"NO"           last_token := IMAP4_NO; last_string_value := text
"OK"           last_token := IMAP4_OK; last_string_value := text


----------/** resp_text_code **/-----------------------------------------------

<SC_RESP_TEXT_CODE>"ALERT"        last_token := IMAP4_ALERT
<SC_RESP_TEXT_CODE>"PARSE"        last_token := IMAP4_PARSE
<SC_RESP_TEXT_CODE>"PERMANENTFLAGS" {
					last_token := IMAP4_PERMANENTFLAGS
					set_start_condition (INITIAL)
					}
<SC_RESP_TEXT_CODE>"READ-ONLY"    last_token := IMAP4_READ_ONLY
<SC_RESP_TEXT_CODE>"READ-WRITE"   last_token := IMAP4_READ_WRITE
<SC_RESP_TEXT_CODE>"UIDNEXT"      last_token := IMAP4_UIDNEXT
<SC_RESP_TEXT_CODE>"UIDVALIDITY"  last_token := IMAP4_UIDVALIDITY
<SC_RESP_TEXT_CODE>"UNSEEN"       last_token := IMAP4_UNSEEN
<SC_RESP_TEXT_CODE>[^(){ \x00-\x1f%*\"\\\]]+ { --"
					last_token := IMAP4_ATOM_WITHOUT_RIGHT_BRACKET
					last_string_value := text
					set_start_condition (SC_RESP_TEXT_CODE_TEXT)
					}
<SC_RESP_TEXT_CODE>[ \t]+ {
					set_start_condition (INITIAL)
					}
<SC_RESP_TEXT_CODE>"]" {
					last_token := Right_bracket_code
					set_start_condition (INITIAL)
					}


----------/** section_text **/-------------------------------------------------

"HEADER"	           last_token := IMAP4_HEADER; last_string_value := text
"HEADER.FIELDS"     last_token := IMAP4_HEADER_FIELDS; last_string_value := text
"MIME"              last_token := IMAP4_MIME; last_string_value := text
"NOT"               last_token := IMAP4_NOT; last_string_value := text
"TEXT"              last_token := IMAP4_TEXT; last_string_value := text


----------/** TEXT_CHAR after resp_text_code atom **/--------------------------

<SC_RESP_TEXT_CODE_TEXT>[^\n\r\]]+ {
					last_string_value := text
					set_start_condition (INITIAL)
					last_token := IMAP4_TEXT_WITHOUT_RIGHT_BRACKET
					}
<SC_RESP_TEXT_CODE_TEXT>"]" {
					last_token := Right_bracket_code
					set_start_condition (INITIAL)
					}
<SC_RESP_TEXT_CODE_TEXT>. set_start_condition (INITIAL)


----------/** atom **/---------------------------------------------------------
-- excludes [ and ] and }
-- makes the scanner a lot simpler
-- and as long as we don't encounter a server/client who needs them...

[^(){} \x00-\x1f%*\"\\\[\]]+ { --"
					last_token := IMAP4_ATOM
					last_string_value := text
					}


----------/** End of line **/--------------------------------------------------

\r\n           |
\n             last_token := CRLF


----------/** White space **/--------------------------------------------------

[ \t]+         {} -- ignore


----------/** got to RESP_TEXT or not **/--------------------------------------

<SC_SCAN_RESP_TEXT>[ \t]*"[" {
					last_token := Left_bracket_code
					set_start_condition (SC_RESP_TEXT_CODE)
					}
<SC_SCAN_RESP_TEXT>[ \t]*[^\[] {
					less (text.count - 1)
					set_start_condition (SC_RESP_TEXT)
					}


----------/** text or text_mime2 **/-------------------------------------------

<SC_RESP_TEXT>"=?" {
					set_start_condition (SC_TEXT_MIME2)
					}
<SC_RESP_TEXT>[^\r\n]+ {
					text.left_adjust
					text.right_adjust
					last_string_value := text
					last_token := IMAP4_TEXT
					set_start_condition (INITIAL)
					}
<SC_RESP_TEXT>\n   |
<SC_RESP_TEXT>\r\n {
					last_token := CRLF
					set_start_condition (INITIAL)
					}

-------------------------------------------------------------------------------

%%


feature {NONE} -- Initialisation

	make
		do
			precursor
			last_string := ""
			last_string_value := ""
		end


feature -- Input

	end_of_file_after_end_of_line: BOOLEAN
			-- Avoid blocking knob.

	new_imap4_response_buffer (a_stream: EPX_CHARACTER_INPUT_STREAM): EPX_IMAP4_RESPONSE_BUFFER
			-- New input buffer for `a_stream'.
		require
			stream_not_void: a_stream /= Void
			stream_open: a_stream.is_open_read
		do
			create Result.make (a_stream, Current)
		ensure
			new_buffer_not_void: Result /= Void
		end

	reset_end_of_file_after_end_of_line
			-- Reset `end_of_file_after_end_of_line'. Set when tagged
			-- response is received, or a fatal error.
		do
			end_of_file_after_end_of_line := False
		ensure
			not_end_of_file_after_end_of_line: not end_of_file_after_end_of_line
		end


feature {NONE} -- Last returned data helpers

	last_string: STRING
			-- Building quoted string.

	set_last_integer (a_number: INTEGER)
			-- Set `last_integer', `last_token' is INT_NUMBER.
		do
			last_token := INT_NUMBER
			last_integer_value := a_number
		ensure
			last_token_is_number: last_token = INT_NUMBER
			value_set: last_integer_value.item = a_number
		end


feature {NONE} -- Set start condition

	expect_date_time
		do
			set_start_condition (SC_SCAN_DATE_TIME)
		end

	expect_resp_text
			-- Set start state to RESP_TEXT.
		do
			set_start_condition (SC_RESP_TEXT)
		end

	reset_start_condition
			-- Used in error recovery to return to start condition.
		do
			precursor
			set_start_condition (INITIAL)
		end

	scan_resp_text
			-- Scan forward to see if a '[' follows or not by setting
			-- state to SCAN_RESP_TEXT.
		do
			set_start_condition (SC_SCAN_RESP_TEXT)
		end

end
