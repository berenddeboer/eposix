indexing

	description:
		"Scanner for mime messages."

	standards:
		"Based on RFC 2822, 2045 and 2047."

	known_bugs:
		"1. B encoding not decoded."

	author: "Berend de Boer"
	date: "$Date: $"
	revision: "$Revision: $"


class

	EPX_MIME_SCANNER


inherit

	YY_COMPRESSED_SCANNER_SKELETON
		export
			{EPX_MIME_PARSER} yyEnd_of_file_character
		redefine
			make
		end

	UT_CHARACTER_CODES
		export {NONE} all end

	KL_CHARACTER_ROUTINES
		export
			{NONE} all
		end

	EPX_MIME_TOKENS
		export
			{NONE} all
		end


creation

	make


feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= DATE)
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
if yy_act <= 60 then
if yy_act <= 30 then
if yy_act <= 15 then
if yy_act <= 8 then
if yy_act <= 4 then
if yy_act <= 2 then
if yy_act = 1 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 75 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 75")
end
-- Ignore white space
else
	yy_column := yy_column + 3
--|#line 79 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 79")
end

							last_token := FN_BCC
							to_condition := STRUCTURED_FIELD_BODY
							
end
else
if yy_act = 3 then
	yy_column := yy_column + 2
--|#line 83 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 83")
end

							last_token := FN_CC
							to_condition := STRUCTURED_FIELD_BODY
							
else
	yy_column := yy_column + 19
--|#line 87 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 87")
end

							last_token := FN_CONTENT_DISPOSITION
							to_condition := MIME_FIELD_BODY
							
end
end
else
if yy_act <= 6 then
if yy_act = 5 then
	yy_column := yy_column + 14
--|#line 91 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 91")
end

							last_token := FN_CONTENT_LENGTH
							to_condition := MIME_FIELD_BODY
							
else
	yy_column := yy_column + 25
--|#line 95 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 95")
end

							last_token := FN_CONTENT_TRANSFER_ENCODING
							to_condition := MIME_FIELD_BODY
							
end
else
if yy_act = 7 then
	yy_column := yy_column + 12
--|#line 99 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 99")
end

							last_token := FN_CONTENT_TYPE
							to_condition := MIME_FIELD_BODY
							
else
	yy_column := yy_column + 4
--|#line 103 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 103")
end

							last_token := FN_DATE
							to_condition := STRUCTURED_FIELD_BODY
							
end
end
end
else
if yy_act <= 12 then
if yy_act <= 10 then
if yy_act = 9 then
	yy_column := yy_column + 4
--|#line 107 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 107")
end

							last_token := FN_FROM
							to_condition := STRUCTURED_FIELD_BODY
							
else
	yy_column := yy_column + 17
--|#line 111 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 111")
end

							last_token := FN_IF_MODIFIED_SINCE
							to_condition := STRUCTURED_FIELD_BODY
							
end
else
if yy_act = 11 then
	yy_column := yy_column + 13
--|#line 115 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 115")
end

							last_token := FN_LAST_MODIFIED
							to_condition := STRUCTURED_FIELD_BODY
							
else
	yy_column := yy_column + 10
--|#line 119 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 119")
end

							last_token := FN_MESSAGE_ID
							to_condition := STRUCTURED_FIELD_BODY
							
end
end
else
if yy_act <= 14 then
if yy_act = 13 then
	yy_column := yy_column + 12
--|#line 123 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 123")
end

							last_token := FN_VERSION
							-- I want to see two integers.
							-- tspecials from RFC 2045 include token, so I
							-- just get an atom if parsed according to that syntax.
							to_condition := STRUCTURED_FIELD_BODY
							
else
	yy_column := yy_column + 11
--|#line 136 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 136")
end

							last_token := FN_RESENT_FROM
							to_condition := STRUCTURED_FIELD_BODY
							
end
else
	yy_column := yy_column + 15
--|#line 140 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 140")
end

							last_token := FN_RESENT_REPLY_TO
							to_condition := STRUCTURED_FIELD_BODY
							
end
end
end
else
if yy_act <= 23 then
if yy_act <= 19 then
if yy_act <= 17 then
if yy_act = 16 then
	yy_column := yy_column + 13
--|#line 144 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 144")
end

							last_token := FN_RESENT_SENDER
							to_condition := STRUCTURED_FIELD_BODY
							
else
	yy_column := yy_column + 11
--|#line 148 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 148")
end

							last_token := FN_RETURN_PATH
							to_condition := STRUCTURED_FIELD_BODY
							
end
else
if yy_act = 18 then
	yy_column := yy_column + 6
--|#line 152 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 152")
end

							last_token := FN_SENDER
							to_condition := STRUCTURED_FIELD_BODY
							
else
	yy_column := yy_column + 10
--|#line 156 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 156")
end

							last_token := FN_SET_COOKIE
							to_condition := MIME_FIELD_BODY
							
end
end
else
if yy_act <= 21 then
if yy_act = 20 then
	yy_column := yy_column + 2
--|#line 160 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 160")
end

							last_token := FN_TO
							to_condition := STRUCTURED_FIELD_BODY
							
else
	yy_column := yy_column + 17
--|#line 164 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 164")
end

							last_token := FN_TRANSFER_ENCODING
							to_condition := MIME_FIELD_BODY
							
end
else
if yy_act = 22 then
	yy_column := yy_column + 16
--|#line 168 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 168")
end

							last_token := FN_WWW_AUTHENTICATE
							to_condition := MIME_FIELD_BODY
							
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 180 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 180")
end

							last_token := FIELD_NAME
							last_string_value := to_canonical_field_name (text)
							to_condition := UNSTRUCTURED_FIELD_BODY
							
end
end
end
else
if yy_act <= 27 then
if yy_act <= 25 then
if yy_act = 24 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 186 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 186")
end
 -- include space, so it's already skipped
							create last_string_value.make (64)
							last_token := Colon_code
							if to_condition /= 0 then
								set_start_condition (to_condition)
							end
							
else
	yy_line := yy_line + 1
	yy_column := 1
--|#line 194 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 194")
end

							last_token := CRLF
							
end
else
if yy_act = 26 then
	yy_column := yy_column + 1
--|#line 202 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 202")
end

							set_start_condition (COMMENT)
							
