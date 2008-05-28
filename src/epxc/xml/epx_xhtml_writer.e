indexing

	description: "Generates XHTML."

	todo:
		"1. should use binary search allowed_new_line_tag"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #13 $"

class

	EPX_XHTML_WRITER


inherit

	EPX_XML_WRITER
		rename
			xml as document
		redefine
			empty_tag_closing_chars,
			indent,
			new_line_after_closing_tag,
			new_line_before_starting_tag
		end

	EPX_MIME_TYPE_NAMES
		export
			{NONE} all
		end


create

	make,
	make_with_capacity,
	make_fragment,
	make_fragment_with_capacity


feature -- overrule some xml stuff

	new_line_after_closing_tag (a_tag: STRING) is
		do
			if allowed_new_line_tag (a_tag) then
				precursor (a_tag)
			end
		end

	new_line_before_starting_tag (a_tag: STRING) is
		do
			if allowed_new_line_tag (a_tag) then
				precursor (a_tag)
			end
		end


feature {NONE} -- overrule some xml layout

	allowed_new_line_tag (a_tag: STRING): BOOLEAN is
			-- When can we emit a new line after closing a tag?
		require
			tag_not_void: a_tag /= Void
		do
			Result :=
				STRING_.same_string (a_tag, once_p) or else
				STRING_.same_string (a_tag, once_br) or else
				STRING_.same_string (a_tag, once_td) or else
				STRING_.same_string (a_tag, once_tr) or else
				STRING_.same_string (a_tag, once_table) or else
				STRING_.same_string (a_tag, once_select) or else
				STRING_.same_string (a_tag, once_option) or else
				STRING_.same_string (a_tag, once_pre) or else
				STRING_.same_string (a_tag, once_div) or else
				STRING_.same_string (a_tag, once_h3) or else
				STRING_.same_string (a_tag, once_h2) or else
				STRING_.same_string (a_tag, once_h1) or else
				STRING_.same_string (a_tag, once_form) or else
				STRING_.same_string (a_tag, once_html) or else
				STRING_.same_string (a_tag, once_meta) or else
				STRING_.same_string (a_tag, once_head) or else
				STRING_.same_string (a_tag, once_body) or else
				STRING_.same_string (a_tag, once_title)
			end

	empty_tag_closing_chars: STRING is
			-- XHTML applications like an additional space.
		once
			Result := " />"
		end

	indent is
			-- Slightly less indenting
		local
			spaces: STRING
		do
			if tags.count > 2 then
				spaces := sh.make_spaces (2 * (tags.count - 2 ) )
				extend (spaces)
			end
		end


