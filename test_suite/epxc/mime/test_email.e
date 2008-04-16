indexing

	description: "Test creating RFC 2822 email."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_EMAIL


inherit

	TS_TEST_CASE

feature -- Tests

	test_basic_email is
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
			email.text_body.append_string (body_text)
			print ("=========================%N")
			print (email.as_string)
			print ("=========================%N")
		end


feature {NONE} -- Implementation

	body_text: STRING is "Hi Berend,%N%NNice testing?%N"

	subject: STRING is "Test"
	subject2: STRING is "Hello World"

	to_name: STRING is "Berend de Boer"
	to_email: STRING is "berend@pobox.com"

	from_name: STRING is "Berend de Boer"
	from_email: STRING is "berend@pobox.com"

end
