%{
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


create

	make

%}

%option outfile="epx_mime_scanner.e"
%option nodefault
%option case-insensitive
%option line


%x UNSTRUCTURED_FIELD_BODY STRUCTURED_FIELD_BODY MIME_FIELD_BODY
%x PARAMETER
%x COMMENT SC_DOMAIN_LITERAL NEXT_WORD SC_QUOTED_STRING
%x DATE

---- definitions ----

CHAR  [\x00-\7f]
ALPHA [\101-\132]
DIGIT [0-9]
CTL   [\x00-\x1f\x7f]

%%
-------------------------------------------------------------------------------


-- White space
[ \t]+              -- Ignore white space

---- recognized fields ----

"Bcc"	               {
							last_token := FN_BCC
							to_condition := STRUCTURED_FIELD_BODY
							}
"Cc"	               {
							last_token := FN_CC
							to_condition := STRUCTURED_FIELD_BODY
							}
"Content-Disposition" {
							last_token := FN_CONTENT_DISPOSITION
							to_condition := MIME_FIELD_BODY
							}
"Content-Length"     {
							last_token := FN_CONTENT_LENGTH
							to_condition := MIME_FIELD_BODY
							}
"Content-Transfer-Encoding" {
							last_token := FN_CONTENT_TRANSFER_ENCODING
							to_condition := MIME_FIELD_BODY
							}
"Content-Type"       {
							last_token := FN_CONTENT_TYPE
							to_condition := MIME_FIELD_BODY
							}
"Date"               {
							last_token := FN_DATE
							to_condition := STRUCTURED_FIELD_BODY
							}
"From"               {
							last_token := FN_FROM
							to_condition := STRUCTURED_FIELD_BODY
							}
"If-Modified-Since"  {
							last_token := FN_IF_MODIFIED_SINCE
							to_condition := STRUCTURED_FIELD_BODY
							}
"Last-Modified"      {
							last_token := FN_LAST_MODIFIED
							to_condition := STRUCTURED_FIELD_BODY
							}
"Message-ID"         {
							last_token := FN_MESSAGE_ID
							to_condition := STRUCTURED_FIELD_BODY
							}
"MIME-Version"       {
							last_token := FN_VERSION
							-- I want to see two integers.
							-- tspecials from RFC 2045 include token, so I
							-- just get an atom if parsed according to that syntax.
							to_condition := STRUCTURED_FIELD_BODY
							}
-- Received contents is a big mess if you look at actual values
-- Treat as unstructured for now
-- "Received"           {
-- 							last_token := FN_RECEIVED
-- 							to_condition := STRUCTURED_FIELD_BODY
-- 							}
"Resent-From"        {
							last_token := FN_RESENT_FROM
							to_condition := STRUCTURED_FIELD_BODY
							}
"Resent-Reply-To"    {
							last_token := FN_RESENT_REPLY_TO
							to_condition := STRUCTURED_FIELD_BODY
							}
"Resent-Sender"      {
							last_token := FN_RESENT_SENDER
							to_condition := STRUCTURED_FIELD_BODY
							}
"Return-Path"        {
							last_token := FN_RETURN_PATH
							to_condition := STRUCTURED_FIELD_BODY
							}
"Sender"             {
							last_token := FN_SENDER
							to_condition := STRUCTURED_FIELD_BODY
							}
"Set-Cookie"         {
							last_token := FN_SET_COOKIE
							to_condition := MIME_FIELD_BODY
							}
"To"                 {
							last_token := FN_TO
							to_condition := STRUCTURED_FIELD_BODY
							}
"Transfer-Encoding"  {
							last_token := FN_TRANSFER_ENCODING
							to_condition := MIME_FIELD_BODY
							}
"WWW-Authenticate"   {
							last_token := FN_WWW_AUTHENTICATE
							to_condition := MIME_FIELD_BODY
							}


---- all other fields ----

