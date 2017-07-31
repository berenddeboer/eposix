note

	description: "Test creating RFC 2822 email."

	author: "Berend de Boer"


deferred class

	TEST_EMAIL


inherit

	TS_TEST_CASE

feature -- Tests

	test_basic_email
		local
			email: EPX_MIME_EMAIL
		do
			create email.make
			email.header.set_subject (subject)
			assert_equal ("Subject set", subject, email.header.subject)
			email.header.set_subject (subject2)
			assert_equal ("Subject set", subject2, email.header.subject)
			email.header.set_to (to_name, to_email)
			assert ("Name set", email.header.to.has_substring (to_name))
			email.header.set_to (to_name, to_email)
			assert ("Name set", email.header.to.has_substring (to_email))
			email.header.set_from (from_name, from_email)
			assert ("Name set", email.header.from_.has_substring (from_email))
			email.header.set_reply_to (Void, from_email)
			assert ("Name set", email.header.reply_to.has_substring (from_email))
			email.create_singlepart_body
			if attached email.text_body as text_body then
				text_body.append_string (body_text)
			end
			print ("=========================%N")
			print (email.as_string)
			print ("=========================%N")
		end


feature {NONE} -- Implementation

	body_text: STRING = "Hi Berend,%N%NNice testing?%N"

	subject: STRING = "Test"
	subject2: STRING = "Hello World"

	to_name: STRING = "Berend de Boer"
	to_email: STRING = "berend@pobox.com"

	from_name: STRING = "Berend de Boer"
	from_email: STRING = "berend@pobox.com"

end