feature -- doctype

	doctype is
			-- Default doctype is `doctype_strict'.
		do
			doctype_strict
		ensure
			header_written: is_header_written
		end

	doctype_frameset is
			-- Output will be frame-based.
		do
			add_header_iso_8859_1_encoding
			extend ("<!DOCTYPE html PUBLIC %"-//W3C//DTD XHTML 1.0 Frameset//EN%"%
					  % %"DTD/xhtml1-frameset.dtd%">")
			new_line
		ensure
			header_written: is_header_written
		end

	doctype_strict is
			-- Output will be strict XHTML in the ISO-8859-1 encoding.
		do
			add_header_iso_8859_1_encoding
			extend ("<!DOCTYPE html PUBLIC %"-//W3C//DTD XHTML 1.0 Strict//EN%"%
					  % %"DTD/xhtml1-strict.dtd%">")
			new_line
		ensure
			header_written: is_header_written
		end

	doctype_strict_utf8 is
			-- Output will be strict XHTML in the UTF-8 encoding.
		do
			add_header_utf_8_encoding
			extend ("<!DOCTYPE html PUBLIC %"-//W3C//DTD XHTML 1.0 Strict//EN%"%
					  % %"DTD/xhtml1-strict.dtd%">")
			new_line
		ensure
			header_written: is_header_written
		end

	doctype_transitional is
			-- Output will be transitional XHTML with ISO-8859-1 encoding.
		do
			add_header_iso_8859_1_encoding
			extend ("<!DOCTYPE html PUBLIC %"-//W3C//DTD XHTML 1.0 Transitional//EN%"%
					  % %"DTD/xhtml1-transitional.dtd%">")
			new_line
		ensure
			header_written: is_header_written
		end


feature -- Set well-known attributes

	set_id (a_id: STRING) is
			-- Set the id attribute.
		require
			tag_started: is_tag_started
			id_not_empty: a_id /= Void and then not a_id.is_empty
		do
			set_attribute (once_id, a_id)
		end

	set_xhtml_name_space is
			-- Add the XHTML name space to the current tag.
		require
			tag_started: is_tag_started
		do
			set_attribute (xmlns, xhtml_uri)
		end


feature -- Page

	b_html is
		do
			start_tag (once_html)
			set_xhtml_name_space
			set_ns_attribute ("xml", "lang", "en")
			set_attribute ("lang", "en")
		end

	e_html is
		require
			valid_stop: is_started (once_html)
		do
			stop_tag
		end


feature -- Header

	meta_content_type (a_content_type: STRING) is
			-- Add Content-Type to HTML. `a_content_type' is of the
			-- format "text/html; charset=utf-8".
		do
			start_tag (once_meta)
			set_attribute (once_http_equiv, "Content-Type")
			set_attribute (once_content, a_content_type)
			stop_tag
		end

	meta_refresh_other (a_time: INTEGER; a_url: STRING) is
		do
			start_tag (once_meta)
			set_attribute (once_http_equiv, "refresh")
			set_attribute (once_content, a_time.out + "; URL=" + a_url)
			stop_tag
		end

	b_head is
		require
			html_started: is_started (once_html)
		do
			start_tag (once_head)
		end

	e_head is
		require
			valid_stop: is_started (once_head)
		do
			stop_tag
		end

	title (a_text: STRING) is
		require
			head_started: is_started (once_head)
		do
			add_tag (once_title, a_text)
		end


feature -- Body

	b_body is
		require
			html_started: is_started (once_html)
		do
			start_tag (once_body)
		end

	e_body is
		require
			valid_stop: is_started (once_body)
		do
			stop_tag
		end


feature -- Section headers

	h1 (header_text: STRING) is
		do
			add_tag (once_h1, header_text)
		end

	h2 (header_text: STRING) is
		do
			add_tag (once_h2, header_text)
		end


feature -- Paragraph

	br is
			-- break.
		do
			start_tag (once_br)
			stop_tag
		end

	br_clear_all is
			-- Add break and flush all floats.
		do
			start_tag (once_br)
			set_attribute (once_clear, once_all)
			stop_tag
		end

	b_p is
		do
			start_tag (once_p)
		end

	e_p is
		require
			valid_stop: is_started (once_p)
		do
			stop_tag
		end

	p (par: STRING) is
		do
			add_tag (once_p, par)
		end


feature -- Inline tags

	b_b is
			-- Begin bold font.
		do
			start_tag ("b")
		end

	e_b is
			-- End bold font.
		require
			valid_stop: is_started ("b")
		do
			stop_tag
		end

	b_i is
			-- Begin italic font.
		do
			start_tag ("i")
		end

	e_i is
			-- End italic font.
		require
			valid_stop: is_started ("i")
		do
			stop_tag
		end

	b_tt is
			-- teletype writer font
		do
			start_tag ("tt")
		end

	e_tt is
		require
			valid_stop: is_started ("tt")
		do
			stop_tag
		end


feature -- Lists

	b_ul is
			-- Begin unordered list.
		do
			start_tag ("ul")
		end

	e_ul is
			-- End unordered list.
		require
			valid_stop: is_started ("ul")
		do
			stop_tag
		end

	b_li is
			-- Begin list item.
		do
			start_tag ("li")
		end

	e_li is
			-- End list item.
		require
			valid_stop: is_started ("li")
		do
			stop_tag
		end


