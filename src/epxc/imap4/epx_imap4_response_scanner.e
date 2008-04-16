indexing

	description: "Scanner for IMAP4 server responses."

	standards: "RFC 3501"

	bugs: "Should return IMAP4_ATOM in more cases. Introduce more state for keywords that are only keywords in specific cases perhaps?"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	EPX_IMAP4_RESPONSE_SCANNER

inherit

	YY_COMPRESSED_SCANNER_SKELETON

	EPX_IMAP4_RESPONSE_TOKENS
		export
			{NONE} all
		end

	UT_CHARACTER_CODES
		export
			{NONE} all
		end


feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= SC_QUOTED_STRING)
		end

feature {NONE} -- Implementation

	yy_build_tables is
			-- Build scanner tables.
		do
			yy_nxt := yy_nxt_template
			yy_chk := yy_chk_template
			yy_base := yy_base_template
			yy_def := yy_def_template
			yy_ec := yy_ec_template
			yy_meta := yy_meta_template
			yy_accept := yy_accept_template
		end

	yy_execute_action (yy_act: INTEGER) is
			-- Execute semantic action.
		do
if yy_act <= 51 then
if yy_act <= 26 then
if yy_act <= 13 then
if yy_act <= 7 then
if yy_act <= 4 then
if yy_act <= 2 then
if yy_act = 1 then
--|#line 54 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 54")
end
last_token := Left_bracket_code
else
--|#line 55 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 55")
end
last_token := Right_bracket_code
end
else
if yy_act = 3 then
--|#line 56 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 56")
end
last_token := Left_parenthesis_code
else
--|#line 57 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 57")
end
last_token := Right_parenthesis_code
end
end
else
if yy_act <= 6 then
if yy_act = 5 then
--|#line 58 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 58")
end
last_token := Left_brace_code
else
--|#line 59 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 59")
end
last_token := Right_brace_code
end
else
--|#line 60 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 60")
end
last_token := Minus_code
end
end
else
if yy_act <= 10 then
if yy_act <= 9 then
if yy_act = 8 then
--|#line 65 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 65")
end
last_token := IMAP4_TAG; last_value := text
else
--|#line 71 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 71")
end
last_token := FLAG_ANSWERED; last_value := text
end
else
--|#line 72 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 72")
end
last_token := FLAG_FLAGGED; last_value := text
end
else
if yy_act <= 12 then
if yy_act = 11 then
--|#line 73 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 73")
end
last_token := FLAG_DELETED; last_value := text
else
--|#line 74 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 74")
end
last_token := FLAG_SEEN; last_value := text
end
else
--|#line 75 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 75")
end
last_token := FLAG_DRAFT; last_value := text
end
end
end
else
if yy_act <= 20 then
if yy_act <= 17 then
if yy_act <= 15 then
if yy_act = 14 then
--|#line 76 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 76")
end
last_token := FLAG_NOSELECT; last_value := text
else
--|#line 77 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 77")
end
last_token := FLAG_UNMARKED; last_value := text
end
else
if yy_act = 16 then
--|#line 78 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 78")
end
last_token := FLAG_RECENT; last_value := text
else
--|#line 79 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 79")
end
last_token := FLAG_STAR; last_value := text
end
end
else
if yy_act <= 19 then
if yy_act = 18 then
--|#line 80 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 80")
end
 --"
					last_token := FLAG_ATOM
					last_value := text
					
else
--|#line 88 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 88")
end
last_token := IMAP4_INBOX; last_value := text
end
else
--|#line 93 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 93")
end
set_last_integer (text.to_integer)
end
end
else
if yy_act <= 23 then
if yy_act <= 22 then
if yy_act = 21 then
--|#line 100 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 100")
end
last_token := MEDIA_TYPE_APPLICATION; last_value := text
else
--|#line 101 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 101")
end
last_token := MEDIA_TYPE_AUDIO; last_value := text
end
else
--|#line 102 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 102")
end
last_token := MEDIA_TYPE_IMAGE; last_value := text
end
else
if yy_act <= 25 then
if yy_act = 24 then
--|#line 103 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 103")
end
last_token := MEDIA_TYPE_MESSAGE; last_value := text
else
--|#line 104 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 104")
end
last_token := MEDIA_TYPE_RFC822; last_value := text
end
else
--|#line 105 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 105")
end
last_token := MEDIA_TYPE_TEXT; last_value := text
end
end
end
end
else
if yy_act <= 39 then
if yy_act <= 33 then
if yy_act <= 30 then
if yy_act <= 28 then
if yy_act = 27 then
--|#line 106 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 106")
end
last_token := MEDIA_TYPE_VIDEO; last_value := text
else
--|#line 111 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 111")
end
 --"
					set_start_condition (SC_QUOTED_STRING)
					last_string := ""
					
