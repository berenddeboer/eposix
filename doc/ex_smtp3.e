class	EX_SMTP3

create

	make

feature

	make is
		local
			type_names: expanded EPX_MIME_TYPE_NAMES
			message: EPX_MIME_EMAIL
			ct: EPX_MIME_FIELD_CONTENT_TYPE
			text_part,
			html_part: EPX_MIME_PART
			mail: EPX_SMTP_MAIL
			smtp: EPX_SMTP_CLIENT
		do
			create message.make
			message.header.set_from ("Berend de Boer", "berend@pobox.com")
			message.header.set_to ("Berend de Boer", "berend@pobox.com")
			message.header.set_subject ("EX_SMTP3")
			create ct.make_multipart (
				type_names.mime_subtype_alternative,
				"----=_my-boundary----")
			message.header.add_field (ct)
			message.create_multipart_body

			text_part := message.multipart_body.new_part
			text_part.header.set_content_type (
				type_names.mime_type_text, type_names.mime_subtype_plain,
				"ISO-8859-1")
			text_part.create_singlepart_body
			text_part.text_body.append_string (text)

			html_part := message.multipart_body.new_part
			html_part.header.set_content_type (
				type_names.mime_type_text, type_names.mime_subtype_html,
				"ISO-8859-1")
			html_part.create_singlepart_body
			html_part.text_body.append_string (html)

			create mail.make (sender_mailbox, recipient_mailbox, message)
			create smtp.make (smtp_server_name)
			smtp.open
			smtp.ehlo (my_domain)
			smtp.mail (mail)
			smtp.quit
			smtp.close
		end

	my_domain: STRING is "nederware.nl"

	smtp_server_name: STRING is "localhost"

	sender_mailbox: STRING is "berend"

	recipient_mailbox: STRING is "berend"

	html: STRING is "[
<html>
<head>
  <title>EX_SMTP3</title>
</head>
<body>
  <h1>Hello</h1>
  <p>HTML email, brought to you by eposix.</p>
</body>
]"

	text: STRING is "Hello%N%NHTML email, brought to you by eposix."

end
