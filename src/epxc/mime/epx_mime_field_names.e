indexing

	description: "Well-known MIME field names."

	usage: "Inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"


class

	EPX_MIME_FIELD_NAMES


feature -- List of well-known field names

	field_name_accept: STRING is "Accept"

	field_name_accept_ranges: STRING is "Accept-Ranges"

	field_name_allow: STRING is "Allow"

	field_name_authorization: STRING is "Authorization"

	field_name_bcc: STRING is "Bcc"

	field_name_cache_control: STRING is "Cache-Control"

	field_name_cc: STRING is "Cc"

	field_name_connection: STRING is "Connection"

	field_name_content_disposition: STRING is "Content-Disposition"

	field_name_content_encoding: STRING is "Content-Encoding"

	field_name_content_length: STRING is "Content-Length"

	field_name_content_transfer_encoding: STRING is "Content-Transfer-Encoding"

	field_name_content_type: STRING is "Content-Type"

	field_name_date: STRING is "Date"

	field_name_expect: STRING is "Expect"

	field_name_expires: STRING is "Expires"

	field_name_etag: STRING is "ETag"

	field_name_from: STRING is "From"

	field_name_host: STRING is "Host"

	field_name_if_modified_since: STRING is "If-Modified-Since"

	field_name_if_none_match: STRING is "If-None-Match"

	field_name_if_unmodified_since: STRING is "If-Unmodified-Since"

	field_name_last_modified: STRING is "Last-Modified"

	field_name_location: STRING is "Location"

	field_name_mime_version: STRING is "MIME-Version"

	field_name_reply_to: STRING is "Reply-To"

	field_name_resent_from: STRING is "Resent-From"

	field_name_resent_reply_to: STRING is "Resent-Reply-To"

	field_name_server: STRING is "Server"

	field_name_set_cookie: STRING is "Set-Cookie"

	field_name_status: STRING is "Status"

	field_name_subject: STRING is "Subject"

	field_name_to: STRING is "To"

	field_name_transfer_encoding: STRING is "Transfer-Encoding"

	field_name_user_agent: STRING is "User-Agent"

	field_name_vary: STRING is "Vary"

	field_name_www_authenticate: STRING is "WWW-Authenticate"

end
