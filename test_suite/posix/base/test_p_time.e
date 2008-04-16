indexing

	description: "Test Posix time class."

	author: "Berend de Boer"
	date: "$Date: 2003/12/04 $"
	revision: "$Revision: #1 $"

deferred class

	TEST_P_TIME


inherit

	TS_TEST_CASE


feature -- Tests

	test_all is
			-- tests thanks to Jacques Bouchard
		local
			t1, t2: POSIX_TIME
		do
			create t1.make_from_now
			create t2.make_from_unix_time (t1.value)

			assert ("Times are not less than.", not (t1 < t2))
			assert ("Times are equal.", t1.is_equal (t2))
			assert ("Times are not greater than.", not (t1 > t2))

			assert_equal ("No seconds difference.", 0, (t1 - t2).value)
		end


end
