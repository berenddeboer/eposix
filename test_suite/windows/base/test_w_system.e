indexing

	description:

		"Test Windows system class."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_W_SYSTEM


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	WINDOWS_SYSTEM


feature -- Tests

	test_clock is
			-- Test high performance timers.
		local
			i1, i2: INTEGER_64
		do
			print ("Performance frequency: ")
			print (performance_frequency)
			print ("%N")
			i1 := performance_counter
			print ("Performance counter: ")
			print (i1.out)
			print ("%N")
			i2 := performance_counter
			print ("It took  ")
			print ((i2 - i1).out)
			print (" (")
			print (((i2 - i1) / performance_frequency).out)
			print ("s) counts to print this.%N")
		end


end
