indexing

	description: "Test Posix time class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

deferred class

	TEST_P_TIME


inherit

	TS_TEST_CASE


feature -- Tests

	test_all is
			-- Tests thanks to Jacques Bouchard.
		local
			t1, t2: POSIX_TIME
		do
			create t1.make_from_now
			create t2.make_from_unix_time (t1.value)
			
			print ("t1: " + t1.value.out + "%N")
			print ("t2: " + t2.value.out + "%N")
			assert ("Times are not less than.", not (t1 < t2))
			
			print ("t1: " + t1.value.out + "%N")
			print ("t2: " + t2.value.out + "%N")
			assert ("Times are equal.", t1.is_equal (t2))

			print ("t1: " + t1.value.out + "%N")
			print ("t2: " + t2.value.out + "%N")
			assert ("Times are not greater than.", not (t1 > t2))

			print ("t1: " + t1.value.out + "%N")
			print ("t2: " + t2.value.out + "%N")
			assert_equal ("No seconds difference.", 0, (t1 - t2).value)
		end


end
