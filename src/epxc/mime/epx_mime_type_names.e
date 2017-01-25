note

	description: "Class with once strings for well-known MIME types."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


class

	EPX_MIME_TYPE_NAMES


feature -- Type names

	mime_type_application: STRING = "application"
	mime_type_binary: STRING = "binary"
	mime_type_message: STRING = "message"
	mime_type_multipart: STRING = "multipart"
	mime_type_text: STRING = "text"


feature -- Subtype names

	mime_subtype_alternative: STRING = "alternative"
	mime_subtype_delivery_status: STRING = "delivery-status"
	mime_subtype_form_data: STRING = "form-data"
	mime_subtype_html: STRING = "html"
	mime_subtype_javascript: STRING = "javascript"
	mime_subtype_mixed: STRING = "mixed"
	mime_subtype_octet_stream: STRING = "octet-stream"
	mime_subtype_pdf: STRING = "pdf"
	mime_subtype_plain: STRING = "plain"
	mime_subtype_related: STRING = "related"
	mime_subtype_rfc822: STRING = "rfc822"
	mime_subtype_x_www_form_urlencoded: STRING = "x-www-form-urlencoded"
	mime_subtype_x_javascript: STRING = "x-javascript"
	mime_subtype_json: STRING = "json"
	mime_subtype_x_tex: STRING = "x-tex"
	mime_subtype_xml: STRING = "xml"


feature -- Full mime types

	mime_type_application_xhtml_plus_xml: STRING = "application/xhtml+xml"
	mime_type_application_xml: STRING = "application/xml"
	mime_type_application_x_www_form_urlencoded: STRING = "application/x-www-form-urlencoded"
	mime_type_image_gif: STRING = "image/gif"
	mime_type_image_png: STRING = "image/png"
	mime_type_multipart_form_data: STRING = "multipart/form-data"
	mime_type_text_css: STRING = "text/css"
	mime_type_text_javascript: STRING = "text/javascript"
	mime_type_text_plain: STRING = "text/plain"
	mime_type_text_html: STRING = "text/html"
	mime_type_text_xml: STRING = "text/xml"


end
