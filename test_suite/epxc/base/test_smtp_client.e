indexing

	description:

		"Test for eposix SMTP client"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	TEST_SMTP_CLIENT


inherit

	TS_TEST_CASE


feature -- Tests

	test_open is
		local
			smtp: EPX_SMTP_CLIENT
		do
			create smtp.make ("localhost")
			smtp.open
			assert ("Connected", smtp.is_open)
			assert ("Successful connect", smtp.is_positive_completion_reply)
			smtp.quit
			smtp.close
		end

	test_sending_email is
		local
			smtp: EPX_SMTP_CLIENT
			message: EPX_MIME_EMAIL
			mail: EPX_SMTP_MAIL
		do
			create smtp.make ("localhost")
			smtp.open
			assert ("Connected", smtp.is_open)
			assert ("Successful connect", smtp.is_positive_completion_reply)
			--smtp.ehlo ("nederware.nl")
			smtp.ehlo ("test.test")
			assert ("identifier", smtp.is_client_identified)
			debug ("test")
				print ("Largest message can be ")
				print (smtp.max_message_size)
				print (" bytes.%N")
			end
			create message.make
			message.create_singlepart_body
			message.header.set_from ("Berend de Boer", "berend@pobox.com")
			message.header.set_to ("Berend de Boer", "berend@acm.org")
			message.header.set_subject ("TEST_SMTP_CLIENT")
			message.text_body.append_string ("Hello!%R%N.%R%N.hello.%R%N")
			create mail.make ("berend", "berend", message)
			smtp.mail (mail)
			smtp.quit
			smtp.close
		end

	test_various is
			-- Test help, verify and such.
		local
			smtp: EPX_SMTP_CLIENT
		do
			create smtp.make_with_port ("localhost", 25)
			smtp.open
			assert ("Connected", smtp.is_open)
			assert ("Successful connect", smtp.is_positive_completion_reply)
			smtp.help
			smtp.noop
			smtp.verify ("berend")
			smtp.expand ("berend")
			smtp.quit
			smtp.close
		end

	test_multiple_recipients is
		local
			smtp: EPX_SMTP_CLIENT
			message: EPX_MIME_EMAIL
			mail: EPX_SMTP_MAIL
		do
			create smtp.make ("localhost")
			smtp.open
			assert ("Connected", smtp.is_open)
			assert ("Successful connect", smtp.is_positive_completion_reply)
			smtp.ehlo ("test.test")
			assert ("identifier", smtp.is_client_identified)
			create message.make
			message.create_singlepart_body
			message.header.set_from ("Berend de Boer", "berend@pobox.com")
			message.header.set_to ("Berend de Boer", "berend@acm.org")
			message.header.set_subject ("TEST_SMTP_CLIENT.test_multiple_recipients")
			message.text_body.append_string ("Hi Berend, did this work?%R%N")
			create mail.make ("berend", "berend@pobox.com", message)
			mail.add_recipient ("berend@acm.org")
			mail.add_recipient ("berend@xsol.com")
			smtp.mail (mail)
			smtp.quit
			smtp.close
		end


end
