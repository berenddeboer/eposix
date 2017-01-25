class EX_SMTP5

inherit

	EPX_FILE_SYSTEM

create

	make

feature

	make
		local
			message: EPX_MIME_EMAIL
			ct: EPX_MIME_FIELD_CONTENT_TYPE
			cd: EPX_MIME_FIELD_CONTENT_DISPOSITION
			text_part,
			file_part: EPX_MIME_PART
			s: STRING
		do
			create message.make
			message.header.set_from ("Berend de Boer", "berend@pobox.com")
			message.header.set_to ("Berend de Boer", "berend@pobox.com")
			message.header.set_subject ("EX_SMTP5")
			create ct.make_multipart (
				type_names.mime_subtype_mixed,
				"----=_my-boundary----")
			message.header.add_field (ct)
			message.create_multipart_body

			text_part := message.multipart_body.new_part
			text_part.header.set_content_type (
				type_names.mime_type_text, type_names.mime_subtype_plain,
				"ISO-8859-1")
			text_part.create_singlepart_body
			text_part.text_body.append_string ("Here is the file.")

			file_part := message.multipart_body.new_part
			file_part.header.set_content_type (
				type_names.mime_type_application, type_names.mime_subtype_pdf, Void)
			create cd.make_name ("attachment", filename)
			file_part.header.add_field (cd)
			file_part.header.content_type.set_parameter ("name", filename)
			file_part.create_base64_body
			file_part.text_body.append_string (file_content_as_string (filename))

			send_message (message)
		end

	send_message (a_message: EPX_MIME_EMAIL)
		local
			mail: EPX_SMTP_MAIL
			smtp: EPX_SMTP_CLIENT
		do
			create mail.make (sender_mailbox, recipient_mailbox, a_message)
			create smtp.make (smtp_server_name)
			smtp.open
			smtp.ehlo (my_domain)
			smtp.mail (mail)
			smtp.quit
			smtp.close
		end

	my_domain: STRING = "example.com"

	smtp_server_name: STRING = "localhost"

	sender_mailbox: STRING = "berend"

	recipient_mailbox: STRING = "berend@bmach"

	type_names: EPX_MIME_TYPE_NAMES
		do
			create Result
		end

	filename: STRING = "test_bon.pdf"

end