end
else
if yy_act = 29 then
--|#line 115 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 115")
end
 --"
					last_string.append_string (text)
					
else
--|#line 118 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 118")
end
 --"
					-- assume any character can be quoted
					last_string.append_character (text.item (2))
					
end
end
else
if yy_act <= 32 then
if yy_act = 31 then
--|#line 122 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 122")
end
 --"
					set_start_condition (INITIAL)
					last_value := last_string
					last_token := QUOTED_STRING
					
else
--|#line 128 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 128")
end
last_token := IMAP4_NIL; last_value := text
end
else
--|#line 133 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 133")
end
last_token := IMAP4_EXISTS; last_value := text
end
end
else
if yy_act <= 36 then
if yy_act <= 35 then
if yy_act = 34 then
--|#line 134 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 134")
end
last_token := IMAP4_FLAGS; last_value := text
else
--|#line 135 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 135")
end
last_token := IMAP4_LIST; last_value := text
end
else
--|#line 136 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 136")
end
last_token := IMAP4_LSUB; last_value := text
end
else
if yy_act <= 38 then
if yy_act = 37 then
--|#line 137 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 137")
end
last_token := IMAP4_RECENT; last_value := text
else
--|#line 142 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 142")
end
last_token := IMAP4_EXPUNGE; last_value := text
end
else
--|#line 143 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 143")
end
last_token := IMAP4_FETCH; last_value := text
end
end
end
else
if yy_act <= 45 then
if yy_act <= 42 then
if yy_act <= 41 then
if yy_act = 40 then
--|#line 148 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 148")
end
last_token := IMAP4_BODY; last_value := text
else
--|#line 149 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 149")
end
last_token := IMAP4_BODYSTRUCTURE; last_value := text
end
else
--|#line 150 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 150")
end
last_token := IMAP4_ENVELOPE; last_value := text
end
else
if yy_act <= 44 then
if yy_act = 43 then
--|#line 151 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 151")
end
last_token := IMAP4_INTERNALDATE; last_value := text
else
--|#line 152 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 152")
end
last_token := IMAP4_RFC822; last_value := text
end
else
--|#line 153 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 153")
end
last_token := IMAP4_RFC822_HEADER; last_value := text
end
end
else
if yy_act <= 48 then
if yy_act <= 47 then
if yy_act = 46 then
--|#line 154 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 154")
end
last_token := IMAP4_RFC822_SIZE; last_value := text
else
--|#line 155 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 155")
end
last_token := IMAP4_RFC822_TEXT; last_value := text
end
else
--|#line 156 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 156")
end
last_token := IMAP4_UID; last_value := text
end
else
if yy_act <= 50 then
if yy_act = 49 then
--|#line 161 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 161")
end
 --"
					set_start_condition (SC_DATE_TIME)
					last_token := Double_quote_code
					
else
--|#line 166 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 166")
end
set_last_integer (1)
end
else
--|#line 167 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 167")
end
set_last_integer (2)
end
end
end
end
end
else
if yy_act <= 76 then
if yy_act <= 64 then
if yy_act <= 58 then
if yy_act <= 55 then
if yy_act <= 53 then
if yy_act = 52 then
--|#line 168 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 168")
end
set_last_integer (3)
else
--|#line 169 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 169")
end
set_last_integer (4)
end
else
if yy_act = 54 then
--|#line 170 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 170")
end
set_last_integer (5)
else
--|#line 171 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 171")
end
set_last_integer (5)
end
end
else
if yy_act <= 57 then
if yy_act = 56 then
--|#line 172 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 172")
end
set_last_integer (5)
else
--|#line 173 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 173")
end
set_last_integer (5)
end
else
--|#line 174 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 174")
end
set_last_integer (5)
end
end
else
if yy_act <= 61 then
if yy_act <= 60 then
if yy_act = 59 then
--|#line 175 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 175")
end
set_last_integer (5)
else
--|#line 176 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 176")
end
set_last_integer (5)
end
else
--|#line 177 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 177")
end
set_last_integer (5)
end
else
if yy_act <= 63 then
if yy_act = 62 then
--|#line 178 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 178")
end
set_last_integer (text.to_integer)
else
--|#line 179 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 179")
end
last_token := Colon_code
end
else
--|#line 180 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 180")
end
last_token := Minus_code
end
end
end
else
if yy_act <= 70 then
if yy_act <= 67 then
if yy_act <= 66 then
if yy_act = 65 then
--|#line 181 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 181")
end
 --"
					set_start_condition (INITIAL)
					last_token := Double_quote_code
					
