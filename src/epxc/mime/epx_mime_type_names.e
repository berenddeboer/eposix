indexing

	description: "Class with once strings for well-known MIME types."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


class

	EPX_MIME_TYPE_NAMES


feature -- Type names

	mime_type_application: STRING is "application"
	mime_type_binary: STRING is "binary"
	mime_type_message: STRING is "message"
	mime_type_multipart: STRING is "multipart"
	mime_type_text: STRING is "text"


feature -- Subtype names

	mime_subtype_alternative: STRING is "alternative"
	mime_subtype_delivery_status: STRING is "delivery-status"
	mime_subtype_form_data: STRING is "form-data"
	mime_subtype_html: STRING is "html"
	mime_subtype_javascript: STRING is "javascript"
	mime_subtype_mixed: STRING is "mixed"
	mime_subtype_octet_stream: STRING is "octet-stream"
	mime_subtype_pdf: STRING is "pdf"
	mime_subtype_plain: STRING is "plain"
	mime_subtype_related: STRING is "related"
	mime_subtype_rfc822: STRING is "rfc822"
	mime_subtype_x_javascript: STRING is "x-javascript"
	mime_subtype_x_tex: STRING is "x-tex"
	mime_subtype_xml: STRING is "xml"


feature -- Full mime types

	mime_type_application_xhtml_plus_xml: STRING is "application/xhtml+xml"
	mime_type_application_xml: STRING is "application/xml"
	mime_type_application_x_www_form_urlencoded: STRING is "application/x-www-form-urlencoded"
	mime_type_image_gif: STRING is "image/gif"
	mime_type_image_png: STRING is "image/png"
	mime_type_multipart_form_data: STRING is "multipart/form-data"
	mime_type_text_css: STRING is "text/css"
	mime_type_text_javascript: STRING is "text/javascript"
	mime_type_text_plain: STRING is "text/plain"
	mime_type_text_html: STRING is "text/html"
	mime_type_text_xml: STRING is "text/xml"


end
