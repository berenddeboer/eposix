indexing

	description: "Test Standard C current process class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_CURRENT_PROCESS


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	STDC_CURRENT_PROCESS


feature -- Tests

	test_various is
		do
			debug
				print ("A random number: ")
				print (random)
				print ("%N")
			end
			assert ("Have random number.", random >= 0)

			set_random_seed (5142)
			debug
				print ("Another random number: ")
				print (random)
				print ("%N")
			end

			debug
				print ("Max random number: ")
				print (RAND_MAX)
				print ("%N")
			end
			assert ("Have max random number.", RAND_MAX > 0)

			debug
				print ("Current locale: ")
				print (locale)
				print ("%N")
			end
			set_c_locale
			set_native_locale

			debug
				print ("Decimal point: ")
				print (numeric_format.decimal_point)
				print ("%N")
				print ("Int. currency sumbol: ")
				print (numeric_format.international_currency_symbol)
				print ("%N")
				print ("Local currency sumbol: ")
				print (numeric_format.local_currency_symbol)
				print ("%N")
				print ("Int. digits after decimal point: ")
				print (numeric_format.international_digits)
				print ("%N")
				print ("Digits after decimal point: ")
				print (numeric_format.local_digits)
				print ("%N")
			end
		end

end