else
--|#line 188 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 188")
end
last_token := Star_code
end
else
--|#line 189 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 189")
end
last_token := Plus_code
end
else
if yy_act <= 69 then
if yy_act = 68 then
--|#line 194 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 194")
end
last_token := IMAP4_BAD; last_value := text
else
--|#line 195 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 195")
end
last_token := IMAP4_BYE; last_value := text
end
else
--|#line 196 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 196")
end
last_token := IMAP4_NO; last_value := text
end
end
else
if yy_act <= 73 then
if yy_act <= 72 then
if yy_act = 71 then
--|#line 197 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 197")
end
last_token := IMAP4_OK; last_value := text
else
--|#line 202 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 202")
end
last_token := IMAP4_ALERT
end
else
--|#line 203 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 203")
end
last_token := IMAP4_PARSE
end
else
if yy_act <= 75 then
if yy_act = 74 then
--|#line 204 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 204")
end

					last_token := IMAP4_PERMANENTFLAGS
					set_start_condition (INITIAL)
					
else
--|#line 208 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 208")
end
last_token := IMAP4_READ_ONLY
end
else
--|#line 209 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 209")
end
last_token := IMAP4_READ_WRITE
end
end
end
end
else
if yy_act <= 89 then
if yy_act <= 83 then
if yy_act <= 80 then
if yy_act <= 78 then
if yy_act = 77 then
--|#line 210 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 210")
end
last_token := IMAP4_UIDNEXT
else
--|#line 211 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 211")
end
last_token := IMAP4_UIDVALIDITY
end
else
if yy_act = 79 then
--|#line 212 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 212")
end
last_token := IMAP4_UNSEEN
else
--|#line 213 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 213")
end
 --"
					last_token := IMAP4_ATOM_WITHOUT_RIGHT_BRACKET
					last_value := text
					set_start_condition (SC_RESP_TEXT_CODE_TEXT)
					
end
end
else
if yy_act <= 82 then
if yy_act = 81 then
--|#line 218 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 218")
end

					set_start_condition (INITIAL)
					
else
--|#line 221 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 221")
end

					last_token := Right_bracket_code
					set_start_condition (INITIAL)
					
end
else
--|#line 229 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 229")
end
last_token := IMAP4_HEADER; last_value := text
end
end
else
if yy_act <= 86 then
if yy_act <= 85 then
if yy_act = 84 then
--|#line 230 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 230")
end
last_token := IMAP4_HEADER_FIELDS; last_value := text
else
--|#line 231 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 231")
end
last_token := IMAP4_MIME; last_value := text
end
else
--|#line 232 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 232")
end
last_token := IMAP4_NOT; last_value := text
end
else
if yy_act <= 88 then
if yy_act = 87 then
--|#line 233 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 233")
end
last_token := IMAP4_TEXT; last_value := text
else
--|#line 238 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 238")
end

					last_value := text
					set_start_condition (INITIAL)
					last_token := IMAP4_TEXT_WITHOUT_RIGHT_BRACKET
					
end
else
--|#line 243 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 243")
end

					last_token := Right_bracket_code
					set_start_condition (INITIAL)
					
end
end
end
else
if yy_act <= 95 then
if yy_act <= 92 then
if yy_act <= 91 then
if yy_act = 90 then
--|#line 247 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 247")
end
set_start_condition (INITIAL)
else
--|#line 255 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 255")
end
 --"
					last_token := IMAP4_ATOM
					last_value := text
					
end
else
--|#line 263 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 263")
end
last_token := CRLF
end
else
if yy_act <= 94 then
if yy_act = 93 then
--|#line 264 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 264")
end
last_token := CRLF
else
--|#line 269 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 269")
end

end
else
--|#line 274 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 274")
end

					last_token := Left_bracket_code
					set_start_condition (SC_RESP_TEXT_CODE)
					
end
end
else
if yy_act <= 98 then
if yy_act <= 97 then
if yy_act = 96 then
--|#line 278 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 278")
end

					less (text.count - 1)
					set_start_condition (SC_RESP_TEXT)
					
else
--|#line 286 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 286")
end

					set_start_condition (SC_TEXT_MIME2)
					
end
else
--|#line 289 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 289")
end

					text.left_adjust
					text.right_adjust
					last_value := text
					last_token := IMAP4_TEXT
					set_start_condition (INITIAL)
					
end
else
if yy_act <= 100 then
if yy_act = 99 then
--|#line 296 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 296")
end

					last_token := CRLF
					set_start_condition (INITIAL)
					