else
	yy_column := yy_column + 1
--|#line 205 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 205")
end

							create last_string_value.make (32)
							set_start_condition (SC_DOMAIN_LITERAL)
							
end
end
else
if yy_act <= 29 then
if yy_act = 28 then
	yy_column := yy_column + 1
--|#line 209 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 209")
end
 --"
							create last_string_value.make (32)
							set_start_condition (SC_QUOTED_STRING)
							
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 213 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 213")
end
-- White space, ignore
end
else
yy_set_column (1)
--|#line 214 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 214")
end
-- Folded-line white space, ignore
end
end
end
end
else
if yy_act <= 45 then
if yy_act <= 38 then
if yy_act <= 34 then
if yy_act <= 32 then
if yy_act = 31 then
	yy_line := yy_line + 1
	yy_column := 1
--|#line 215 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 215")
end

							set_start_condition (INITIAL)
							to_condition := 0
							last_token := CRLF
							
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 220 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 220")
end
 --'
							last_token := MIME_ATOM
							if encoded_word_scanner.is_encoded_word (text) then
								last_string_value := encoded_word_scanner.decode_word (text)
							else
								last_string_value := text
							end
							
end
else
if yy_act = 33 then
	yy_column := yy_column + 1
--|#line 228 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 228")
end
 -- pass rest of stuff as is, perhaps exclude 8-bit chars??
							last_token := text.item (1).code
							
else
	yy_column := yy_column + 1
--|#line 236 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 236")
end

							set_start_condition (COMMENT)
							
end
end
else
if yy_act <= 36 then
if yy_act = 35 then
	yy_column := yy_column + 1
--|#line 239 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 239")
end

							create last_string_value.make (32)
							set_start_condition (SC_DOMAIN_LITERAL)
							
else
	yy_column := yy_column + 1
--|#line 243 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 243")
end
 --"
							create last_string_value.make (32)
							set_start_condition (SC_QUOTED_STRING)
							
end
else
if yy_act = 37 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 247 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 247")
end
-- White space, ignore
else
yy_set_column (1)
--|#line 248 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 248")
end
-- Folded-line white space, ignore
end
end
end
else
if yy_act <= 42 then
if yy_act <= 40 then
if yy_act = 39 then
	yy_line := yy_line + 1
	yy_column := 1
--|#line 249 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 249")
end

							set_start_condition (INITIAL)
							to_condition := 0
							last_token := CRLF
							
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 254 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 254")
end
 --"
							last_token := MIME_ATOM
							if encoded_word_scanner.is_encoded_word (text) then
								last_string_value := encoded_word_scanner.decode_word (text)
							else
								last_string_value := text
							end
							
end
else
if yy_act = 41 then
	yy_column := yy_column + 1
--|#line 262 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 262")
end
 -- just return every other character
							last_token := text.item (1).code
							
else
	yy_column := yy_column + 1
--|#line 266 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 266")
end
 last_token := Semicolon_code 
end
end
else
if yy_act <= 44 then
if yy_act = 43 then
	yy_column := yy_column + 1
--|#line 267 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 267")
end
 last_token := Equal_code 
else
	yy_column := yy_column + 1
--|#line 268 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 268")
end

							to_condition := PARAMETER
							set_start_condition (COMMENT)
							
end
else
	yy_column := yy_column + 1
--|#line 272 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 272")
end
 --"
							create last_string_value.make (32)
							to_condition := PARAMETER
							set_start_condition (SC_QUOTED_STRING)
							
end
end
end
else
if yy_act <= 53 then
if yy_act <= 49 then
if yy_act <= 47 then
if yy_act = 46 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 277 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 277")
end
-- White space, ignore
else
yy_set_column (1)
--|#line 278 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 278")
end
-- Folded-line white space, ignore
end
else
if yy_act = 48 then
	yy_line := yy_line + 1
	yy_column := 1
--|#line 279 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 279")
end

							set_start_condition (INITIAL)
							to_condition := 0
							last_token := CRLF
							
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 284 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 284")
end
 --"
							last_string_value := text
							last_token := MIME_ATOM
							
end
end
else
if yy_act <= 51 then
if yy_act = 50 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 291 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 291")
end
 --"
							last_string_value := text
							last_token := MIME_VALUE_ATOM
							
else
	yy_column := yy_column + 1
--|#line 295 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 295")
end
 -- ignore all other stuff??
							last_token := text.item (1).code
							
end
else
if yy_act = 52 then
	yy_column := yy_column + 3
--|#line 304 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 304")
end
last_token := KW_SUN
else
	yy_column := yy_column + 3
--|#line 305 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 305")
end
last_token := KW_MON
end
end
end
else
if yy_act <= 57 then
if yy_act <= 55 then
if yy_act = 54 then
	yy_column := yy_column + 3
--|#line 306 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 306")
end
last_token := KW_TUE
else
	yy_column := yy_column + 3
--|#line 307 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 307")
end
last_token := KW_WED
end
else
if yy_act = 56 then
	yy_column := yy_column + 3
--|#line 308 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 308")
end
last_token := KW_THU
else
	yy_column := yy_column + 3
--|#line 309 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 309")
end
last_token := KW_FRI
end
end
else
if yy_act <= 59 then
if yy_act = 58 then
	yy_column := yy_column + 3
--|#line 310 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 310")
end
last_token := KW_SAT
else
	yy_column := yy_column + 6
--|#line 311 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 311")
end
last_token := KW_SUN
end
else
	yy_column := yy_column + 6
--|#line 312 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 312")
end
last_token := KW_MON
end
end
end
end
end
else
if yy_act <= 90 then
if yy_act <= 75 then
if yy_act <= 68 then
if yy_act <= 64 then
if yy_act <= 62 then
if yy_act = 61 then
	yy_column := yy_column + 7
--|#line 313 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 313")
end
last_token := KW_TUE
else
	yy_column := yy_column + 9
--|#line 314 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 314")
end
last_token := KW_WED
end
else
if yy_act = 63 then
	yy_column := yy_column + 8
--|#line 315 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 315")
end
last_token := KW_THU
else
	yy_column := yy_column + 6
--|#line 316 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 316")
end
last_token := KW_FRI
end
end
else
if yy_act <= 66 then
if yy_act = 65 then
	yy_column := yy_column + 8
