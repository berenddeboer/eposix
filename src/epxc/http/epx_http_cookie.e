indexing

	description: "HTTP Cookies."

	references: "http://www.cookiecentral.com/faq/"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	EPX_HTTP_COOKIE


inherit

	EPX_KEY_VALUE


create

	make


feature -- Access

	domain: STRING
			-- Cookies can be assigned to individual machines, or to an
			-- entire Internet domain. The only restrictions on this
			-- value is that it must contain at least two dots
			-- (.myserver.com, not myserver.com) for the normal top-level
			-- domains, or three dots for the "extended" domains
			-- (.myserver.ny.us, not myserver.ny.us)
			-- The server issuing the cookie must be a member of the
			-- domain that it tries to set in the cookie. That is, a
			-- server called www.myserver.com cannot set a cookie for the
			-- domain www.yourserver.com. The security implications
			-- should be obvious.
			-- If `domain' is not set explicitly, then it defaults to the
			-- full domain of the document creating the cookie.

	expires: STDC_TIME
			-- Lifetime of the cookie.
			-- If `expires' is not set explicitly, then it defaults to
			-- end-of-session. The length of a session can vary depending
			-- on browsers and servers, but generally a session is the
			-- length of time that the browser is open for (even if the
			-- user is no longer at that site).

	path: STRING
			-- The URL path the cookie is valid within. Pages outside of
			-- that path cannot read or use the cookie.
			-- If `path' is not set explicitly, then it defaults to the URL
			-- path of the document creating the cookie.

	secure: BOOLEAN
			-- The secure parameter is a flag indicating that a cookie
			-- should only be used under a secure server condition, such
			-- as SSL. Since most sites do not require secure
			-- connections, this defaults to FALSE.


feature -- Change state

	set_domain (a_domain: STRING) is
			-- Set `domain'.
		require
			domain_is_void_or_not_empty: a_domain = Void or else not a_domain.is_empty
		do
			domain := a_domain
		end

	set_expires (a_expires: STDC_TIME) is
			-- Set `expires'.
		require
			gmt_time_only: a_expires = Void or else a_expires.is_utc_time
		do
			expires := a_expires
		end

	set_path (a_path: STRING) is
			-- Set `path'.
		require
			path_is_void_or_not_empty: a_path = Void or else not a_path.is_empty
		do
			path := a_path
		end

	set_secure (a_secure: BOOLEAN) is
			-- Set `secure'.
		do
			secure := a_secure
		ensure
			secure_set: secure = a_secure
		end


invariant

	domain_is_void_or_not_empty: domain = Void or else not domain.is_empty
	expires_is_gmt_time_only: expires = Void or else expires.is_utc_time
	path_is_void_or_not_empty: path = Void or else not path.is_empty

end
