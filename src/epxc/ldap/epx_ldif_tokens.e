indexing

	description: "Parser token codes"
	generator: "geyacc version 3.3"

class EPX_LDIF_TOKENS

inherit

	YY_PARSER_TOKENS

feature -- Last values

	last_any_value: ANY
	last_string_value: STRING
	last_integer_value: INTEGER

feature -- Access

	token_name (a_token: INTEGER): STRING is
			-- Name of token `a_token'
		do
			inspect a_token
			when 0 then
				Result := "EOF token"
			when -1 then
				Result := "Error token"
			when CHANGETYPE_COLON then
				Result := "CHANGETYPE_COLON"
			when CONTROL_COLON then
				Result := "CONTROL_COLON"
			when DN then
				Result := "DN"
			when VERSION_COLON then
				Result := "VERSION_COLON"
			when ATTRIBUTE_TYPE then
				Result := "ATTRIBUTE_TYPE"
			when OPTION then
				Result := "OPTION"
			when ADD then
				Result := "ADD"
			when DELETE then
				Result := "DELETE"
			when MODIFY then
				Result := "MODIFY"
			when MODRDN then
				Result := "MODRDN"
			when MODDN then
				Result := "MODDN"
			when ADD_COLON then
				Result := "ADD_COLON"
			when DELETE_COLON then
				Result := "DELETE_COLON"
			when REPLACE_COLON then
				Result := "REPLACE_COLON"
			when DIGITS then
				Result := "DIGITS"
			when SAFE_STRING then
				Result := "SAFE_STRING"
			when SPACES then
				Result := "SPACES"
			when SEP then
				Result := "SEP"
			else
				Result := yy_character_token_name (a_token)
			end
		end

feature -- Token codes

	CHANGETYPE_COLON: INTEGER is 258
	CONTROL_COLON: INTEGER is 259
	DN: INTEGER is 260
	VERSION_COLON: INTEGER is 261
	ATTRIBUTE_TYPE: INTEGER is 262
	OPTION: INTEGER is 263
	ADD: INTEGER is 264
	DELETE: INTEGER is 265
	MODIFY: INTEGER is 266
	MODRDN: INTEGER is 267
	MODDN: INTEGER is 268
	ADD_COLON: INTEGER is 269
	DELETE_COLON: INTEGER is 270
	REPLACE_COLON: INTEGER is 271
	DIGITS: INTEGER is 272
	SAFE_STRING: INTEGER is 273
	SPACES: INTEGER is 274
	SEP: INTEGER is 275

end
