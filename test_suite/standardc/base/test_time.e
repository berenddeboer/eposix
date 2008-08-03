indexing

	description: "Test Standard C time class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	TEST_TIME


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	STDC_CURRENT_PROCESS


feature -- Time tests

	test_various is
		local
			time1,
			time2,
			time3,
			time4: STDC_TIME
		do
			create time1.make_from_now
			time1.to_local
			debug
				print_time (time1)
			end
			time1.to_utc
			debug
				print_time (time1)
			end
			create time2.make_utc_time (0, 0, 0)
			debug
				print_time (time2)
			end
			create time2.make_date_time (1980, 10, 31, 6, 55, 0)
			time2.to_local
			assert_integers_equal ("Year.", 1980, time2.year)
			assert_integers_equal ("Month.", 10, time2.month)
			assert_integers_equal ("Day.", 31, time2.day)
			assert_integers_equal ("Hour.", 6, time2.hour)
			assert_integers_equal ("Minute.", 55, time2.minute)
			debug
				print_time (time2)
			end

			assert ("time2 is less than time1", time2 < time1);

			create time3.make_date_time (1980, 10, 31, 7, 55, 0)
			time4 := time3 - time2
			time4.to_utc
			assert_integers_equal ("1 hour difference.", 1, time4.hour)

			create time1.make_from_now
			time1.to_local
			time1.set_dst_to_current
			time1.set_dst_to_none
			time1.set_dst_in_effect
			assert ("Daylight savings is in effect.", time1.is_daylight_savings_in_effect)

		end

	test_utc_make is
		local
			time: STDC_TIME
		do
			create time.make_utc_date_time (2003, 9, 12, 0, 0, 0)
			create time.make_utc_date_time (1980, 1, 1, 10, 0, 5)
			if time.minimum_year = 1970 then
				create time.make_utc_date_time (1970, 1, 1, 0, 0, 0)
				assert_integers_equal ("Set to epoch.", 0, time.value)
			end
			create time.make_utc_time (0, 0, 0)
			if time.minimum_year = 1970 then
				assert_integers_equal ("Set to epoch.", 0, time.value)
			end
			create time.make_utc_time (0, 55, 0)
			if time.minimum_year = 1970 then
				assert_integers_equal ("Set to number of seconds.", 55 * 60, time.value)
			end
		end

	test_valid_time is
		local
			time: STDC_TIME
			a, b: INTEGER
		do
			create time.make_from_now
			assert ("Invalid date detected", not time.is_valid_date (2038, 1, 20))
			assert ("But last date is valid", time.is_valid_date (2038, 1, 19))
			a := 11 * 3600 + 14 * 60 + 7
			b := 03 * 3600 + 14 * 60 + 8
			assert ("Invalid time detected", not time.is_valid_date_and_time (2038, 1, 19, 11, 14, 7))
		end


feature {NONE} -- Implementation

	print_time (time: STDC_TIME) is
		do
			print ("Seconds since January 1, 1970 (1980?): ")
			print (time.value)
			print ("%N")
			print ("Date: ")
			print (time.year)
			print ("-")
			print (time.month)
			print ("-")
			print (time.day)
			print (" ")
			print (time.hour)
			print (":")
			print (time.minute)
			print (":")
			print (time.second)
			print ("%N")
			print ("Weekday: ")
			print (time.weekday)
			print ("%N")
			print ("Day of the year: ")
			print (time.day_of_year)
			print ("%N")
			print ("default string: ")
			print (time.default_format)
			print ("%N")
			print ("local date: ")
			print (time.local_date_string)
			print ("%N")
			print ("local time: ")
			print (time.local_time_string)
			print ("%N")
			print ("Weekday: ")
			print (time.weekday_name)
			print (" (")
			print (time.short_weekday_name)
			print (")%N")
			print ("Month: ")
			print (time.month_name)
			print (" (")
			print (time.short_month_name)
			print (")%N")
			print ("%N")
		end


end