else
--|#line 297 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 297")
end

					last_token := CRLF
					set_start_condition (INITIAL)
					
end
else
--|#line 0 "epx_imap4_response_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_imap4_response_scanner.l' at line 0")
end
default_action
end
end
end
end
end
end
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			terminate
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,   20,   21,   22,   23,   24,   25,   26,   27,   28,
			   29,   30,   24,   31,   31,   31,   24,   24,   24,   32,
			   33,   24,   24,   34,   35,   24,   36,   37,   24,   24,
			   38,   39,   40,   41,   24,   42,   24,   43,   44,   24,
			   24,   24,   24,   24,   45,   46,   47,   48,   49,   51,
			   65,   65,   82,   52,   53,  390,   54,   54,   54,   55,
			   20,   79,   56,   68,   69,   57,   82,   58,   68,   69,
			  389,   59,   20,   79,   60,   61,   62,   70,  178,   63,
			   98,  388,   70,   93,   93,   93,   94,   94,   94,   99,
			   95,   83,   66,   66,   20,   71,   20,   20,   87,   20,

			   20,   20,   20,   80,   96,   83,   88,  110,  111,  135,
			   89,  104,   73,   97,   90,   80,   91,  100,   92,  107,
			  105,  123,  123,  123,  101,  108,  124,   74,   75,  162,
			  125,   76,  123,  123,  123,  128,  163,  390,   20,   77,
			   20,   20,   71,   20,   20,  146,   20,   20,   20,   20,
			  147,  136,  143,  151,  129,  167,  144,  152,  181,   73,
			   93,   93,   93,   94,   94,   94,  390,  390,  390,  390,
			  390,  191,  168,  192,   74,   75,  135,  193,   76,  390,
			  179,  390,  183,  184,  194,   20,   77,   20,  115,  390,
			  390,  182,  180,  185,  123,  123,  123,  390,  116,  228,

			  229,  117,  227,  118,  390,  390,  226,  390,  390,  390,
			  390,  119,  390,  238,  120,  121,  231,  122,  136,  232,
			  239,  390,  390,  260,  230,  261,  390,  390,  262,  233,
			  390,  390,  390,  390,  390,  263,  264,  266,  390,  259,
			  390,  297,  390,  390,  289,  390,  387,  386,  298,  265,
			  292,  390,  390,  390,  293,  390,  390,  315,  390,  290,
			  291,  294,  385,  390,  332,  316,  295,  317,  314,  335,
			  390,  336,  319,  318,  333,  334,  337,  390,   86,  390,
			  390,   86,  338,  114,  353,  114,  114,  114,  114,  384,
			  383,  339,  352,  354,   20,   20,   20,   20,   20,   20,

			   20,   20,   20,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   67,   67,   67,   67,   67,   67,   67,   67,
			   67,   72,   72,   72,   72,   72,   72,   72,   72,   72,
			   78,   78,   78,   78,   78,   78,   78,   78,   78,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,  134,  134,
			  134,  134,  134,  134,  134,  134,  134,  137,  382,  381,
			  137,  137,  137,  137,  137,  137,  141,  380,  148,  141,
			  141,  148,  148,  148,  148,  148,  149,  149,  149,  149,
			  379,  149,  149,  149,  149,  150,  378,  150,  150,  150,
			  150,  150,  150,  150,  377,  376,  375,  374,  373,  372,

			  371,  370,  369,  368,  367,  366,  390,  390,  390,  365,
			  364,  363,  362,  361,  360,  359,  358,  357,  356,  355,
			  390,  390,  351,  350,  349,  348,  347,  346,  345,  344,
			  343,  342,  341,  340,  390,  331,  330,  329,  328,  327,
			  326,  325,  324,  323,  322,  321,  320,  390,  313,  312,
			  311,  310,  309,  308,  307,  306,  305,  304,  303,  302,
			  301,  300,  299,  296,  390,  288,  287,  286,  285,  284,
			  283,  282,  281,  280,  279,  278,  277,  276,  275,  274,
			  273,  272,  271,  270,  269,  268,  267,  258,  257,  256,
			  255,  254,  253,  252,  251,  250,  249,  248,  247,  246,

			  245,  244,  243,  242,  241,  240,  237,  236,  235,  234,
			  225,  224,  223,  222,  221,  220,  219,  218,  217,  216,
			  215,  214,  213,  212,  211,  210,  209,  208,  207,  206,
			  205,  204,  203,  202,  201,  200,  199,  198,  140,  197,
			  196,  195,  190,  189,  188,  187,  186,  390,  177,  176,
			  175,  174,  173,  172,  171,  170,  169,  166,  165,  164,
			  161,  160,  159,  158,  157,  156,  155,  154,  153,   84,
			  145,  142,  140,  139,  138,  133,  132,  131,  130,  127,
			  126,  113,  112,  109,  106,  103,  102,   85,   84,  390,
			   50,   50,   19,  390,  390,  390,  390,  390,  390,  390,

			  390,  390,  390,  390,  390,  390,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  390,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  390,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  390,  390,  390,  390,  390,
			  390, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    5,
			    7,    8,   17,    5,    5,  116,    5,    5,    5,    5,
			   13,   13,    5,    9,    9,    5,   18,    5,   10,   10,
			  388,    5,   14,   14,    5,    5,    5,    9,  116,    5,
			   34,  383,   10,   31,   31,   31,   32,   32,   32,   34,
			   33,   17,    7,    8,   11,   11,   11,   11,   25,   11,

			   11,   11,   11,   13,   33,   18,   25,   42,   42,   65,
			   25,   38,   11,   33,   25,   14,   25,   35,   25,   40,
			   38,   52,   52,   52,   35,   40,   56,   11,   11,   99,
			   56,   11,   54,   54,   54,   59,   99,  118,   11,   11,
			   11,   12,   12,   12,   12,   76,   12,   12,   12,   12,
			   76,   65,   74,   87,   59,  103,   74,   87,  118,   12,
			   93,   93,   93,   94,   94,   94,  117,  119,  120,  121,
			  122,  129,  103,  129,   12,   12,  135,  130,   12,  178,
			  117,  179,  120,  121,  130,   12,   12,   12,   46,  180,
			  181,  119,  117,  122,  123,  123,  123,  182,   46,  180,

			  181,   46,  179,   46,  183,  184,  178,  185,  226,  227,
			  228,   46,  229,  202,   46,   46,  183,   46,  135,  184,
			  202,  230,  231,  227,  182,  228,  232,  233,  229,  185,
			  259,  260,  261,  263,  262,  230,  231,  233,  264,  226,
			  266,  270,  289,  290,  259,  294,  382,  380,  270,  232,
			  262,  292,  295,  293,  263,  314,  338,  290,  315,  260,
			  261,  264,  379,  316,  313,  292,  266,  293,  289,  314,
			  317,  315,  295,  294,  313,  313,  316,  319,  397,  335,
			  339,  397,  317,  398,  338,  398,  398,  398,  398,  378,
			  376,  319,  335,  339,  391,  391,  391,  391,  391,  391,

			  391,  391,  391,  392,  392,  392,  392,  392,  392,  392,
			  392,  392,  393,  393,  393,  393,  393,  393,  393,  393,
			  393,  394,  394,  394,  394,  394,  394,  394,  394,  394,
			  395,  395,  395,  395,  395,  395,  395,  395,  395,  396,
			  396,  396,  396,  396,  396,  396,  396,  396,  399,  399,
			  399,  399,  399,  399,  399,  399,  399,  400,  373,  372,
			  400,  400,  400,  400,  400,  400,  401,  371,  402,  401,
			  401,  402,  402,  402,  402,  402,  403,  403,  403,  403,
			  370,  403,  403,  403,  403,  404,  369,  404,  404,  404,
			  404,  404,  404,  404,  368,  366,  365,  364,  363,  362,

			  361,  360,  359,  358,  357,  355,  354,  353,  352,  351,
			  350,  349,  348,  347,  346,  344,  343,  342,  341,  340,
			  337,  336,  334,  333,  332,  331,  330,  328,  326,  325,
			  324,  322,  321,  320,  318,  312,  311,  309,  308,  306,
			  305,  302,  300,  299,  298,  297,  296,  291,  288,  286,
			  285,  284,  282,  281,  280,  278,  277,  276,  275,  274,
			  273,  272,  271,  269,  265,  258,  257,  256,  254,  251,
			  250,  249,  248,  247,  246,  245,  244,  243,  242,  241,
			  240,  239,  238,  237,  236,  235,  234,  224,  223,  219,
			  218,  217,  216,  215,  214,  213,  212,  211,  210,  209,

			  208,  207,  206,  205,  204,  203,  201,  200,  199,  198,
			  176,  175,  174,  171,  170,  169,  168,  167,  166,  165,
			  164,  163,  162,  161,  159,  157,  156,  155,  154,  153,
			  152,  151,  147,  146,  145,  144,  143,  142,  140,  133,
			  132,  131,  128,  127,  126,  125,  124,  114,  113,  112,
			  111,  110,  108,  107,  106,  105,  104,  102,  101,  100,
			   98,   97,   96,   95,   92,   91,   90,   89,   88,   84,
			   75,   73,   71,   70,   69,   63,   62,   61,   60,   58,
			   57,   44,   43,   41,   39,   37,   36,   23,   21,   19,
			    4,    3,  390,  390,  390,  390,  390,  390,  390,  390,

			  390,  390,  390,  390,  390,  390,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  390,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  390,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  390,  390,  390,  390,  390,
			  390, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,  585,  584,   43,    0,   48,   49,   60,
			   65,   93,  140,   57,   69,    0,    0,   46,   60,  589,
			  592,  586,  592,  584,    0,   79,  592,  592,  592,    0,
			    0,   70,   73,   71,   48,   94,  563,  553,   84,  557,
			   92,  554,   84,  559,  554,  592,  179,  592,  592,  592,
			  592,  592,  108,  592,  119,  592,   92,  557,  556,  116,
			  559,  544,  555,  552,  592,  107,  592,    0,  592,  571,
			  555,  570,    0,  541,  133,  547,  118,  592,    0,  592,
			  592,    0,  592,    0,  567,  592,    0,  119,  537,  544,
			  542,  542,  537,  147,  150,  541,  540,  538,  521,  102,

			  522,  539,  538,  135,  520,  517,  523,  523,  515,    0,
			  530,  529,  508,  526,  538,  592,   46,  157,  128,  158,
			  159,  160,  161,  181,  511,  520,  523,  523,  510,  141,
			  142,  502,  503,  505,  592,  174,  592,    0,  592,    0,
			  536,    0,  514,  501,  500,  515,  511,  496,    0,    0,
			  592,  497,  508,  510,  492,  506,  485,  503,    0,  482,
			    0,  500,  486,  483,  499,  494,  496,  484,  493,  478,
			  494,  490,    0,    0,  489,  496,  473,    0,  170,  172,
			  180,  181,  188,  195,  196,  198,  592,  592,  592,  592,
			  592,  592,  592,  592,  592,  592,  592,  592,  474,  472,

			  476,  484,  181,  482,  474,  476,  477,  465,  485,  462,
			  475,  461,  466,  458,  462,  467,  456,  468,  449,  454,
			    0,    0,    0,  456,  473,    0,  199,  200,  201,  203,
			  212,  213,  217,  218,  449,  462,  465,  472,  459,  462,
			  457,  452,  445,  454,  457,  461,  468,  440,  435,  438,
			  434,  444,    0,    0,  433,    0,  435,  429,  451,  221,
			  222,  223,  225,  224,  229,  455,  231,    0,    0,  431,
			  208,  421,  431,  428,  438,  452,  451,  431,  441,  592,
			  448,  418,  418,    0,  428,  438,  430,    0,  436,  233,
			  234,  438,  242,  244,  236,  243,  423,  413,  409,  406,

			  415,    0,  422,  592,  592,  417,  433,  592,  400,  414,
			    0,  412,  405,  238,  246,  249,  254,  261,  425,  268,
			  401,  402,  404,    0,  408,  392,  422,  592,  406,    0,
			  399,  403,  401,  396,  399,  270,  412,  411,  247,  271,
			  382,  376,  380,  389,  388,  592,  377,  390,  393,  392,
			  367,  368,  399,  398,  397,  381,    0,  381,  366,  369,
			  363,  370,  362,  376,  374,  359,  365,    0,  352,  354,
			  345,  345,  336,  335,    0,    0,  271,    0,  283,  239,
			  211,    0,  211,   56,  592,    0,    0,    0,   34,    0,
			  592,  293,  302,  311,  320,  329,  338,  274,  279,  347,

			  356,  362,  367,  375,  384, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  390,    1,  391,  391,  391,    5,  392,  392,  393,
			  393,  394,  394,  395,  395,  391,  391,  396,  396,  390,
			  390,  390,  390,  390,  397,  390,  390,  390,  390,  397,
			  397,  397,  397,  397,  397,  397,  397,  397,  397,  397,
			  397,  397,  397,  397,  397,  390,  398,  390,  390,  390,
			  390,  390,  390,  390,  390,  390,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  399,  390,  400,  390,  390,
			  400,  390,  401,  401,  401,  401,  401,  390,  402,  390,
			  390,  403,  390,  404,  390,  390,  397,  390,  390,  390,
			  390,  390,  390,  397,  397,  397,  397,  397,  397,  397,

			  397,  397,  397,  397,  397,  397,  397,  397,  397,  397,
			  397,  397,  397,  397,  398,  390,  398,  398,  398,  398,
			  398,  398,  398,  390,  390,  390,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  399,  390,  400,  390,  400,
			  390,  401,  401,  401,  401,  401,  401,  401,  402,  403,
			  390,  390,  390,  390,  390,  390,  390,  390,  397,  397,
			  397,  397,  397,  397,  397,  397,  397,  397,  397,  397,
			  397,  397,  397,  397,  397,  397,  397,  397,  398,  398,
			  398,  398,  398,  398,  398,  398,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  390,  390,  390,  401,  401,

			  401,  401,  401,  401,  390,  390,  390,  390,  390,  390,
			  390,  397,  397,  397,  397,  397,  397,  397,  397,  397,
			  397,  397,  397,  397,  397,  397,  398,  398,  398,  398,
			  398,  398,  398,  398,  401,  401,  401,  401,  401,  401,
			  401,  390,  390,  390,  390,  390,  390,  390,  397,  397,
			  397,  397,  397,  397,  397,  397,  397,  397,  397,  398,
			  398,  398,  398,  398,  398,  398,  398,  401,  401,  401,
			  401,  401,  401,  401,  390,  390,  390,  390,  390,  390,
			  390,  397,  397,  397,  397,  397,  397,  397,  397,  398,
			  398,  398,  398,  398,  398,  398,  401,  401,  401,  401,

			  401,  401,  390,  390,  390,  390,  390,  390,  397,  397,
			  397,  397,  397,  397,  398,  398,  398,  398,  398,  398,
			  401,  401,  401,  401,  401,  390,  390,  390,  397,  397,
			  397,  397,  397,  397,  397,  398,  398,  398,  398,  398,
			  401,  401,  401,  401,  390,  390,  397,  397,  397,  397,
			  397,  397,  398,  398,  398,  401,  401,  401,  401,  390,
			  397,  397,  397,  397,  397,  397,  401,  401,  401,  390,
			  397,  397,  397,  397,  397,  397,  401,  401,  390,  397,
			  397,  397,  397,  401,  390,  397,  397,  397,  401,  401,
			    0,  390,  390,  390,  390,  390,  390,  390,  390,  390,

			  390,  390,  390,  390,  390, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    4,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    2,    5,    6,    5,    5,    1,    5,    5,
			    7,    8,    9,   10,    5,   11,   12,    5,   13,   13,
			   14,   13,   13,   13,   13,   13,   15,   13,   16,    5,
			    5,   17,    5,   18,    5,   19,   20,   21,   22,   23,
			   24,   25,   26,   27,   28,   29,   30,   31,   32,   33,
			   34,    5,   35,   36,   37,   38,   39,   40,   41,   42,
			   43,   44,   45,   46,    5,    5,    5,   19,   20,   21,

			   22,   23,   24,   25,   26,   27,   28,   29,   30,   31,
			   32,   33,   34,    5,   35,   36,   37,   38,   39,   40,
			   41,   42,   43,   47,    5,   48,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,

			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    1, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    2,    3,    4,    5,    1,    1,    6,
			    4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
			    4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
			    4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
			    4,    4,    4,    7,    8,    5,    9,    1,    8, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,  102,
			  101,   94,   93,  101,   91,   28,    3,    4,   66,   67,
			    7,   20,   91,   91,   91,   91,   91,   91,   91,   91,
			   91,   91,   91,   91,   91,    1,  101,    2,    5,    6,
			   49,   65,  101,   64,   62,   63,  101,  101,  101,  101,
			  101,  101,  101,  101,   96,   96,   95,   98,   99,  101,
			   98,   81,   80,   80,   80,   80,   80,   82,   88,   90,
			   89,   29,   31,  101,   94,   92,   91,    0,    0,    0,
			    0,    0,    0,   20,    8,   91,   91,   91,   91,   91,

			   91,   91,   91,   91,   91,   91,   91,   91,   70,   71,
			   91,   91,   91,   91,   18,   17,   18,   18,   18,   18,
			   18,   18,   18,   62,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,   96,   96,   95,   98,  100,   97,
			   81,   80,   80,   80,   80,   80,   80,   80,   88,   29,
			   30,    0,    0,    0,    0,    0,    0,    0,   68,   91,
			   69,   91,   91,   91,   91,   91,   91,   91,   91,   91,
			   91,   91,   32,   86,   91,   91,   91,   48,   18,   18,
			   18,   18,   18,   18,   18,   18,   53,   57,   61,   51,
			   50,   56,   55,   52,   54,   60,   59,   58,   80,   80,

			   80,   80,   80,   80,    0,    0,    0,    0,    0,    0,
			    0,   40,   91,   91,   91,   91,   91,   91,   91,   91,
			   35,   36,   85,   91,   91,   87,   18,   18,   18,   18,
			   18,   18,   18,   18,   80,   80,   80,   80,   80,   80,
			   80,    0,    0,    0,    0,    0,    0,    0,   91,   91,
			   91,   91,   39,   34,   91,   19,   91,   91,   91,   18,
			   18,   18,   18,   18,   18,   12,   18,   72,   73,   80,
			   80,   80,   80,   80,    0,    0,    0,    0,    0,   26,
			    0,   91,   91,   33,   91,   83,   91,   37,   44,   18,
			   18,   13,   18,   18,   18,   18,   80,   80,   80,   80,

			   80,   79,    0,   22,   23,    0,    0,   27,   91,   91,
			   38,   91,   91,   91,   18,   18,   18,   18,   16,   18,
			   80,   80,   80,   77,   80,    0,    0,   25,   91,   42,
			   91,   91,   91,   91,   91,   18,   11,   10,   18,   18,
			   80,   80,   80,   80,    0,   24,   91,   91,   91,   91,
			   91,   91,    9,   14,   15,   80,   75,   80,   80,    0,
			   91,   91,   91,   91,   91,   91,   80,   76,   80,    0,
			   91,   91,   91,   91,   46,   47,   80,   78,    0,   91,
			   91,   43,   91,   80,   21,   41,   84,   45,   80,   74,
			    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 592
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 390
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 391
			-- Mark between normal states and templates

	yyNull_equiv_class: INTEGER is 1
			-- Equivalence code for NULL character

	yyReject_used: BOOLEAN is false
			-- Is `reject' called?

	yyVariable_trail_context: BOOLEAN is false
			-- Is there a regular expression with
			-- both leading and trailing parts having
			-- variable length?

	yyReject_or_variable_trail_context: BOOLEAN is false
			-- Is `reject' called or is there a
			-- regular expression with both leading
			-- and trailing parts having variable length?

	yyNb_rules: INTEGER is 101
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 102
			-- End of buffer rule code

	yyLine_used: BOOLEAN is false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
	SC_SCAN_DATE_TIME: INTEGER is 1
	SC_DATE_TIME: INTEGER is 2
	SC_SCAN_RESP_TEXT: INTEGER is 3
	SC_RESP_TEXT: INTEGER is 4
	SC_RESP_TEXT_CODE: INTEGER is 5
	SC_RESP_TEXT_CODE_TEXT: INTEGER is 6
	SC_TEXT_MIME2: INTEGER is 7
	SC_QUOTED_STRING: INTEGER is 8
			-- Start condition codes