--|#line 317 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 317")
end
last_token := KW_SAT
else
	yy_column := yy_column + 3
--|#line 318 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 318")
end
last_token := MONTH; last_integer_value := 1
end
else
if yy_act = 67 then
	yy_column := yy_column + 3
--|#line 319 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 319")
end
last_token := MONTH; last_integer_value := 2
else
	yy_column := yy_column + 3
--|#line 320 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 320")
end
last_token := MONTH; last_integer_value := 3
end
end
end
else
if yy_act <= 72 then
if yy_act <= 70 then
if yy_act = 69 then
	yy_column := yy_column + 3
--|#line 321 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 321")
end
last_token := MONTH; last_integer_value := 4
else
	yy_column := yy_column + 3
--|#line 322 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 322")
end
last_token := MONTH; last_integer_value := 5
end
else
if yy_act = 71 then
	yy_column := yy_column + 3
--|#line 323 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 323")
end
last_token := MONTH; last_integer_value := 6
else
	yy_column := yy_column + 3
--|#line 324 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 324")
end
last_token := MONTH; last_integer_value := 7
end
end
else
if yy_act <= 74 then
if yy_act = 73 then
	yy_column := yy_column + 3
--|#line 325 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 325")
end
last_token := MONTH; last_integer_value := 8
else
	yy_column := yy_column + 3
--|#line 326 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 326")
end
last_token := MONTH; last_integer_value := 9
end
else
	yy_column := yy_column + 3
--|#line 327 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 327")
end
last_token := MONTH; last_integer_value := 10
end
end
end
else
if yy_act <= 83 then
if yy_act <= 79 then
if yy_act <= 77 then
if yy_act = 76 then
	yy_column := yy_column + 3
--|#line 328 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 328")
end
last_token := MONTH; last_integer_value := 11
else
	yy_column := yy_column + 3
--|#line 329 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 329")
end
last_token := MONTH; last_integer_value := 12
end
else
if yy_act = 78 then
	yy_column := yy_column + 3
--|#line 330 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 330")
end
last_token := NUMBER; last_integer_value := 0
else
	yy_column := yy_column + 2
--|#line 331 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 331")
end
last_token := NUMBER; last_integer_value := 0
end
end
else
if yy_act <= 81 then
if yy_act = 80 then
	yy_column := yy_column + 3
--|#line 332 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 332")
end
last_token := NUMBER; last_integer_value := -5
else
	yy_column := yy_column + 3
--|#line 333 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 333")
end
last_token := NUMBER; last_integer_value := -4
end
else
if yy_act = 82 then
	yy_column := yy_column + 3
--|#line 334 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 334")
end
last_token := NUMBER; last_integer_value := -6
else
	yy_column := yy_column + 3
--|#line 335 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 335")
end
last_token := NUMBER; last_integer_value := -5
end
end
end
else
if yy_act <= 87 then
if yy_act <= 85 then
if yy_act = 84 then
	yy_column := yy_column + 3
--|#line 336 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 336")
end
last_token := NUMBER; last_integer_value := -7
else
	yy_column := yy_column + 3
--|#line 337 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 337")
end
last_token := NUMBER; last_integer_value := -6
end
else
if yy_act = 86 then
	yy_column := yy_column + 3
--|#line 338 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 338")
end
last_token := NUMBER; last_integer_value := -8
else
	yy_column := yy_column + 3
--|#line 339 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 339")
end
last_token := NUMBER; last_integer_value := -7
end
end
else
if yy_act <= 89 then
if yy_act = 88 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 340 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 340")
end
 -- parse these time zones, but ignore them
						  last_token := NUMBER; last_string_value := text; last_integer_value := 0
						  
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 343 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 343")
end
 -- finally, parse the shit spammers spew out like time zone XXXXXXXXXXXX
						  last_token := NUMBER; last_string_value := text; last_integer_value := 0
						  
end
else
	yy_column := yy_column + 1
--|#line 346 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 346")
end
last_token := Comma_code
end
end
end
end
else
if yy_act <= 105 then
if yy_act <= 98 then
if yy_act <= 94 then
if yy_act <= 92 then
if yy_act = 91 then
	yy_column := yy_column + 1
--|#line 347 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 347")
end
last_token := Colon_code
else
	yy_column := yy_column + 1
--|#line 348 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 348")
end
last_token := Minus_code
end
else
if yy_act = 93 then
	yy_column := yy_column + 1
--|#line 349 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 349")
end

						  last_token := Semicolon_code
						  set_start_condition (STRUCTURED_FIELD_BODY)
						  
else
	yy_column := yy_column + 1
--|#line 353 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 353")
end
 -- " we use this to recognize some s**t
						  last_token := Double_quote_code
						  
end
end
else
if yy_act <= 96 then
if yy_act = 95 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 356 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 356")
end
-- (Folded-line) white space, ignore
else
yy_set_column (1)
--|#line 357 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 357")
end
-- (Folded-line) white space, ignore
end
else
if yy_act = 97 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 358 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 358")
end

						  last_integer_value := text.to_integer
						  last_token := NUMBER
						  
else
	yy_column := yy_column + 1
--|#line 362 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 362")
end

						  to_condition := DATE
						  set_start_condition (COMMENT)
						  
end
end
end
else
if yy_act <= 102 then
if yy_act <= 100 then
if yy_act = 99 then
	yy_line := yy_line + 1
	yy_column := 1
--|#line 366 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 366")
end

						  set_start_condition (INITIAL)
						  to_condition := 0
						  last_token := CRLF
						  
else
	yy_column := yy_column + 2
--|#line 375 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 375")
end
 
end
else
if yy_act = 101 then
	yy_column := yy_column + 2
--|#line 376 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 376")
end
 
else
	yy_column := yy_column + 1
--|#line 377 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 377")
end

							if nested_comment_count = 0 then
								set_start_condition (to_condition)
							else
								nested_comment_count := nested_comment_count - 1
							end
							
end
end
else
if yy_act <= 104 then
if yy_act = 103 then
	yy_column := yy_column + 1
--|#line 384 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 384")
end
 nested_comment_count := nested_comment_count + 1 
else
yy_set_line_column
--|#line 385 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 385")
end
 
