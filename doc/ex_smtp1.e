class	EX_SMTP1

creation

	make

feature

	make is
		local
			message: EPX_MIME_EMAIL
			mail: EPX_SMTP_MAIL
			smtp: EPX_SMTP_CLIENT
		do
			create message.make
			message.header.set_from ("Berend de Boer", "berend@pobox.com")
			message.header.set_to ("Berend de Boer", "berend@pobox.com")
			message.header.set_subject ("EX_SMTP1")
			message.create_singlepart_body
			message.text_body.append_string ("Hello!")
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

end
