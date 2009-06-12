indexing

	description: "Test POSIX semaphore classes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

deferred class

	TEST_P_SEMAPHORE


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_BASE

	PAPI_SEMAPHORE


feature

	test_unnamed is
		local
			unnamed,
			unnamed2: POSIX_UNNAMED_SEMAPHORE
		do
			-- Create an unnamed, unshared semaphore.
			create unnamed.create_unshared (1)
			create unnamed2.create_unshared (4)

			assert_equal ("Value as given.", 1, unnamed.value)
			assert_equal ("Value as given.", 4, unnamed2.value)

			-- Lock the semaphore
			unnamed.acquire

			assert_equal ("Locked.", 0, unnamed.value)

			-- Unlock the semaphore
			unnamed.release

			assert_equal ("Unlocked.", 1, unnamed.value)

			-- Attemt lock the semaphore
			unnamed.attempt_acquire
			unnamed.release

			-- Close the semaphore
			unnamed.close
			unnamed2.close
		end

	test_named is
			-- Create a named semaphore.
		local
			--named: POSIX_NAMED_SEMAPHORE
		do
			-- not supported by Linux/FreeBSD
			--create named.create_exclusive ("berend", 0)
		end

	test_acquire is
			-- Attempt to acquire a semaphore for 3 seconds.
		local
			unnamed: POSIX_UNNAMED_SEMAPHORE
			cmd_acquire: POSIX_TIMED_ACQUIRE
			signal: POSIX_SIGNAL
		do
			-- Some tests if SIGALRM generates an exception.
			create signal.make (SIGNAL_ALARM)
			if signal.is_ignored then
				debug ("test")
					print ("Signal is ignored.%N")
				end
			end
			if signal.is_defaulted then
				debug ("test")
					print ("Signal is defaulted.%N")
				end
			end

			-- Timed acquire
			create unnamed.create_unshared (1)
			assert ("Not acquired.", not unnamed.is_acquired)
			-- Acquire semaphore outside of object
			safe_call (posix_sem_wait (unnamed.handle))
			create cmd_acquire.make (3, unnamed)
			if signal.is_ignored or else signal.is_defaulted then
				print ("!! Cannot test timed acquire, because alarm does not cause an exception.%N")
			else
				-- No exception on Alarm with FreeBSD
				-- Test works on Linux though
				-- Oops, acquire fails because it is already acquired because of initial value 0?
				assert ("Acquire timed out.", not cmd_acquire.execute)
			end
			safe_call (posix_sem_post (unnamed.handle))
			unnamed.close
		end

end