end
else
	yy_column := yy_column + 2
--|#line 391 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 391")
end
 last_string_value.append_character (text.item (2)) 
end
end
end
else
if yy_act <= 112 then
if yy_act <= 109 then
if yy_act <= 107 then
if yy_act = 106 then
	yy_column := yy_column + 1
--|#line 392 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 392")
end

							set_start_condition (to_condition)
							last_token := DOMAIN_LITERAL
							
else
yy_set_column (1)
--|#line 396 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 396")
end

							last_string_value.append_character (' ')
							
end
else
if yy_act = 108 then
yy_set_line_column
--|#line 399 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 399")
end
 last_string_value.append_string (text) 
else
	yy_column := yy_column + 2
--|#line 404 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 404")
end
 last_string_value.append_character (text.item (2)) 
end
end
else
if yy_act <= 111 then
if yy_act = 110 then
	yy_column := yy_column + 1
--|#line 405 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 405")
end
 --"
							set_start_condition (to_condition)
							last_token := QUOTED_STRING
							
else
yy_set_column (1)
--|#line 409 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 409")
end

							last_string_value.append_character (' ')
							
end
else
yy_set_line_column
--|#line 412 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 412")
end
 --"
							last_string_value.append_string (text)
							
end
end
else
if yy_act <= 116 then
if yy_act <= 114 then
if yy_act = 113 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 419 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 419")
end

							if encoded_word_scanner.is_encoded_word (text) then
								if prev_word_was_encoded then
									from
									until
										last_string_value.is_empty or else
										(last_string_value.item (last_string_value.count) /= ' ' and then
										last_string_value.item (last_string_value.count) /= '%T')
									loop
										last_string_value.keep_head (last_string_value.count - 1)
									end
								end
								last_string_value.append_string (encoded_word_scanner.decode_word (text))
								prev_word_was_encoded := True
							else
								last_string_value.append_string (text)
								prev_word_was_encoded := False
							end
							
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 438 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 438")
end
last_string_value.append_string (text)
end
else
if yy_act = 115 then
yy_set_column (1)
--|#line 439 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 439")
end
 -- Folded line
							last_string_value.append_character (' ')
							
else
	yy_line := yy_line + 1
	yy_column := 1
--|#line 442 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 442")
end

							if last_string_value.is_empty then
								last_token := CRLF
							else
								less (0)
								last_token := FIELD_BODY
							end
							to_condition := 0
							set_start_condition (INITIAL)
							prev_word_was_encoded := False
							
end
end
else
if yy_act <= 118 then
if yy_act = 117 then
	yy_column := yy_column + 1
--|#line 453 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 453")
end
-- ignore lone CR's
else
	yy_column := yy_column + 1
--|#line 459 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 459")
end
-- ignore all other charcters, i.e. ascii unprintables and high ascii
end
else
yy_set_line_column
--|#line 0 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 0")
end
last_token := yyError_token
fatal_error ("scanner jammed")
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
			inspect yy_sc
