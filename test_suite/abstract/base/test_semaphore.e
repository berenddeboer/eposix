indexing

	description: "Test POSIX semaphore classes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_SEMAPHORE


inherit

	TS_TEST_CASE


feature

	test_unnamed is
			-- Test portable unnamed semaphores.
		local
			unnamed,
			unnamed2: EPX_UNNAMED_SEMAPHORE
		do
			-- Create an unnamed, unshared semaphore.
			create unnamed.create_unshared (1)
			create unnamed2.create_unshared (4)

			-- Lock the semaphore
			unnamed.acquire
			assert ("Locked.", unnamed.is_locked)

			-- Unlock the semaphore
			unnamed.release

			-- Attempt to lock the semaphore
			unnamed.attempt_acquire
			unnamed.release

			-- Destroy the semaphore
			unnamed.close
			unnamed2.close
		end

	test_named is
			-- Create a named semaphore.
			-- Not supported by Linux/FreeBSD
		local
			semaphore,
			semaphore2: EPX_NAMED_SEMAPHORE
		do
			if is_windows then

				-- Create an unacquired semaphore
				create semaphore.create_nonexclusive ("berend", 1)

				-- Lock it
				semaphore.acquire
				assert ("Locked", semaphore.is_locked)

				-- Really locked?
				create semaphore2.create_nonexclusive ("berend", 2)
				semaphore2.attempt_acquire
				assert ("Acquisition failed", not semaphore2.is_locked)

				semaphore.release

				-- Really released?
				semaphore2.attempt_acquire
				assert ("Acquisition successful", semaphore2.is_locked)

				-- Release handle
				semaphore.close
				semaphore2.close

				-- Create a semaphore in the acquired state
				create semaphore.create_nonexclusive ("berend2", 0)

				-- Really locked?
				create semaphore2.open ("berend2")
				semaphore2.attempt_acquire
				assert ("Acquisition failed", not semaphore2.is_locked)

				-- Release and next lock it
				semaphore.release

				-- Really released?
				semaphore2.attempt_acquire
				assert ("Acquisition successful", semaphore2.is_locked)
				semaphore2.release

				semaphore.attempt_acquire
				assert ("Acquisition successful", semaphore.is_locked)

				-- Release handle
				semaphore.close

			end
		end


feature {NONE} -- Implementation

	is_windows: BOOLEAN is
			-- Are we running on the Windows platform?
		external "C"
		end


end
