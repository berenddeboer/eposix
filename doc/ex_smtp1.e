class	EX_SMTP1

inherit

	EPX_CURRENT_PROCESS

	EPX_SYSTEM

create

	make

feature

	make is
		local
			message: EPX_MIME_EMAIL
			mail: EPX_SMTP_MAIL
			smtp: EPX_SMTP_CLIENT
			sender_mailbox: STRING
			recipient_mailbox: STRING
		do
			create message.make
			message.header.set_from ("Berend de Boer", "berend@pobox.com")
			message.header.set_to ("Berend de Boer", "berend@pobox.com")
			message.header.set_subject ("EX_SMTP1")
			message.create_singlepart_body
			message.text_body.append_string ("Hello!")
			sender_mailbox := effective_user_name
			recipient_mailbox := effective_user_name
			create mail.make (sender_mailbox, recipient_mailbox, message)
			create smtp.make (smtp_server_name)
			smtp.open
			smtp.ehlo (node_name) -- `node_name' is usually your domain name
			smtp.mail (mail)
			smtp.quit
			smtp.close
		end

	smtp_server_name: STRING is "localhost"
			-- Should work on every Unix system

end