when 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 then
--|#line 0 "epx_mime_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_scanner.l' at line 0")
end
 terminate 
			else
				terminate
			end
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,   22,   23,   24,   25,   40,   41,   42,   40,   41,
			   42,   80,   81,  416,   82,   27,   70,   71,   70,   71,
			  148,  149,  150,   28,   29,   30,  207,   31,   80,   81,
			   32,   82,  123,   33,   34,  117,  124,   74,   75,   35,
			   36,   37,   74,   75,   38,  127,  155,  118,  128,  159,
			   22,   22,   23,   24,   25,   83,   72,  165,   72,  233,
			  191,  168,  166,  175,  171,   27,  167,  154,  167,  167,
			  170,  183,   83,   28,   29,   30,  169,   31,  167,  172,
			   32,   76,   77,   33,   34,  167,   76,   77,  167,   35,
			   36,   37,  209,  167,   38,  167,  167,  164,  182,  184,

			   22,   43,   44,   45,   46,  173,   48,   49,   43,  176,
			   43,  167,   43,  167,  185,   43,   43,   43,  174,   43,
			  189,   43,  186,  167,  201,  202,  187,  231,  167,  177,
			  415,  203,  414,  190,  413,  208,  167,  204,  192,  167,
			  167,  178,  188,  412,  179,  167,   50,   43,   43,  167,
			   43,   43,   44,   45,   46,  180,   48,   49,   43,  181,
			   43,  167,   43,  212,  210,   43,   43,   43,  167,   43,
			  211,   43,  167,  213,  214,  216,  217,  218,  167,  215,
			  221,  167,  167,  219,  167,  220,  222,  223,  167,  234,
			  167,  167,  411,  410,  167,  167,   50,   43,   43,  167,

			   43,   51,   52,   53,   54,  167,   56,   57,   51,  224,
			   51,  409,  167,   51,  225,   51,   51,   51,   51,   51,
			   51,   51,  167,  167,  226,  227,  228,  229,  230,  232,
			  167,  338,  311,  167,  167,  167,  167,  339,  235,  408,
			  407,  406,  405,  167,  312,  313,   58,   51,   51,   51,
			   52,   53,   54,  404,   56,   57,   51,  403,   51,  402,
			  401,   51,  167,   51,   51,   51,   51,   51,   51,   51,
			  321,  400,  399,  137,  398,  397,  396,  395,  322,  137,
			  137,  137,  137,  394,  137,  393,  323,  392,  391,  390,
			  389,  388,  387,  386,   58,   51,   51,   59,   60,   61,

			   62,  385,   64,   65,   59,  384,   59,  383,  382,   66,
			  381,   59,   67,   59,   68,   59,   59,   59,  141,  380,
			  379,  378,  377,  141,  376,  141,  375,  374,  373,  141,
			  372,  371,  141,  370,  369,  368,  367,  366,  365,  364,
			  363,  362,   59,   59,   59,   59,   60,   61,   62,  361,
			   64,   65,   59,  360,   59,  359,  358,   66,  357,   59,
			   67,   59,   68,   59,   59,   59,  145,  356,  355,  354,
			  353,  145,  145,  145,  352,  351,  350,  145,  349,  348,
			  145,  347,  346,  345,  344,  343,  342,  341,  340,  337,
			   59,   59,   59,   78,   84,   85,   86,   78,   87,   88,

			   78,   89,   90,   91,   78,   78,   92,   93,   94,   78,
			   78,   78,   78,   78,   95,   96,   97,   98,   99,  100,
			  101,   96,   96,  102,   96,   96,  103,  104,  105,  106,
			   96,   96,  107,  108,  109,   96,  110,   96,   78,   78,
			   78,  111,   78,   26,   26,   26,   26,   26,   26,   26,
			   26,   26,   26,   26,   26,   26,   26,   26,   26,   26,
			   39,   39,   39,   39,   39,   39,   39,   39,   39,   39,
			   39,   39,   39,   39,   39,   39,   39,   47,   47,   47,
			   47,   47,   47,   47,   47,   47,   47,   47,   47,   47,
			   47,   47,   47,   47,   55,   55,   55,   55,   55,   55,

			   55,   55,   55,   55,   55,   55,   55,   55,   55,   55,
			   55,   63,   63,   63,   63,   63,   63,   63,   63,   63,
			   63,   63,   63,   63,   63,   63,   63,   63,   69,   69,
			   69,   69,   69,   69,   69,   69,   69,   69,   69,   69,
			   69,   69,   69,   69,   69,   73,   73,   73,   73,   73,
			   73,   73,   73,   73,   73,   73,   73,   73,   73,   73,
			   73,   73,   78,   78,   78,   78,   78,   78,   78,   78,
			   78,   78,   78,   78,   78,   78,   78,   78,   78,   79,
			   79,   79,   79,   79,   79,   79,   79,   79,   79,   79,
			   79,   79,   79,   79,   79,   79,  114,  114,  114,  114,

			  114,  114,  114,  114,  114,  114,  114,  114,  114,  114,
			  130,  336,  130,  130,  130,  130,  130,  130,  130,  130,
			  130,  130,  130,  130,  130,  130,  130,  146,  335,  334,
			  333,  332,  146,  146,  146,  331,  330,  329,  146,  328,
			  327,  146,  147,  147,  147,  147,  326,  325,  147,  147,
			  147,  147,  147,  147,  147,  147,  147,  147,  147,  150,
			  150,  150,  150,  150,  150,  150,  150,  150,  150,  150,
			  150,  150,  150,  150,  324,  150,  153,  153,  153,  153,
			  153,  153,  153,  153,  153,  153,  153,  153,  153,  153,
			  153,  153,  153,  155,  155,  155,  320,  155,  155,  155,

			  155,  155,  155,  155,  155,  155,  155,  155,  155,  155,
			  158,  158,  158,  158,  158,  158,  158,  158,  158,  158,
			  158,  158,  158,  158,  158,  158,  158,  319,  318,  317,
			  316,  315,  314,  310,  309,  308,  307,  306,  305,  304,
			  303,  302,  301,  300,  299,  298,  297,  296,  295,  294,
			  293,  292,  291,  290,  289,  288,  287,  286,  285,  284,
			  283,  282,  281,  280,  279,  278,  277,  276,  275,  274,
			  273,  272,  271,  270,  269,  268,  267,  266,  265,  264,
			  263,  262,  261,  260,  259,  258,  257,  256,  255,  254,
			  253,  252,  251,  250,  249,  248,  247,  246,  245,  244,

			  243,  242,  241,  240,  239,  238,  237,  236,  167,  167,
			  163,  161,  161,  160,  156,  156,  151,  151,  146,  143,
			  143,  142,  139,  139,  138,  135,  135,  134,  132,  132,
			  131,  206,  205,  200,  199,  198,  197,  196,  195,  194,
			  193,  115,  112,  167,  163,  163,  163,  162,  161,  160,
			  157,  156,  152,  151,  146,  144,  143,  142,  140,  139,
			  138,  136,  135,  134,  133,  132,  131,  129,  126,  125,
			  122,  121,  120,  119,  116,  115,  113,  112,  416,   21,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416,

			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    3,    3,    3,    4,    4,
			    4,   17,   17,    0,   17,    1,   11,   11,   12,   12,
			   72,   72,   76,    1,    1,    1,  439,    1,   18,   18,
			    1,   18,   34,    1,    1,   29,   34,   13,   13,    1,
			    1,    1,   14,   14,    1,   37,   83,   29,   37,   83,
			    1,    2,    2,    2,    2,   17,   11,   95,   12,  189,
			  109,   97,   95,  101,   99,    2,  189,   76,  109,   95,
			   98,  105,   18,    2,    2,    2,   97,    2,  101,   99,
			    2,   13,   13,    2,    2,   97,   14,   14,   99,    2,
			    2,    2,  166,   98,    2,  438,  105,  437,  104,  106,

			    2,    5,    5,    5,    5,  100,    5,    5,    5,  102,
			    5,  104,    5,  166,  106,    5,    5,    5,  100,    5,
			  108,    5,  107,  106,  125,  125,  107,  187,  100,  102,
			  414,  126,  413,  108,  412,  165,  102,  126,  110,  187,
			  108,  103,  107,  411,  103,  165,    5,    5,    5,  107,
			    5,    6,    6,    6,    6,  103,    6,    6,    6,  103,
			    6,  110,    6,  170,  168,    6,    6,    6,  103,    6,
			  169,    6,  168,  171,  172,  174,  175,  176,  169,  173,
			  178,  171,  172,  177,  175,  177,  178,  179,  170,  190,
			  178,  176,  410,  409,  174,  179,    6,    6,    6,  177,

			    6,    7,    7,    7,    7,  173,    7,    7,    7,  180,
			    7,  407,  190,    7,  181,    7,    7,    7,    7,    7,
			    7,    7,  181,  180,  182,  183,  184,  185,  186,  188,
			  182,  323,  297,  183,  184,  185,  186,  323,  192,  406,
			  403,  402,  400,  188,  297,  297,    7,    7,    7,    8,
			    8,    8,    8,  399,    8,    8,    8,  398,    8,  397,
			  396,    8,  192,    8,    8,    8,    8,    8,    8,    8,
			  306,  395,  393,  428,  392,  391,  390,  389,  306,  428,
			  428,  428,  428,  388,  428,  387,  306,  386,  384,  383,
			  382,  380,  378,  377,    8,    8,    8,    9,    9,    9,

			    9,  376,    9,    9,    9,  375,    9,  374,  373,    9,
			  372,    9,    9,    9,    9,    9,    9,    9,  429,  371,
			  369,  368,  366,  429,  365,  429,  364,  363,  362,  429,
			  360,  359,  429,  357,  356,  355,  354,  353,  352,  351,
			  350,  349,    9,    9,    9,   10,   10,   10,   10,  347,
			   10,   10,   10,  346,   10,  345,  344,   10,  343,   10,
			   10,   10,   10,   10,   10,   10,  430,  341,  340,  339,
			  338,  430,  430,  430,  337,  336,  334,  430,  333,  332,
			  430,  331,  330,  329,  328,  327,  326,  325,  324,  322,
			   10,   10,   10,   19,   19,   19,   19,   19,   19,   19,

			   19,   19,   19,   19,   19,   19,   19,   19,   19,   19,
			   19,   19,   19,   19,   19,   19,   19,   19,   19,   19,
			   19,   19,   19,   19,   19,   19,   19,   19,   19,   19,
			   19,   19,   19,   19,   19,   19,   19,   19,   19,   19,
			   19,   19,   19,  417,  417,  417,  417,  417,  417,  417,
			  417,  417,  417,  417,  417,  417,  417,  417,  417,  417,
			  418,  418,  418,  418,  418,  418,  418,  418,  418,  418,
			  418,  418,  418,  418,  418,  418,  418,  419,  419,  419,
			  419,  419,  419,  419,  419,  419,  419,  419,  419,  419,
			  419,  419,  419,  419,  420,  420,  420,  420,  420,  420,

			  420,  420,  420,  420,  420,  420,  420,  420,  420,  420,
			  420,  421,  421,  421,  421,  421,  421,  421,  421,  421,
			  421,  421,  421,  421,  421,  421,  421,  421,  422,  422,
			  422,  422,  422,  422,  422,  422,  422,  422,  422,  422,
			  422,  422,  422,  422,  422,  423,  423,  423,  423,  423,
			  423,  423,  423,  423,  423,  423,  423,  423,  423,  423,
			  423,  423,  424,  424,  424,  424,  424,  424,  424,  424,
			  424,  424,  424,  424,  424,  424,  424,  424,  424,  425,
			  425,  425,  425,  425,  425,  425,  425,  425,  425,  425,
			  425,  425,  425,  425,  425,  425,  426,  426,  426,  426,

			  426,  426,  426,  426,  426,  426,  426,  426,  426,  426,
			  427,  321,  427,  427,  427,  427,  427,  427,  427,  427,
			  427,  427,  427,  427,  427,  427,  427,  431,  320,  317,
			  316,  315,  431,  431,  431,  314,  313,  312,  431,  311,
			  310,  431,  432,  432,  432,  432,  309,  308,  432,  432,
			  432,  432,  432,  432,  432,  432,  432,  432,  432,  433,
			  433,  433,  433,  433,  433,  433,  433,  433,  433,  433,
			  433,  433,  433,  433,  307,  433,  434,  434,  434,  434,
			  434,  434,  434,  434,  434,  434,  434,  434,  434,  434,
			  434,  434,  434,  435,  435,  435,  305,  435,  435,  435,

			  435,  435,  435,  435,  435,  435,  435,  435,  435,  435,
			  436,  436,  436,  436,  436,  436,  436,  436,  436,  436,
			  436,  436,  436,  436,  436,  436,  436,  303,  302,  301,
			  300,  299,  298,  296,  295,  294,  293,  292,  291,  290,
			  289,  287,  284,  283,  282,  280,  279,  278,  277,  276,
			  275,  274,  273,  272,  271,  270,  269,  268,  267,  266,
			  265,  264,  263,  262,  261,  260,  259,  258,  257,  256,
			  255,  254,  253,  252,  251,  250,  249,  248,  247,  246,
			  245,  244,  243,  242,  241,  240,  239,  236,  235,  234,
			  233,  232,  230,  224,  216,  206,  205,  204,  203,  202,

			  201,  200,  199,  198,  197,  196,  195,  194,  191,  164,
			  163,  162,  161,  160,  157,  156,  152,  151,  145,  144,
			  143,  142,  140,  139,  138,  136,  135,  134,  133,  132,
			  131,  129,  128,  124,  123,  122,  121,  120,  119,  118,
			  116,  115,  112,   96,   92,   91,   89,   86,   85,   84,
			   81,   80,   75,   74,   63,   62,   61,   60,   54,   53,
			   52,   46,   45,   44,   42,   41,   40,   38,   36,   35,
			   33,   32,   31,   30,   28,   27,   25,   23,   21,  416,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416,

			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,   50,    3,    6,  100,  150,  200,  248,  296,
			  344,    9,   11,   34,   39,    0,    0,    8,   25,  392,
			    0,  878,  879,  875,  879,  873,    0,  873,  850,   11,
			  851,  833,  844,  848,    6,  843,  842,    9,  823,    0,
			  864,  863,  861,  879,  861,  860,  858,    0,  879,  879,
			  879,  879,  858,  857,  855,    0,  879,  879,  879,  879,
			  855,  854,  852,  841,  879,  879,    0,  879,  879,    0,
			  879,  879,   13,    0,  851,  849,   19,  879,  879,    0,
			  849,  847,  879,   43,  847,  846,  844,  879,  879,  832,
			  879,  831,  830,  879,  879,   20,  794,   36,   44,   39,

			   79,   29,   87,  119,   62,   47,   74,  100,   91,   19,
			  112,    0,  840,  879,    0,  839,  816,    0,  804,  797,
			  801,  825,  795,  794,  799,   84,   96,    0,  810,  787,
			    0,  828,  827,  826,  825,  824,  823,    0,  822,  821,
			  820,    0,  819,  818,  817,  805,    0,    0,  879,  879,
			    0,  815,  814,    0,  879,    0,  813,  812,    0,  879,
			  811,  810,  809,  796,  760,   96,   64,    0,  123,  129,
			  139,  132,  133,  156,  145,  135,  142,  150,  141,  146,
			  174,  173,  181,  184,  185,  186,  187,   90,  194,   17,
			  163,  759,  213,    0,  766,  780,  771,  770,  762,  762,

			  775,  774,  757,  773,  786,  761,  784,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,  769,    0,    0,    0,
			    0,    0,    0,    0,  768,    0,    0,    0,    0,    0,
			  750,    0,  766,  751,  749,  753,  761,    0,    0,  750,
			  774,  762,  772,  747,  742,  754,  755,  738,  755,  754,
			  753,  735,  751,  732,  746,  744,  734,  743,  733,  738,
			  722,  723,  728,  723,  725,  733,  717,  713,  712,  731,
			  710,  729,  731,  712,  710,  720,  713,  722,  721,  735,
			  734,    0,  708,  717,  701,    0,    0,  719,    0,  718,
			  694,  713,  726,  709,  710,  723,  694,  205,  695,  699,

			  691,  700,  683,  682,    0,  674,  245,  644,  617,  616,
			  600,  600,  611,  610,  613,  601,  619,  603,    0,    0,
			  583,  581,  363,  192,  362,  360,  361,  355,  348,  346,
			  347,  340,  353,  352,  341,    0,  335,  339,  348,  332,
			  343,  337,    0,  322,  322,  322,  328,  320,    0,  306,
			  299,  302,  310,  302,  310,  324,  308,  298,    0,  286,
			  304,    0,  304,  297,  290,  283,  282,    0,  281,  295,
			    0,  308,  271,  272,  283,  265,  272,  266,  262,    0,
			  250,    0,  265,  267,  258,    0,  261,  250,  247,  247,
			  235,  234,  235,  248,    0,  236,  234,  229,  246,  227,

			  214,    0,  205,  214,    0,    0,  204,  176,    0,  169,
			  156,  118,  104,   97,  102,    0,  879,  442,  459,  476,
			  493,  510,  527,  544,  561,  578,  593,  609,  270,  315,
			  363,  624,  641,  658,  675,  692,  709,   83,   81,   12, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  417,  417,  418,  418,  419,  419,  420,  420,  421,
			  421,  422,  422,  423,  423,  424,  424,  425,  425,  416,
			   19,  416,  416,  416,  416,  416,  426,  416,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  426,  427,
			  416,  416,  416,  416,  416,  416,  416,  428,  416,  416,
			  416,  416,  416,  416,  416,  429,  416,  416,  416,  416,
			  416,  416,  416,  430,  416,  416,  431,  416,  416,  432,
			  416,  416,  432,  433,  433,  433,  434,  416,  416,  435,
			  435,  435,  416,  436,  416,  416,  416,  416,  416,  416,
			  416,  416,  416,  416,  416,  437,  437,  437,  437,  437,

			  437,  437,  437,  437,  437,  437,  437,  437,  437,  437,
			  437,  438,  416,  416,  426,  416,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  426,  426,
			  427,  416,  416,  416,  416,  416,  416,  428,  416,  416,
			  416,  429,  416,  416,  416,  430,  431,  432,  416,  416,
			  433,  433,  433,  433,  416,  435,  435,  435,  435,  416,
			  416,  416,  416,  416,  439,  439,  439,  438,  439,  439,
			  439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
			  439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
			  439,  439,  439,  426,  426,  426,  426,  426,  426,  426,

			  426,  426,  426,  426,  426,  426,  426,  438,  438,  438,
			  438,  438,  438,  438,  438,  438,  438,  438,  438,  438,
			  438,  438,  438,  438,  438,  438,  438,  438,  438,  438,
			  438,  438,  438,  438,  438,  438,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  426,  438,
			  438,  438,  438,  438,  438,  438,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  438,  438,  438,
			  438,  438,  438,  438,  426,  426,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  438,  438,  438,  438,  438,
			  438,  438,  426,  426,  426,  426,  426,  426,  426,  426,

			  426,  426,  438,  438,  438,  438,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  438,  438,
			  438,  426,  426,  426,  426,  426,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  438,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,  426,  426,  426,  426,

			  426,  426,  426,  426,  426,  426,  426,  426,  426,  426,
			  426,  426,  426,  426,  426,  426,    0,  416,  416,  416,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416,
			  416,  416,  416,  416,  416,  416,  416,  416,  416,  416, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    4,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    2,    5,    6,    5,    5,    5,    5,    5,
			    7,    8,    5,    9,   10,   11,   12,   13,   14,   14,
			   14,   14,   14,   14,   14,   14,   14,   14,   15,   16,
			   17,   18,   19,   20,   21,   22,   23,   24,   25,   26,
			   27,   28,   29,   30,   31,   32,   33,   34,   35,   36,
			   37,   38,   39,   40,   41,   42,   43,   44,   38,   45,
			   38,   46,   47,   48,    5,   49,    5,   22,   23,   24,

			   25,   26,   27,   28,   29,   30,   31,   32,   33,   34,
			   35,   36,   37,   38,   39,   40,   41,   42,   43,   44,
			   38,   45,   38,    5,    5,    5,    5,   50,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,

			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    2,    2,    2,    3,    4,    5,    6,    3,
			    7,    3,    8,    9,   10,    1,    7,    7,   11,    7,
			   12,   13,   14,   14,   14,   14,   14,   14,   14,   14,
			   14,   14,   14,   14,   14,   14,   14,   14,   14,   14,
			   14,   14,   14,   14,   14,   14,    7,   15,   16,   14,
			   17, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,  120,  118,    1,   25,  118,   23,   24,   23,   23,
			   23,   23,   23,   23,   23,   23,   23,   23,   23,  113,
			  114,  116,  117,   33,   29,   31,   33,   32,   28,   26,
			   27,   41,   37,   39,   41,   40,   36,   34,   35,   51,
			   46,   48,   51,   49,   45,   44,   50,   42,   43,  104,
			  103,  102,  104,  108,  108,  108,  108,  106,  119,  112,
			  112,  112,  110,  112,   95,   99,  119,   94,   98,  119,
			   90,   92,   97,   91,   93,   88,   88,   88,   88,   88,

			   88,   88,   88,   88,   88,   88,   88,   88,   88,   88,
			   88,   89,    1,   25,   23,   24,   23,    3,   23,   23,
			   23,   23,   23,   23,   23,   23,   23,   20,   23,   23,
			  113,  114,  115,  116,   29,   30,   31,   32,   37,   38,
			   39,   40,   46,   47,   48,   49,   50,  104,  100,  101,
			  108,  107,  108,  105,  105,  112,  111,  112,  109,  109,
			   95,   96,   99,   97,   88,   88,   88,   89,   88,   88,
			   88,   88,   88,   88,   88,   88,   88,   88,   88,   88,
			   88,   88,   88,   88,   88,   88,   88,   88,   88,   88,
			   88,   79,   88,    2,   23,   23,   23,   23,   23,   23,

			   23,   23,   23,   23,   23,   23,   23,   88,   69,   73,
			   83,   82,   77,   81,   80,   67,   57,   78,   66,   72,
			   71,   68,   70,   85,   53,   84,   76,   75,   87,   86,
			   58,   74,   52,   56,   54,   55,   23,    8,    9,   23,
			   23,   23,   23,   23,   23,   23,   23,   23,   23,   89,
			   89,   89,   89,   89,   89,   89,   23,   23,   23,   23,
			   23,   23,   23,   23,   23,   23,   23,   89,   89,   89,
			   89,   89,   89,   89,   23,   23,   23,   23,   23,   23,
			   23,   18,   23,   23,   23,   64,   60,   89,   59,   89,
			   89,   89,   23,   23,   23,   23,   23,   23,   23,   23,

			   23,   23,   89,   89,   61,   89,   23,   23,   23,   23,
			   23,   23,   23,   23,   23,   23,   23,   23,   65,   63,
			   89,   23,   23,   23,   23,   23,   23,   23,   23,   23,
			   23,   23,   23,   23,   23,   62,   23,   23,   23,   23,
			   23,   23,   12,   23,   23,   23,   23,   23,   19,   23,
			   23,   23,   23,   23,   23,   23,   23,   23,   14,   23,
			   23,   17,   23,   23,   23,   23,   23,    7,   23,   23,
			   13,   23,   23,   23,   23,   23,   23,   23,   23,   11,
			   23,   16,   23,   23,   23,    5,   23,   23,   23,   23,
			   23,   23,   23,   23,   15,   23,   23,   23,   23,   23,

			   23,   22,   23,   23,   10,   21,   23,   23,    4,   23,
			   23,   23,   23,   23,   23,    6,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 879
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 416
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 417
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

	yyNb_rules: INTEGER is 119
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 120
			-- End of buffer rule code

	yyLine_used: BOOLEAN is true
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
	UNSTRUCTURED_FIELD_BODY: INTEGER is 1
	STRUCTURED_FIELD_BODY: INTEGER is 2
	MIME_FIELD_BODY: INTEGER is 3
	PARAMETER: INTEGER is 4
	COMMENT: INTEGER is 5
	SC_DOMAIN_LITERAL: INTEGER is 6
	NEXT_WORD: INTEGER is 7
	SC_QUOTED_STRING: INTEGER is 8
	DATE: INTEGER is 9
			-- Start condition codes

