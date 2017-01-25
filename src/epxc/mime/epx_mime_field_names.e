note

	description: "Well-known MIME field names."

	usage: "Inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"


class

	EPX_MIME_FIELD_NAMES


feature -- List of well-known field names

	field_name_accept: STRING = "Accept"

	field_name_accept_ranges: STRING = "Accept-Ranges"

	field_name_allow: STRING = "Allow"

	field_name_authorization: STRING = "Authorization"

	field_name_bcc: STRING = "Bcc"

	field_name_cache_control: STRING = "Cache-Control"

	field_name_cc: STRING = "Cc"

	field_name_connection: STRING = "Connection"

	field_name_content_disposition: STRING = "Content-Disposition"

	field_name_content_encoding: STRING = "Content-Encoding"

	field_name_content_length: STRING = "Content-Length"

	field_name_content_transfer_encoding: STRING = "Content-Transfer-Encoding"

	field_name_content_type: STRING = "Content-Type"

	field_name_date: STRING = "Date"

	field_name_expect: STRING = "Expect"

	field_name_expires: STRING = "Expires"

	field_name_etag: STRING = "ETag"

	field_name_from: STRING = "From"

	field_name_host: STRING = "Host"

	field_name_if_modified_since: STRING = "If-Modified-Since"

	field_name_if_none_match: STRING = "If-None-Match"

	field_name_if_unmodified_since: STRING = "If-Unmodified-Since"

	field_name_last_modified: STRING = "Last-Modified"

	field_name_location: STRING = "Location"

	field_name_mime_version: STRING = "MIME-Version"

	field_name_reply_to: STRING = "Reply-To"

	field_name_resent_from: STRING = "Resent-From"

	field_name_resent_reply_to: STRING = "Resent-Reply-To"

	field_name_server: STRING = "Server"

	field_name_set_cookie: STRING = "Set-Cookie"

	field_name_status: STRING = "Status"

	field_name_subject: STRING = "Subject"

	field_name_to: STRING = "To"

	field_name_transfer_encoding: STRING = "Transfer-Encoding"

	field_name_user_agent: STRING = "User-Agent"

	field_name_vary: STRING = "Vary"

	field_name_www_authenticate: STRING = "WWW-Authenticate"

end