feature -- Quotes

	b_blockquote is
		require
			body_started: is_a_parent (once_body)
		do
			start_tag (once_blockquote)
		end

	e_blockquote is
		require
			blockquote_started: is_started (once_blockquote)
		do
			stop_tag
		end

	blockquote (a_quote: STRING) is
		do
			b_blockquote
			add_data (a_quote)
			e_blockquote
		end


feature -- Link

	b_a (href: STRING) is
		require
			valid_containment: not is_a_parent (once_a)
		do
			start_tag (once_a)
			set_attribute ("href", href)
		end

	e_a is
		require
			valid_stop: is_started (once_a)
		do
			stop_tag
		end

	a (href, s: STRING) is
		do
			b_a (href)
			add_data (s)
			e_a
		end


feature -- Rules

	hr is
			-- horizontal rule
		do
			start_tag ("hr")
			stop_tag
		end


feature -- White space

	nbsp is
			-- Add a non breaking white space.
		do
			add_entity ("nbsp")
		end


feature -- Verbatim

	b_pre is
		do
			start_tag (once_pre)
			put_new_line
		end

	e_pre is
		require
			valid_stop: is_started (once_pre)
		do
			-- make sure </pre> always starts on its own line
			if not on_new_line then
				new_line
			end
			stop_tag
		end


feature -- Images

	b_img (a_src, a_description: STRING) is
			-- Start an img tag with `a_src' the source of the image and
			-- `a_description' the alternative (alt) text of the image.
		do
			start_tag (once_img)
			set_attribute (once_src, a_src)
			set_attribute (once_alt, a_description)
		end

	e_img is
			-- Stop image.
		require
			img_started: is_started (once_img)
		do
			stop_tag
		end

	img (a_src, a_description: STRING) is
			-- Emit an img tag with `a_src' the source of the image and
			-- `a_description' the alternative (alt) text of the image.
		require
			src_required: a_src /= Void and then not a_src.is_empty
		do
			b_img (a_src, a_description)
			e_img
		end


feature -- Tables

	b_table is
			-- Begin a table.
		do
			start_tag (once_table)
		end

	e_table is
			-- End a table.
		require
			valid_stop: is_started (once_table)
		do
			stop_tag
		end

	b_tr is
			-- Begin a row.
		require
			table_started: is_started (once_table)
		do
			start_tag (once_tr)
		end

	e_tr is
			-- End a row.
		require
			valid_stop: is_started (once_tr)
		do
			stop_tag
		end

	td (a_content: STRING) is
			-- Add cell with optional contents.
		do
			b_td
			add_data (a_content)
			e_td
		end

	b_td is
			-- Begin a column.
		require
			row_started: is_started (once_tr)
		do
			start_tag (once_td)
		end

	e_td is
			-- End a column.
		require
			valid_stop: is_started (once_td)
		do
			stop_tag
		end

	th (a_title: STRING) is
			-- Add a header cell.
		require
			row_started: is_started (once_tr)
		do
			b_th
			add_data (a_title)
			e_th
		end

	b_th is
			-- Begin a table header cell.
		require
			row_started: is_started (once_tr)
		do
			start_tag ("th")
		end

	e_th is
			-- Add a table header cell.
		require
			valid_stop: is_started ("th")
		do
			stop_tag
		end