feature -- User-defined features



feature {NONE} -- Initialization

	make is
		do
			precursor
			create encoded_word_scanner.make
		end


feature -- Last returned data


feature -- Input

	new_mime_request_buffer (a_stream: EPX_CHARACTER_INPUT_STREAM): EPX_MIME_BUFFER is
			-- New input buffer for `a_stream'.
		require
			stream_not_void: a_stream /= Void
			stream_open: a_stream.is_open_read
		do
			create Result.make (a_stream)
		ensure
			new_buffer_not_void: Result /= Void
		end


feature -- Condition setting

	expect_date is
		do
			set_start_condition (DATE)
		end

	reset_start_condition is
			-- Used in error recovery to return to start condition.
		do
			set_start_condition (INITIAL)
		end

	start_parameter is
		do
			to_condition := PARAMETER
			set_start_condition (PARAMETER)
		end


feature {NONE} -- State during parsing

	call_enable_keyword_after_space: BOOLEAN
			-- Flag to call `enable_keyword_after_space' when encountered an ATOM.

	expect_keyword: BOOLEAN
			-- Treat certain atoms specially.

	expect_keyword_after_space: BOOLEAN
			-- Treat certain atoms specially after a space, crlf in
			-- folded-line or comment has been ecountered.

	to_condition: INTEGER
			-- Used by ':' to switch to correct field body parser.

	nested_comment_count: INTEGER
			-- Keep track of nested comments.

