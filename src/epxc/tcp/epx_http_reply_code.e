indexing

	description:

		"HTTP reply codes as found in RFC 2616"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_HTTP_REPLY_CODE


inherit

	EPX_REPLY_CODE


feature -- Status

	is_redirect_response: BOOLEAN is
			-- Is `reply_code' a redirect code?
		do
			Result :=
				reply_code = reply_code_moved_permanently or else
				reply_code = reply_code_found or else
				reply_code = reply_code_see_other or else
				reply_code = reply_code_use_proxy or else
				reply_code = reply_code_temporary_redirect
		end


feature -- Redirection codes

	reply_code_moved_permanently: INTEGER is 301
			-- The requested resource has been assigned a new permanent
			-- URI and any future references to this resource SHOULD use
			-- one of the returned URIs.

	reply_code_found: INTEGER is 302
			-- The requested resource resides temporarily under a
			-- different URI.  Since the redirection might be altered on
			-- occasion, the client SHOULD continue to use the
			-- Request-URI for future requests.

	reply_code_see_other: INTEGER is 303
			-- The response to the request can be found under a different
			-- URI and SHOULD be retrieved using a GET method on that
			-- resource. This method exists primarily to allow the output
			-- of a POST-activated script to redirect the user agent to a
			-- selected resource. The new URI is not a substitute
			-- reference for the originally requested resource.

	reply_code_not_modified: INTEGER is 304
			-- If the client has performed a conditional GET request and
			-- access is allowed, but the document has not been modified,
			-- the server SHOULD respond with this status code.

	reply_code_use_proxy: INTEGER is 305
			-- The requested resource MUST be accessed through the proxy
			-- given by the Location field. The Location field gives the
			-- URI of the proxy.

	reply_code_temporary_redirect: INTEGER is 307
			-- The requested resource resides temporarily under a
			-- different URI.  Since the redirection MAY be altered on
			-- occasion, the client SHOULD continue to use the
			-- Request-URI for future requests.


feature -- Client error codes

	reply_code_unauthorized: INTEGER is 401
			-- The request requires user authentication. The response
			-- MUST include a WWW-Authenticate header field (section
			-- 14.47) containing a challenge applicable to the requested
			-- resource.

	reply_code_forbidden: INTEGER is 403
			-- The server understood the request, but is refusing to
			-- fulfill it. Authorization will not help and the request
			-- SHOULD NOT be repeated.

	reply_code_not_found: INTEGER is 404
			-- The server has not found anything matching the
			-- Request-URI. No indication is given of whether the
			-- condition is temporary or permanent.


feature -- Server error codes

	reply_code_service_unavailable: INTEGER is 503
			-- The server is currently unable to handle the request due
			-- to a temporary overloading or maintenance of the
			-- server. The implication is that this is a temporary
			-- condition which will be alleviated after some delay. If
			-- known, the length of the delay MAY be indicated in a
			-- Retry-After header. If no Retry-After is given, the client
			-- SHOULD handle the response as it would for a 500 response.


end
