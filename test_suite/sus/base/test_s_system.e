indexing

	description: "Test SUS system class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_S_SYSTEM

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	SUS_SYSTEM

	SUS_CURRENT_PROCESS


feature -- Tests

	test_various is
		do
			assert ("Have host name.", not host_name.is_empty)
			debug ("test")
				print ("host name: ")
				print (host_name)
				print ("%N")
			end
		end

	test_clock is
			-- Test real time clock functions.
		local
			time,
			time2,
			time_diff,
			nanoseconds: SUS_TIME
		do
			if have_realtime_clock then
				assert ("Have real-time clock.",  have_realtime_clock)
				time := real_time_clock
				assert ("Have clock.", time /= Void)
				debug ("test")
					print ("Seconds: ")
					print (time.value)
					print ("%N")
					print ("Nanoseconds: ")
					print (time.nano_value)
					print ("%N")
				end
				millisleep (1)
				time2 := real_time_clock
				time_diff := time2 - time
				debug ("test")
					print ("Difference in seconds: ")
					print (time_diff.value)
					print ("%N")
					print ("Difference in nanoseconds: ")
					print (time_diff.nano_value)
					print ("%N")
				end
				assert_not_equal ("Time passed.", time, time2)
				assert ("time2 is past time.", time2 > time)

				create nanoseconds.make_from_nano_time (0, 1)
				time := real_time_clock
				-- Sleep first, creates scratch buffer, so might be slower
				nanosleep (nanoseconds)
				time := real_time_clock
				-- Perhaps second sleep gives us a better resolution?
				-- We use 1 nanosecond, but the resolution is usually 1
				-- microsecond. So we sleep at least that and probably more.
				nanosleep (nanoseconds)
				time2 := real_time_clock
				time_diff := time2 - time
				debug ("test")
					print ("Sleep in seconds: ")
					print (time_diff.value)
					print ("%N")
					print ("Sleep in nanoseconds: ")
					print (time_diff.nano_value)
					print ("%N")
				end
				assert_not_equal ("Time passed.", time, time2)
				assert ("time2 is past time.", time2 > time)

				time := real_time_clock_resolution
				assert ("Have resolution.", time /= Void)
				debug ("test")
					print ("Resolution in seconds: ")
					print (time.value)
					print ("%N")
					print ("Resolution in nanoseconds: ")
					print (time.nano_value)
					print ("%N")
				end
			else
				print ("No real-time clock, checks skipped.%N")
			end
		end


end
