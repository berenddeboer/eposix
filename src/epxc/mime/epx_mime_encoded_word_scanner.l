%{
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

%}

%option outfile="epx_mime_encoded_word_scanner.e"
%option case-insensitive
%option line


%x OTHER_ENCODING
%x B_ENCODING Q_ENCODING

---- definitions ----

HEXDIGIT [0-9A-Fa-f]
BASE64CHAR [A-Za-z0-9+/]

%%
-------------------------------------------------------------------------------

"=?"                 { last_token := START_ENCODED_WORD }
[^\x00-\x1f? ]+      { last_value := text; last_token := ATOM }
"?"                  { last_token := Question_mark_code }

<OTHER_ENCODING>"?=" { last_token := STOP_ENCODED_WORD }
<OTHER_ENCODING>[^\x00-\x1f? \t]+ {
							last_value := text
							last_token := ENCODED_TEXT
							}
<OTHER_ENCODING>.    { set_start_condition (INITIAL) }

<B_ENCODING>"?="     {
							less (0)
							last_token := ENCODED_TEXT
							set_start_condition (INITIAL)
							}
<B_ENCODING>{BASE64CHAR}{BASE64CHAR}{BASE64CHAR}{BASE64CHAR} {
							decode_24_bits (text.item (1), text.item (2), text.item (3), text.item (4))

							last_value.append_string (decoded_characters)
							}
<B_ENCODING>{BASE64CHAR}{BASE64CHAR}{BASE64CHAR}"=" {
							decode_24_bits (text.item (1), text.item (2), text.item (3), text.item (4))

							last_value.append_character (decoded_characters.item (1))
							last_value.append_character (decoded_characters.item (2))
							}
<B_ENCODING>{BASE64CHAR}{BASE64CHAR}"==" {
							decode_24_bits (text.item (1), text.item (2), text.item (3), text.item (4))

							last_value.append_character (decoded_characters.item (1))
							}
<B_ENCODING>.        -- ignore any other character

<Q_ENCODING>"?="     {
							less (0)
							last_token := ENCODED_TEXT
							set_start_condition (INITIAL)
							}
<Q_ENCODING>"="{HEXDIGIT}{HEXDIGIT} {
							last_value.append_character (from_hex_characters (text.item (2), text.item (3)))
							}
<Q_ENCODING>[ \t\n\r] { last_value.append_character (text.item (1)) }
<Q_ENCODING>[\x00-\x1f\x80-\xff] -- Invalid control character, skip
<Q_ENCODING>.        { last_value.append_character (text.item (1)) }


-------------------------------------------------------------------------------

<<EOF>>             { terminate }

-------------------------------------------------------------------------------

%%

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