-- this is the RFC822 field definition (ftext)
-- [\d33-\d57\d59-\d126]+ {
-- [^\x00-\x20\:\x7f-\xff]+ {

[\x21-\x39\x3b-\x7e]+ {
							last_token := FIELD_NAME
							last_string_value := to_canonical_field_name (text)
							to_condition := UNSTRUCTURED_FIELD_BODY
							}

":"[ \t]*            { -- include space, so it's already skipped
							create last_string_value.make (64)
							last_token := Colon_code
							if to_condition /= 0 then
								set_start_condition (to_condition)
							end
							}

\r?\n                {
							last_token := CRLF
							}


---- Structured field bodies as in RFC 2822 section 3.2.4 ----

--<STRUCTURED_FIELD_BODY>"%\"    { } -- quoted-pair TODO
<STRUCTURED_FIELD_BODY>"("    {
							set_start_condition (COMMENT)
							}
<STRUCTURED_FIELD_BODY>"["    {
							create last_string_value.make (32)
							set_start_condition (SC_DOMAIN_LITERAL)
							}
<STRUCTURED_FIELD_BODY>\" { --"
							create last_string_value.make (32)
							set_start_condition (SC_QUOTED_STRING)
							}
<STRUCTURED_FIELD_BODY>[ \t]+ -- White space, ignore
<STRUCTURED_FIELD_BODY>\r?\n[ \t]+ -- Folded-line white space, ignore
<STRUCTURED_FIELD_BODY>\r?\n  {
							set_start_condition (INITIAL)
							to_condition := 0
							last_token := CRLF
							}
<STRUCTURED_FIELD_BODY>[A-Za-z0-9!#$%&'*+\-/=?^_`{|}~]+ { --'
							last_token := MIME_ATOM
							if encoded_word_scanner.is_encoded_word (text) then
								last_string_value := encoded_word_scanner.decode_word (text)
							else
								last_string_value := text
							end
							}
<STRUCTURED_FIELD_BODY>. { -- pass rest of stuff as is, perhaps exclude 8-bit chars??
							last_token := text.item (1).code
							}


---- Structured field bodies as in RFC 2045 Appendix A ----
-- especially the definition of what is an atom is different

<MIME_FIELD_BODY>"(" {
							set_start_condition (COMMENT)
							}
<MIME_FIELD_BODY>"["    {
							create last_string_value.make (32)
							set_start_condition (SC_DOMAIN_LITERAL)
							}
<MIME_FIELD_BODY>\" { --"
							create last_string_value.make (32)
							set_start_condition (SC_QUOTED_STRING)
							}
<MIME_FIELD_BODY>[ \t]+ -- White space, ignore
<MIME_FIELD_BODY>\r?\n[ \t]+ -- Folded-line white space, ignore
<MIME_FIELD_BODY>\r?\n  {
							set_start_condition (INITIAL)
							to_condition := 0
							last_token := CRLF
							}
<MIME_FIELD_BODY>[^\x80-\xff\x00-\x20 ()<>@,;:\\"/\[\]?=]+ { --"
							last_token := MIME_ATOM
							if encoded_word_scanner.is_encoded_word (text) then
								last_string_value := encoded_word_scanner.decode_word (text)
							else
								last_string_value := text
							end
							}
<MIME_FIELD_BODY>. { -- just return every other character
							last_token := text.item (1).code
							}

<PARAMETER>";"       { last_token := Semicolon_code }
<PARAMETER>"="       { last_token := Equal_code }
<PARAMETER>"("       {
							to_condition := PARAMETER
							set_start_condition (COMMENT)
							}
<PARAMETER>\"        { --"
							create last_string_value.make (32)
							to_condition := PARAMETER
							set_start_condition (SC_QUOTED_STRING)
							}
<PARAMETER>[ \t]+    -- White space, ignore
<PARAMETER>\r?\n[ \t]+ -- Folded-line white space, ignore
<PARAMETER>\r?\n     {
							set_start_condition (INITIAL)
							to_condition := 0
							last_token := CRLF
							}
<PARAMETER>[^\x80-\xff\x00-\x20 ()<>@,;:\\"/\[\]?=]+ { --"
							last_string_value := text
							last_token := MIME_ATOM
							}
-- According to RFC2616, separators should not appear in parameter attributes
-- and values. But the Set-Cookie has them, espcially the path parameter.
-- So we allow '/' to be present in parameter values
<PARAMETER>[^\x80-\xff\x00-\x20 ()<>@,;:\\"\[\]?=]+ { --"
							last_string_value := text
							last_token := MIME_VALUE_ATOM
							}
<PARAMETER>.         { -- ignore all other stuff??
							last_token := text.item (1).code
							}


---- dates ----
-- According to RFC 2822 comments are not allowed in date (Appendix B.14).
-- We still allow them anywhere.

