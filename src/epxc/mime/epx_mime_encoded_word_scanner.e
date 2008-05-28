indexing

	description:
		"Scanner for RFC 2047 encoded-word."

	standards:
		"Based on RFC 2047."

	known_bugs:
		"1. B encoding not decoded."

	author: "Berend de Boer"
	date: "$Date: $"
	revision: "$Revision: $"


class

	EPX_MIME_ENCODED_WORD_SCANNER


inherit

	YY_COMPRESSED_SCANNER_SKELETON

	UT_CHARACTER_CODES
		export {NONE} all end

	EPX_BASE64_ENCODING
		export
			{NONE} all
		end

	EPX_BASE64_ENCODING
		export
			{NONE} all
		end

	EPX_OCTET_ENCODING
		export
			{NONE} all
		end


create

	make


feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= Q_ENCODING)
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
if yy_act <= 9 then
if yy_act <= 5 then
if yy_act <= 3 then
if yy_act <= 2 then
if yy_act = 1 then
	yy_column := yy_column + 2
--|#line 68 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 68")
end
 last_token := START_ENCODED_WORD 
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 69 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 69")
end
 last_value := text; last_token := ATOM 
end
else
	yy_column := yy_column + 1
--|#line 70 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 70")
end
 last_token := Question_mark_code 
end
else
if yy_act = 4 then
	yy_column := yy_column + 2
--|#line 72 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 72")
end
 last_token := STOP_ENCODED_WORD 
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 73 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 73")
end

							last_value := text
							last_token := ENCODED_TEXT
							
end
end
else
if yy_act <= 7 then
if yy_act = 6 then
	yy_column := yy_column + 1
--|#line 77 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 77")
end
 set_start_condition (INITIAL) 
else
	yy_column := yy_column + 2
--|#line 79 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 79")
end

							less (0)
							last_token := ENCODED_TEXT
							set_start_condition (INITIAL)
							
end
else
if yy_act = 8 then
	yy_column := yy_column + 4
--|#line 84 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 84")
end

							decode_24_bits (text.item (1), text.item (2), text.item (3), text.item (4))

							last_value.append_string (decoded_characters)
							
else
	yy_column := yy_column + 4
--|#line 89 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 89")
end

							decode_24_bits (text.item (1), text.item (2), text.item (3), text.item (4))

							last_value.append_character (decoded_characters.item (1))
							last_value.append_character (decoded_characters.item (2))
							
end
end
end
else
if yy_act <= 13 then
if yy_act <= 11 then
if yy_act = 10 then
	yy_column := yy_column + 4
--|#line 95 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 95")
end

							decode_24_bits (text.item (1), text.item (2), text.item (3), text.item (4))

							last_value.append_character (decoded_characters.item (1))
							
else
	yy_column := yy_column + 1
--|#line 100 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 100")
end
-- ignore any other character
end
else
if yy_act = 12 then
	yy_column := yy_column + 2
--|#line 102 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 102")
end

							less (0)
							last_token := ENCODED_TEXT
							set_start_condition (INITIAL)
							
else
	yy_column := yy_column + 3
--|#line 107 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 107")
end

							last_value.append_character (from_hex_characters (text.item (2), text.item (3)))
							
end
end
else
if yy_act <= 15 then
if yy_act = 14 then
yy_set_line_column
--|#line 110 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 110")
end
 last_value.append_character (text.item (1)) 
else
yy_set_line_column
--|#line 111 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 111")
end
-- Invalid control character, skip
end
else
if yy_act = 16 then
	yy_column := yy_column + 1
--|#line 112 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 112")
end
 last_value.append_character (text.item (1)) 