feature -- User-defined features




feature -- Last returned data

	last_value: ANY


feature -- Input

	end_of_file_after_end_of_line: BOOLEAN
			-- Avoid blocking knob.

	new_imap4_response_buffer (a_stream: EPX_CHARACTER_INPUT_STREAM): EPX_IMAP4_RESPONSE_BUFFER is
			-- New input buffer for `a_stream'.
		require
			stream_not_void: a_stream /= Void
			stream_open: a_stream.is_open_read
		do
			create Result.make (a_stream, Current)
		ensure
			new_buffer_not_void: Result /= Void
		end

	reset_end_of_file_after_end_of_line is
			-- Reset `end_of_file_after_end_of_line'. Set when tagged
			-- response is received, or a fatal error.
		do
			end_of_file_after_end_of_line := False
		ensure
			not_end_of_file_after_end_of_line: not end_of_file_after_end_of_line
		end


feature {NONE} -- Last returned data helpers

	last_integer: INTEGER_REF

	last_string: STRING
			-- Building quoted string.

	set_last_integer (a_number: INTEGER) is
			-- Set `last_integer', `last_token' is INT_NUMBER.
		do
			last_token := INT_NUMBER
			create last_integer
			last_integer.set_item (a_number)
			last_value := last_integer
		ensure
			last_token_is_number: last_token = INT_NUMBER
			new_integer: last_integer /= old last_integer
			value_set: last_integer.item = a_number
			last_value_is_integer: last_value = last_integer
		end


feature {NONE} -- Set start condition

	expect_date_time is
		do
			set_start_condition (SC_SCAN_DATE_TIME)
		end

	expect_resp_text is
			-- Set start state to RESP_TEXT.
		do
			set_start_condition (SC_RESP_TEXT)
		end

	reset_start_condition is
			-- Used in error recovery to return to start condition.
		do
			set_start_condition (INITIAL)
		end

	scan_resp_text is
			-- Scan forward to see if a '[' follows or not by setting
			-- state to SCAN_RESP_TEXT.
		do
			set_start_condition (SC_SCAN_RESP_TEXT)
		end

end
