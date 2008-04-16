indexing

	description: "Parser token codes"
	generator: "geyacc version 3.7"

class EPX_MIME_TOKENS

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
			when FN_BCC then
				Result := "FN_BCC"
			when FN_CC then
				Result := "FN_CC"
			when FN_CONTENT_DISPOSITION then
				Result := "FN_CONTENT_DISPOSITION"
			when FN_CONTENT_LENGTH then
				Result := "FN_CONTENT_LENGTH"
			when FN_CONTENT_TRANSFER_ENCODING then
				Result := "FN_CONTENT_TRANSFER_ENCODING"
			when FN_CONTENT_TYPE then
				Result := "FN_CONTENT_TYPE"
			when FN_DATE then
				Result := "FN_DATE"
			when FN_FROM then
				Result := "FN_FROM"
			when FN_IF_MODIFIED_SINCE then
				Result := "FN_IF_MODIFIED_SINCE"
			when FN_LAST_MODIFIED then
				Result := "FN_LAST_MODIFIED"
			when FN_MESSAGE_ID then
				Result := "FN_MESSAGE_ID"
			when FN_RECEIVED then
				Result := "FN_RECEIVED"
			when FN_RETURN_PATH then
				Result := "FN_RETURN_PATH"
			when FN_RESENT_FROM then
				Result := "FN_RESENT_FROM"
			when FN_RESENT_REPLY_TO then
				Result := "FN_RESENT_REPLY_TO"
			when FN_RESENT_SENDER then
				Result := "FN_RESENT_SENDER"
			when FN_SENDER then
				Result := "FN_SENDER"
			when FN_SET_COOKIE then
				Result := "FN_SET_COOKIE"
			when FN_TO then
				Result := "FN_TO"
			when FN_TRANSFER_ENCODING then
				Result := "FN_TRANSFER_ENCODING"
			when FN_VERSION then
				Result := "FN_VERSION"
			when FN_WWW_AUTHENTICATE then
				Result := "FN_WWW_AUTHENTICATE"
			when MIME_ATOM then
				Result := "MIME_ATOM"
			when MIME_VALUE_ATOM then
				Result := "MIME_VALUE_ATOM"
			when DOMAIN_LITERAL then
				Result := "DOMAIN_LITERAL"
			when QUOTED_STRING then
				Result := "QUOTED_STRING"
			when MONTH then
				Result := "MONTH"
			when NUMBER then
				Result := "NUMBER"
			when KW_BY then
				Result := "KW_BY"
			when KW_FOR then
				Result := "KW_FOR"
			when KW_FROM then
				Result := "KW_FROM"
			when KW_ID then
				Result := "KW_ID"
			when KW_VIA then
				Result := "KW_VIA"
			when KW_WITH then
				Result := "KW_WITH"
			when KW_SUN then
				Result := "KW_SUN"
			when KW_MON then
				Result := "KW_MON"
			when KW_TUE then
				Result := "KW_TUE"
			when KW_WED then
				Result := "KW_WED"
			when KW_THU then
				Result := "KW_THU"
			when KW_FRI then
				Result := "KW_FRI"
			when KW_SAT then
				Result := "KW_SAT"
			when FIELD_NAME then
				Result := "FIELD_NAME"
			when FIELD_BODY then
				Result := "FIELD_BODY"
			when CRLF then
				Result := "CRLF"
			else
				Result := yy_character_token_name (a_token)
			end
		end

feature -- Token codes

	FN_BCC: INTEGER is 258
	FN_CC: INTEGER is 259
	FN_CONTENT_DISPOSITION: INTEGER is 260
	FN_CONTENT_LENGTH: INTEGER is 261
	FN_CONTENT_TRANSFER_ENCODING: INTEGER is 262
	FN_CONTENT_TYPE: INTEGER is 263
	FN_DATE: INTEGER is 264
	FN_FROM: INTEGER is 265
	FN_IF_MODIFIED_SINCE: INTEGER is 266
	FN_LAST_MODIFIED: INTEGER is 267
	FN_MESSAGE_ID: INTEGER is 268
	FN_RECEIVED: INTEGER is 269
	FN_RETURN_PATH: INTEGER is 270
	FN_RESENT_FROM: INTEGER is 271
	FN_RESENT_REPLY_TO: INTEGER is 272
	FN_RESENT_SENDER: INTEGER is 273
	FN_SENDER: INTEGER is 274
	FN_SET_COOKIE: INTEGER is 275
	FN_TO: INTEGER is 276
	FN_TRANSFER_ENCODING: INTEGER is 277
	FN_VERSION: INTEGER is 278
	FN_WWW_AUTHENTICATE: INTEGER is 279
	MIME_ATOM: INTEGER is 280
	MIME_VALUE_ATOM: INTEGER is 281
	DOMAIN_LITERAL: INTEGER is 282
	QUOTED_STRING: INTEGER is 283
	MONTH: INTEGER is 284
	NUMBER: INTEGER is 285
	KW_BY: INTEGER is 286
	KW_FOR: INTEGER is 287
	KW_FROM: INTEGER is 288
	KW_ID: INTEGER is 289
	KW_VIA: INTEGER is 290
	KW_WITH: INTEGER is 291
	KW_SUN: INTEGER is 292
	KW_MON: INTEGER is 293
	KW_TUE: INTEGER is 294
	KW_WED: INTEGER is 295
	KW_THU: INTEGER is 296
	KW_FRI: INTEGER is 297
	KW_SAT: INTEGER is 298
	FIELD_NAME: INTEGER is 299
	FIELD_BODY: INTEGER is 300
	CRLF: INTEGER is 301

end