feature -- Forms

	standard_encoding: STRING is
		obsolete "Use mime_type_application_x_www_form_urlencoded instead."
		do
			Result := mime_type_application_x_www_form_urlencoded
		end

	plaintext_encoding: STRING is
		obsolete "Use mime_type_text_plain instead."
		do
			Result:= mime_type_text_plain
		end

	multipart_encoding: STRING is
		obsolete "Use mime_type_multipart_form_data instead."
		do
			Result := mime_type_multipart_form_data
		end

	b_form (method, action: STRING) is
		require
			valid_method: method /= Void and then not method.is_empty
			valid_action: action /= Void and then not action.is_empty
		do
			start_tag (once_form)
			set_attribute ("method", method)
			set_attribute ("action", action)
		end

	b_form_get (action: STRING) is
		require
			valid_action: action /= Void and then not action.is_empty
		do
			b_form ("get", action)
		end

	b_form_post (action: STRING) is
		require
			valid_action: action /= Void and then not action.is_empty
		do
			b_form ("post", action)
		end

	e_form is
		require
			valid_stop: is_started (once_form)
		do
			stop_tag
		end

	b_input (type, name: STRING) is
		require
			form_started: not is_fragment implies is_a_parent (once_form)
			type_not_empty: type /= Void and then not type.is_empty
			valid_type:
				STRING_.same_string (type, "button") or else
				STRING_.same_string (type, "checkbox") or else
				STRING_.same_string (type, "file") or else
				STRING_.same_string (type, "hidden") or else
				STRING_.same_string (type, "image") or else
				STRING_.same_string (type, "password") or else
				STRING_.same_string (type, "radio") or else
				STRING_.same_string (type, "reset") or else
				STRING_.same_string (type, once_submit) or else
				STRING_.same_string (type, once_text)
			name_not_empty: name /= Void and then not name.is_empty
		do
			start_tag (once_input)
			set_attribute (once_type, type)
			set_attribute (once_name, name)
		end

	e_input is
		require
			valid_stop: is_started (once_input)
		do
			stop_tag
		end

	hidden (name, value: STRING) is
		require
			name_not_empty: name /= Void and then not name.is_empty
		do
			b_input ("hidden", name)
			set_attribute (once_value, value)
			e_input
		end

	b_button_submit (name, value: STRING) is
		require
			name_not_empty: name /= Void and then not name.is_empty
		do
			b_input (once_submit, name)
			set_attribute (once_value, value)
		end

	e_button_submit is
		require
			valid_stop: is_started (once_input)
		do
			e_input
		end

	button_submit (name, value: STRING) is
			-- Submit button.
		require
			name_not_empty: name /= Void and then not name.is_empty
		do
			b_button_submit (name, value)
			e_button_submit
		end

	b_button_reset is
		do
			start_tag (once_input)
			set_attribute (once_type, "reset")
		end

	e_button_reset is
		require
			valid_stop: is_started (once_input)
		do
			e_input
		end

	button_reset is
		do
			b_button_reset
			e_button_reset
		end

	b_checkbox (name, value: STRING) is
		require
			name_not_empty: name /= Void and then not name.is_empty
			have_value: value /= Void and not value.is_empty
		do
			b_input ("checkbox", name)
			set_attribute (once_value, value)
		end

	e_checkbox is
		do
			e_input
		end

	label (a_label, a_for: STRING) is
			-- Emit label tag `a_label' for a control with id `a_for'.
		require
			label_not_empty: a_label /= Void and then not a_label.is_empty
			for_not_empty: a_for /= Void and then not a_for.is_empty
			form_started: not is_fragment implies is_a_parent (once_form)
		do
			start_tag (once_label)
			set_attribute (once_for, a_for)
			add_data (a_label)
			stop_tag
		end

	b_radio (name, value: STRING) is
		require
			have_value: value /= Void and not value.is_empty
		do
			b_input ("radio", name)
			set_attribute (once_value, value)
		end

	e_radio is
		do
			e_input
		end

	b_select (name: STRING) is
		require
			form_started: not is_fragment implies is_a_parent (once_form)
		do
			start_tag (once_select)
			set_attribute (once_name, name)
		end

	e_select is
		require
			valid_stop: is_started (once_select)
		do
			stop_tag
		end

	b_option is
		do
			start_tag (once_option)
		end

	e_option is
		require
			valid_stop: is_started (once_option)
		do
			stop_tag
		end

	option (text: STRING) is
		do
			add_tag (once_option, text)
		end

	selected_option (choice: STRING) is
		do
			start_tag (once_option)
			set_attribute (once_selected, once_selected)
			add_data (choice)
			stop_tag
		end

	b_textarea (name: STRING) is
			-- Begin multiline input control.
		do
			start_tag (once_textarea)
			set_attribute (once_name, name)
		end

	e_textarea is
			-- End multiline input control.
		require
			valid_stop: is_started (once_textarea)
		do
			stop_tag
		end

	input_text (name: STRING; size: INTEGER; value: STRING) is
			-- Single line input.
		require
			form_started: not is_fragment implies is_a_parent (once_form)
			size_positive: size > 0
		do
			b_input_text (name, size, value)
			e_input_text
		end

	b_input_text (name: STRING; size: INTEGER; value: STRING) is
			-- Single line input.
		require
			form_started: not is_fragment implies is_a_parent (once_form)
			size_positive: size > 0
		do
			b_input (once_text, name)
			set_attribute (once_size, size.out)
			set_attribute (once_value, value)
		end

	e_input_text is
			-- End single line input.
		require
			valid_stop: is_started (once_input)
		do
			e_input
		end

	input_password (name: STRING; size: INTEGER; value: STRING) is
			-- Single line password input.
		require
			form_started: not is_fragment implies is_a_parent (once_form)
			size_positive: size > 0
		do
			b_input (once_password, name)
			set_attribute (once_size, size.out)
			set_attribute (once_value, value)
			e_input
		end


