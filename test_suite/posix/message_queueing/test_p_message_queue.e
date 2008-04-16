indexing

	description: "Test POSIX message queue."

  author: "Berend de Boer"
	date: "$Date: 2007/02/06 $"
	revision: "$Revision: #3 $"

deferred class

	TEST_P_MESSAGE_QUEUE

inherit

	TS_TEST_CASE

	POSIX_SYSTEM

feature

	test_all is
		do
			if supports_message_passing then
				print ("Message passing supported.%N")
			else
				print ("!! Message passing not supported.%N")
			end
		end

end