else
yy_set_line_column
--|#line 0 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 0")
end
default_action
end
end
end
end
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			inspect yy_sc
when 0, 1, 2, 3 then
--|#line 0 "epx_mime_encoded_word_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'epx_mime_encoded_word_scanner.l' at line 0")
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
			    0,   10,   10,   10,   10,   11,   11,   11,   12,   13,
			   11,   11,   14,   14,   10,   14,   15,   15,   15,   15,
			   16,   15,   15,   10,   31,   40,   18,   18,   39,   19,
			   10,   37,   36,   18,   18,   34,   19,   20,   21,   22,
			   23,   24,   24,   24,   25,   26,   20,   20,   17,   17,
			   17,   17,   27,   27,   27,   29,   29,   29,   35,   35,
			   38,   38,   33,   32,   30,   28,   41,    9,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    3,    3,    3,    3,    3,    3,    3,    3,
			    3,    3,    3,    5,   45,   36,    5,    5,   35,    5,
			    6,   33,   31,    6,    6,   26,    6,    7,    7,    7,
			    7,    7,    7,    7,    7,    7,    7,    7,   42,   42,
			   42,   42,   43,   43,   43,   44,   44,   44,   46,   46,
			   47,   47,   25,   19,   16,   12,    9,   41,   41,   41,
			   41,   41,   41,   41,   41,   41,   41,   41,   41, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   11,    0,   20,   27,   36,    0,   66,
			   67,    0,   56,   67,   67,    0,   56,   67,    0,   55,
			   67,   67,   67,   67,   67,   55,   27,    0,   67,    0,
			   67,   24,   67,   24,   67,   20,   17,   67,   67,   67,
			   67,   67,   47,   50,   53,   21,   55,   57, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,   41,    1,   41,    3,   42,   42,   41,    7,   41,
			   41,   43,   43,   41,   41,   44,   41,   41,   45,   41,
			   41,   41,   41,   41,   41,   41,   41,   43,   41,   44,
			   41,   46,   41,   41,   41,   47,   41,   41,   41,   41,
			   41,    0,   41,   41,   41,   41,   41,   41, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    2,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    4,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    6,    5,    5,    5,    6,    7,    7,
			    7,    7,    7,    7,    7,    7,    7,    7,    5,    5,
			    5,    8,    5,    9,    5,    7,    7,    7,    7,    7,
			    7,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    5,    5,    5,    5,    5,    5,    7,    7,    7,

			    7,    7,    7,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    5,    5,    5,    5,    5,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   11,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,

			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,    1, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    2,    3,    3,    4,    1,
			    2,    2, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,    0,    0,    0,    0,   18,
			   17,    2,    2,    3,    6,    5,    6,   11,   11,   11,
			   15,   14,   14,   14,   16,   16,   16,    2,    1,    5,
			    4,    0,    7,    0,   12,    0,    0,   13,    8,    9,
			   10,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 67
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 41
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 42
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

	yyNb_rules: INTEGER is 17
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 18
			-- End of buffer rule code

	yyLine_used: BOOLEAN is true
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
	OTHER_ENCODING: INTEGER is 1
	B_ENCODING: INTEGER is 2
	Q_ENCODING: INTEGER is 3
			-- Start condition codes

feature -- User-defined features



feature -- Last returned data

	last_value: STRING


feature -- RFC 2047 decoding

	character_set: STRING
			-- Character set read by `decode_word'.

	decode_word (a_word: STRING): STRING is
			-- Decode `a_word' according to RFC 2047.
			-- Returns `a_word' on error.
		require
			is_encoded: is_encoded_word (a_word)
		local
			c: CHARACTER
		do
			debug ("mime")
				print ("Decoding: ")
				print (a_word)
				print ("%N")
			end
			set_input_buffer (new_string_buffer (a_word))
			set_start_condition (INITIAL)
			read_token
			if last_token = START_ENCODED_WORD then
				read_token
				if last_token = ATOM then
					character_set := last_value
					read_token
					if last_token = Question_mark_code then
						read_token
						if last_token = ATOM then
							encoding := last_value
							read_token
							if last_token = Question_mark_code then
								if encoding.count = 1 then
									c := encoding.item (1)
									if c = 'Q' or else c = 'q' then
										set_start_condition (Q_ENCODING)
									elseif c = 'B' or else c = 'b' then
										set_start_condition (B_ENCODING)
									else
										set_start_condition (OTHER_ENCODING)
									end
								else
									set_start_condition (OTHER_ENCODING)
								end
								create last_value.make (64)
								read_token
								if last_token = ENCODED_TEXT then
									Result := last_value
								end
							end
						end
					end
				end
			end
			if Result = Void then
				Result := a_word
			end
			debug ("mime")
				print ("Decoded to: ")
				print (Result)
				print ("%N")
			end
		ensure
			decoded_word_not_void: Result /= Void
		end

	encoding: STRING
			-- Encoding read by `decode_word'.

	is_encoded_word (a_word: STRING): BOOLEAN is
			-- Does `a_word' start with the encoded word special characters?
		require
			a_word_not_void: a_word /= Void
		do
			Result :=
				a_word.count >= 8 and then
				a_word.item (1) = '=' and then
				a_word.item (2) = '?'
		end


feature -- Token codes

	ATOM: INTEGER is 258
	START_ENCODED_WORD: INTEGER is 259
	STOP_ENCODED_WORD: INTEGER is 260
	ENCODED_TEXT: INTEGER is 261

end