feature -- CSS style sheet support

	b_style is
			-- Start inline style.
		do
			start_tag ("style")
			set_attribute (once_type, "text/css")
		end

	e_style is
		require
			valid_stop: is_started ("style")
		do
			stop_tag
		end

	set_class (name: STRING) is
			-- set attribute class
		require
			valid_name: name /= Void and then not name.is_empty
		do
			set_attribute ("class", name)
		end

	set_style (an_inline_style: STRING) is
			-- Set the style attribute.
		require
			tag_started: is_tag_started
			inline_style_not_empty: an_inline_style /= Void and then not an_inline_style.is_empty
		do
			set_attribute (once_style, an_inline_style)
		end

	style_sheet (a_location, a_description, a_media: STRING) is
			-- Put in a link to refer to an external style sheet on disk.
			-- `a_media' is the intended destination medium for style
			-- information. It may be a single media descriptor or a
			-- comma-separated list. The default value for this attribute
			-- is "screen".
		require
			location_not_empty: a_location /= Void and then not a_location.is_empty
		do
			link (a_location, once_stylesheet, Void, mime_type_text_css, a_description, a_media)
		end

	alternate_style_sheet (a_location, a_description, a_media: STRING) is
			-- Put in a link to refer to an alternative style sheet.
			-- `a_media' is the intended destination medium for style
			-- information. It may be a single media descriptor or a
			-- comma-separated list. The default value for this attribute
			-- is "screen".
		require
			location_not_empty: a_location /= Void and then not a_location.is_empty
		do
			link (a_location, once_alternate_stylesheet, Void, mime_type_text_css, a_description, a_media)
		end


feature -- Link

	link (a_href, a_forward_link_types, a_backward_link_types, a_content_type, a_title, a_media: STRING) is
			-- Add a <link> element. This is used for document relationships.
		require
			in_head: is_started (once_head)
			href_not_empty: a_href /= Void and then not a_href.is_empty
			content_type_not_empty: a_content_type /= Void and then not a_content_type.is_empty
		do
			start_tag (once_link)
			if
				a_forward_link_types /= Void and then
				not a_forward_link_types.is_empty
			then
				set_attribute (once_rel, a_forward_link_types)
			end
			if
				a_backward_link_types /= Void and then
				not a_backward_link_types.is_empty
			then
				set_attribute (once_rev, a_backward_link_types)
			end
			set_attribute (once_type, a_content_type)
			set_attribute (once_href, a_href)
			if a_title /= Void then
				set_attribute (once_title, a_title)
			end
			if a_media /= Void and then not a_media.is_empty then
				set_attribute (once_media, a_media)
			end
			stop_tag
		end


