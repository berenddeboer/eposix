note

	description: "Class that implements whatever an HTTP 1.1 client can do."

	author: "Berend de Boer"


class

	EPX_HTTP_11_CLIENT


inherit

	EPX_HTTP_10_CLIENT
		redefine
			authorization_value,
			client_version
		end


create

	make,
	make_with_port,
	make_from_host,
	make_from_host_and_port,
	make_secure,
	make_secure_with_port


feature -- Client http version

	client_version: STRING
		once
			Result := "HTTP/1.1"
		end


feature -- Change

	set_reuse_connection
			-- Reuse HTTP connection more than 1 request.
		do
			reuse_connection := True
		ensure
			reusing: reuse_connection
		end


feature {NONE} -- Implementation

	authorization_value (a_verb, a_uri: STRING): STRING
			-- Append Authorization field if `authentication_scheme' is recognised.
		do
			if not user_name.is_empty and then not password.is_empty then
				if STRING_.same_string (authentication_scheme, once "Digest") then
					if attached www_authenticate then
						Result := digest_authorization_value (a_verb, a_uri)
					else
						create Result.make_empty
					end
				elseif STRING_.same_string (authentication_scheme, once "Basic") then
					Result := basic_authorization_value (user_name, password)
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		end

	digest_authorization_value (a_verb, a_uri: STRING): STRING
			-- Only MD5 support, MD5-sess not supported.
		require
			www_authenticate_set: www_authenticate /= Void
		do
			if attached www_authenticate as a and then
				STRING_.same_string (a.algorithm, once "MD5") then
				Result := "Digest " + digest_md5_authorization_value (a, a_verb, a_uri)
			else
				create Result.make_empty
			end
		end

	digest_md5_authorization_value (a_www_authenticate: EPX_MIME_FIELD_WWW_AUTHENTICATE; a_verb, a_uri: STRING): STRING
			-- Digest when algorithm = MD5
		require
			www_authenticate_set: attached a_www_authenticate
			www_authenticate_realm_set: attached a_www_authenticate.realm
			no_rfc_2069_support: a_www_authenticate.qop /= Void
			qop_is_auth: attached a_www_authenticate.qop as qop and then STRING_.same_string (qop, once "auth")
			verb_not_empty: a_verb /= Void and then not a_verb.is_empty
			uri_not_empty: a_uri /= Void and then not a_uri.is_empty
		local
			A1, A2: STRING
			H_A1, H_A2: STRING
			opaque: STRING
			request_digest: STRING
			--cnonce: STRING
			--nc: STRING
		do
			create Result.make (256)
			Result.append_string ("username=%"")
			Result.append_string (user_name)
			Result.append_string ("%", realm=%"")
			Result.append_string (a_www_authenticate.realm)
			Result.append_string ("%", nonce=%"")
			Result.append_string (a_www_authenticate.nonce)
			Result.append_string ("%", uri=%"")
			Result.append_string (a_uri)

			-- We don't request protection from the server
			-- if qop /= Void then
			-- 	Result.append_string ("%", qop=%"")
			-- 	Result.append_string (qop)
			-- 	nc := "00000001"
			-- 	Result.append_string ("%", nc=%"")
			-- 	Result.append_string (nc)
			-- end
			-- cnonce := "0a4f113b"
			-- Result.append_string ("%", cnonce=%"")
			-- Result.append_string (cnonce)
			Result.append_string ("%", response=%"")
			A1 := user_name + ":" + a_www_authenticate.realm + ":" + password
			A2 := a_verb + ":" + a_uri
			H_A1 := md5 (A1)
			H_A2 := md5 (A2)
			-- No nc-value, cnonce-value or qop value
			if attached a_www_authenticate.nonce as nonce then
				request_digest := md5 (H_A1 + ":" + nonce + ":" + H_A2)
			end
			Result.append_string (request_digest)
			opaque := a_www_authenticate.opaque
			if opaque /= Void then
				Result.append_string ("%", opaqee=%"")
				Result.append_string (opaque)
			end
			Result.append_character ('"')
		end

	md5 (s: STRING): STRING
		require
			s_not_void: s /= Void
		do
			md5_calc.wipe_out
			md5_calc.put_string (s)
			md5_calc.finalize
			Result := md5_calc.checksum
		end

	md5_calc: EPX_MD5_CALCULATION
		once
			create Result.make
		ensure
			not_void: Result /= Void
		end


end
