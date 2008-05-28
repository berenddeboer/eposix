class	EX_SMTP2

create

	make

feature

	make is
		local
			type_names: expanded EPX_MIME_TYPE_NAMES
			message: EPX_MIME_EMAIL
			mail: EPX_SMTP_MAIL
			smtp: EPX_SMTP_CLIENT
		do
			create message.make
			message.header.set_from ("Berend de Boer", "berend@pobox.com")
			message.header.set_to ("Berend de Boer", "berend@pobox.com")
			message.header.set_subject ("EX_SMTP2")
			message.header.set_content_type_text_html_utf8
			message.create_singlepart_body
			message.text_body.append_string (html)
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
  <title>EX_SMTP2</title>
</head>
<body>
  <h1>Hello</h1>
  <p>HTML email, brought to you by eposix.</p>
</body>
]"

end