-- 	last_integer: INTEGER_REF

-- 	last_string: STRING is
-- 		do
-- 			Result ?= last_value
-- 		ensure
-- 			last_string_returned: Result /= Void
-- 		end

-- 	set_last_integer (value: INTEGER) is
-- 			-- Set `last_integer' and make sure `last_value' is this integer.
-- 		do
-- 			create last_integer
-- 			last_integer.set_item (value)
-- 			last_value := last_integer
-- 		ensure
-- 			new_integer: last_integer /= old last_integer
-- 			value_set: last_integer.item = value
-- 			last_value_is_integer: last_value = last_integer
-- 		end

	prev_word_was_encoded: BOOLEAN
			-- Used to skip white space between encoded-words in an
			-- unstructured field.


feature {NONE} -- Implementation

	to_canonical_field_name (a_field_name: STRING): STRING is
			-- Turn `a_field_name' into a canonical field name. A
			-- canonical field name as the first character in uppercase
			-- and every character after a '-' as well. All other
			-- characters are lower case.
		require
			a_field_name_not_empty: a_field_name /= Void and then not a_field_name.is_empty
		local
			c,
			prev_c: CHARACTER
			i: INTEGER
		do
			create Result.make_from_string (a_field_name)
			prev_c := Result.item (1)
			Result.put (as_upper (prev_c), 1)
			from
				i := 2
			until
				i > Result.count
			loop
				c := Result.item (i)
				if prev_c = '-' then
					Result.put (as_upper (c), i)
				else
					Result.put (as_lower (c), i)
				end
				prev_c := c
				i := i + 1
			end
		end


feature {NONE} -- RFC 2047 encoded stuff handling

	encoded_word_scanner: EPX_MIME_ENCODED_WORD_SCANNER


invariant

	never_a_keyword_in_start_condition:
		start_condition = INITIAL implies
			(not expect_keyword and not expect_keyword_after_space)
	encoded_word_scanner_not_void: encoded_word_scanner /= Void

end
