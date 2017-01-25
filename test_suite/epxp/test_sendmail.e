note

	description: "Test sending mail through sendmail."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_SENDMAIL


inherit

	TS_TEST_CASE


feature -- Tests

	test_basic_email
		local
			sendmail: EPX_SENDMAIL
		do
			create sendmail.make
			sendmail.message.header.set_subject (subject)
			sendmail.message.header.set_to (to_name, to_email)
			sendmail.message.header.set_to (to_name, to_email)
			sendmail.message.header.set_from (from_name, from_email)
			sendmail.message.create_singlepart_body
			sendmail.message.text_body.append_string (body_text)
			sendmail.send
		end


feature {NONE} -- Implementation

	body_text: STRING = "Hi Berend,%N%NNice testing?%N"

	subject: STRING = "Test"

	to_name: STRING = "Berend de Boer"
	to_email: STRING = "berend"

	from_name: STRING = "Berend de Boer"
	from_email: STRING = "berend@pobox.com"

end
