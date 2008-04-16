indexing

	description: "Response codes and reason phrases."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_HTTP_RESPONSE


feature -- Status

	is_three_digit_response (a_code: INTEGER): BOOLEAN is
			-- Is `a_code' a three digit response code?
		do
			Result := a_code >= 100 and a_code <= 999
		ensure
			definition: Result = (a_code >= 100 and a_code <= 999)
		end


feature -- Reason phrase

	reason_phrase (a_code: INTEGER): STRING is
			-- Give the reason phrase given `a_code'.
			-- Empty string if there is no reason phrase.
		require
			three_digit_response: is_three_digit_response (a_code)
		do
			if reason_phrases.has (a_code) then
				Result := reason_phrases.item (a_code)
			else
				Result := ""
			end
		ensure
			reason_phrase_not_void: Result /= Void
		end

	reason_phrases: DS_HASH_TABLE [STRING, INTEGER] is
			-- RFC 26116 reason phrases.
		once
			create Result.make (128)
			Result.put ("Continue", 100)
			Result.put ("Switching Protocols", 101)
			Result.put ("OK", 200)
			Result.put ("Created", 201)
			Result.put ("Accepted", 202)
			Result.put ("Non-Authoritative Information", 203)
			Result.put ("No Content", 204)
			Result.put ("Reset Content", 205)
			Result.put ("Partial Content", 206)
			Result.put ("Multiple Choices", 300)
			Result.put ("Moved Permanently", 301)
			Result.put ("Found", 302)
			Result.put ("See Other", 303)
			Result.put ("Not Modified", 304)
			Result.put ("Use Proxy", 305)
			Result.put ("Temporary Redirect", 307)
			Result.put ("Bad Request", 400)
			Result.put ("Unauthorized", 401)
			Result.put ("Payment Required", 402)
			Result.put ("Forbidden", 403)
			Result.put ("Not Found", 404)
			Result.put ("Method Not Allowed", 405)
			Result.put ("Not Acceptable", 406)
			Result.put ("Proxy Authentication Required", 407)
			Result.put ("Request Time-out", 408)
			Result.put ("Conflict", 409)
			Result.put ("Gone", 410)
			Result.put ("Length Required", 411)
			Result.put ("Precondition Failed", 412)
			Result.put ("Request Entity Too Large", 413)
			Result.put ("Request-URI Too Large", 414)
			Result.put ("Unsupported Media Type", 415)
			Result.put ("Requested range not satisfiable", 416)
			Result.put ("Expectation Failed", 417)
			Result.put ("Internal Server Error", 500)
			Result.put ("Not Implemented", 501)
			Result.put ("Bad Gateway", 502)
			Result.put ("Service Unavailable", 503)
			Result.put ("Gateway Time-out", 504)
			Result.put ("HTTP Version not supported", 505)
		ensure
			reason_phrases_not_void: Result /= Void
		end


end