<DATE>"Sun"         last_token := KW_SUN
<DATE>"Mon"         last_token := KW_MON
<DATE>"Tue"         last_token := KW_TUE
<DATE>"Wed"         last_token := KW_WED
<DATE>"Thu"         last_token := KW_THU
<DATE>"Fri"         last_token := KW_FRI
<DATE>"Sat"         last_token := KW_SAT
<DATE>"Sunday"      last_token := KW_SUN
<DATE>"Monday"      last_token := KW_MON
<DATE>"Tuesday"     last_token := KW_TUE
<DATE>"Wednesday"   last_token := KW_WED
<DATE>"Thursday"    last_token := KW_THU
<DATE>"Friday"      last_token := KW_FRI
<DATE>"Saturday"    last_token := KW_SAT
<DATE>"Jan"         last_token := MONTH; last_integer_value := 1
<DATE>"Feb"         last_token := MONTH; last_integer_value := 2
<DATE>"Mar"         last_token := MONTH; last_integer_value := 3
<DATE>"Apr"         last_token := MONTH; last_integer_value := 4
<DATE>"May"         last_token := MONTH; last_integer_value := 5
<DATE>"Jun"         last_token := MONTH; last_integer_value := 6
<DATE>"Jul"         last_token := MONTH; last_integer_value := 7
<DATE>"Aug"         last_token := MONTH; last_integer_value := 8
<DATE>"Sep"         last_token := MONTH; last_integer_value := 9
<DATE>"Oct"         last_token := MONTH; last_integer_value := 10
<DATE>"Nov"         last_token := MONTH; last_integer_value := 11
<DATE>"Dec"         last_token := MONTH; last_integer_value := 12
<DATE>"GMT"         |
<DATE>"UT"          last_token := NUMBER; last_integer_value := 0
<DATE>"EST"         last_token := NUMBER; last_integer_value := -5
<DATE>"EDT"         last_token := NUMBER; last_integer_value := -4
<DATE>"CST"         last_token := NUMBER; last_integer_value := -6
<DATE>"CDT"         last_token := NUMBER; last_integer_value := -5
<DATE>"MST"         last_token := NUMBER; last_integer_value := -7
<DATE>"MDT"         last_token := NUMBER; last_integer_value := -6
<DATE>"PST"         last_token := NUMBER; last_integer_value := -8
<DATE>"PDT"         last_token := NUMBER; last_integer_value := -7
<DATE>[A-Z][A-Z]?[A-Z]? { -- parse these time zones, but ignore them
						  last_token := NUMBER; last_string_value := text; last_integer_value := 0
						  }
<DATE>[A-Za-z_]+    { -- finally, parse the shit spammers spew out like time zone XXXXXXXXXXXX
						  last_token := NUMBER; last_string_value := text; last_integer_value := 0
						  }
<DATE>","           last_token := Comma_code
<DATE>":"           last_token := Colon_code
<DATE>"-"           last_token := Minus_code
<DATE>";"           {
						  last_token := Semicolon_code
						  set_start_condition (STRUCTURED_FIELD_BODY)
						  }
<DATE>\"            { -- " we use this to recognize some s**t
						  last_token := Double_quote_code
						  }
<DATE>[ \t]+        |
<DATE>\r?\n[ \t]+   -- (Folded-line) white space, ignore
<DATE>[\+\-]?[0-9]+ {
						  last_integer_value := text.to_integer
						  last_token := NUMBER
						  }
<DATE>"("           {
						  to_condition := DATE
						  set_start_condition (COMMENT)
						  }
<DATE>\r?\n         {
						  set_start_condition (INITIAL)
						  to_condition := 0
						  last_token := CRLF
						  }


---- comments, possibly nested ----

<COMMENT>\\\(        { }
<COMMENT>\\\)        { }
<COMMENT>")"         {
							if nested_comment_count = 0 then
								set_start_condition (to_condition)
							else
								nested_comment_count := nested_comment_count - 1
							end
							}
<COMMENT>"("         { nested_comment_count := nested_comment_count + 1 }
<COMMENT>[^()]+      { }


---- domain literal ----
-- what to do when forbidden [ or CR is parsed? Now it's just appended.

<SC_DOMAIN_LITERAL>\\. { last_string_value.append_character (text.item (2)) }
<SC_DOMAIN_LITERAL>"]" {
							set_start_condition (to_condition)
							last_token := DOMAIN_LITERAL
							}
<SC_DOMAIN_LITERAL>\r?\n[ \t]+ {
							last_string_value.append_character (' ')
							}
<SC_DOMAIN_LITERAL>[^]]+ { last_string_value.append_string (text) }

---- quoted-string ----
-- what to do when forbidden [ or CR is parsed? Now it's just appended.

<SC_QUOTED_STRING>\\. { last_string_value.append_character (text.item (2)) }
<SC_QUOTED_STRING>\" { --"
							set_start_condition (to_condition)
							last_token := QUOTED_STRING
							}
<SC_QUOTED_STRING>\r?\n[ \t]+ {
							last_string_value.append_character (' ')
							}
<SC_QUOTED_STRING>[^"]+ { --"
							last_string_value.append_string (text)
							}


---- Unstructured field bodies (RFC 2822 3.2.6) ----

<UNSTRUCTURED_FIELD_BODY>[^\r\n \t]+ {
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
							}
<UNSTRUCTURED_FIELD_BODY>[ \t]+ last_string_value.append_string (text)
<UNSTRUCTURED_FIELD_BODY>\r?\n[ \t]+ { -- Folded line
							last_string_value.append_character (' ')
							}
<UNSTRUCTURED_FIELD_BODY>\r?\n    {
							if last_string_value.is_empty then
								last_token := CRLF
							else
								less (0)
								last_token := FIELD_BODY
							end
							to_condition := 0
							set_start_condition (INITIAL)
							prev_word_was_encoded := False
							}
<UNSTRUCTURED_FIELD_BODY>\r       -- ignore lone CR's


-------------------------------------------------------------------------------

<<EOF>>             { terminate }
.                   -- ignore all other charcters, i.e. ascii unprintables and high ascii

-------------------------------------------------------------------------------

%%

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
