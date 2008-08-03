indexing

	description: "Test common system class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

deferred class

	TEST_SYSTEM

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	STDC_SYSTEM

feature -- Tests

	test_all is
		do
			if not is_shell_available then
				-- Fails on BeOS for some reasons.
				print ("Shell is not available.%N")
			end
			assert ("Clocks per second is set.", clocks_per_second > 0)
			if is_big_endian then
				print ("This machine has big endian byte ordering.%N")
			else
				print ("This machine has small endian byte ordering.%N")
			end
		end

end