feature -- Divisions

	b_div is
			-- Start a <div> tag.
		do
			start_tag (once_div)
		end

	e_div is
			-- Stop the <div> tag.
		require
			div_started: is_started (once_div)
		do
			stop_tag
		end

	b_span is
			-- Start a <span> tag.
		do
			start_tag (once_span)
		end

	e_span is
			-- Stop the <span> tag.
		require
			span_started: is_started (once_span)
		do
			stop_tag
		end


feature -- JavaScript support

	b_external_script (a_src: STRING; a_defer_execution: BOOLEAN) is
			-- Include external script. If `a_defer_execution' then
			-- browser may defer execution of script until page is
			-- rendered. This can improve performance.
		require
			src_not_empty: a_src /= Void and then not a_src.is_empty
		do
			start_tag (once_script)
			set_attribute (once_src, a_src)
			if a_defer_execution then
				set_attribute (once_defer, once_defer)
			end
		end

	b_script is
			-- Start JavaScript.
		do
			start_tag (once_script)
			-- According to Douglas Crockford, you should leave this out,
			-- but according to the spec, it should be specified.
			add_attribute (once_type, mime_type_text_javascript);
		end

	e_script is
		require
			script_started: is_started (once_script)
		do
			stop_tag
		end

	external_script (a_src: STRING; a_defer_execution: BOOLEAN) is
			-- Include external script. If `a_defer_execution' then
			-- browser may defer execution of script until page is
			-- rendered. This can improve performance.
		require
			src_not_empty: a_src /= Void and then not a_src.is_empty
		do
			b_external_script (a_src, a_defer_execution)
			e_script
		end

	set_onclick (an_action: STRING) is
		require
			tag_started: is_tag_started
		do
			set_attribute (once_onclick, an_action)
		end


feature -- HTML tag names

	once_a: STRING is "a"
	once_blockquote: STRING is "blockquote"
	once_body: STRING is "body"
	once_br: STRING is "br"
	once_div: STRING is "div"
	once_form: STRING is "form"
	once_h1: STRING is "h1"
	once_h2: STRING is "h2"
	once_h3: STRING is "h3"
	once_head: STRING is "head"
	once_html: STRING is "html"
	once_img: STRING is "img"
	once_input: STRING is "input"
	once_label: STRING is "label"
	once_link: STRING is "link"
	once_meta: STRING is "meta"
	once_option: STRING is "option"
	once_p: STRING is "p"
	once_pre: STRING is "pre"
	once_script: STRING is "script"
	once_select: STRING is "select"
	once_span: STRING is "span"
	once_table: STRING is "table"
	once_td: STRING is "td"
	once_textarea: STRING is "textarea"
	once_tr: STRING is "tr"
	once_title: STRING is "title"


feature {NONE} -- Attribute names

	once_alt: STRING is "alt"
	once_clear: STRING is "clear"
	once_content: STRING is "content"
	once_defer: STRING is "defer"
	once_http_equiv: STRING is "http-equiv"
	once_for: STRING is "for"
	once_href: STRING is "href"
	once_id: STRING is "id"
	once_media: STRING is "media"
	once_name: STRING is "name"
	once_onclick: STRING is "onclick"
	once_rel: STRING is "rel"
	once_rev: STRING is "rev"
	once_size: STRING is "size"
	once_src: STRING is "src"
	once_style: STRING is "style"
	once_type: STRING is "type"
	once_value: STRING is "value"


feature -- Attribute values

	once_selected: STRING is "selected"
	once_submit: STRING is "submit"
	once_text: STRING is "text"


feature {NONE} -- Other once strings

	once_all: STRING is "all"
	once_alternate_stylesheet: STRING is "alternate stylesheet"
	once_password: STRING is "password"
	once_stylesheet: STRING is "stylesheet"


feature {NONE} -- URIs

	xhtml_uri: STRING is "http://www.w3.org/1999/xhtml"


end
