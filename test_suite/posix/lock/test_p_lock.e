indexing

	description: "Test Posix file locking."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

deferred class

	TEST_P_LOCK

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions,
			execute as test_execute
		end

	POSIX_FORK_ROOT
		export
			{NONE} all
		end

	POSIX_FILE_SYSTEM
		export
			{NONE} all
		end

	POSIX_SYSTEM
		export
			{NONE} all
		end


feature -- Tests

	test_lock is
		do
			if system_name.substring_index ("CYGWIN", 1) = 0 then
				do_test_lock
			else
				print ("Cygwin does not implement locking.%N")
			end
		end


feature {NONE} -- Implementation

	do_test_lock is
			-- Testing Posix file locking interface.
		local
			lock,
			some_lock: POSIX_LOCK
			fd: POSIX_FILE_DESCRIPTOR
		do
			-- Create a file.
			create fd.create_read_write ("test.berend")
			fd.close_on_execute
			fd.write_string ("Test")

			-- See if there is a read lock.
			create lock.make
			lock.set_allow_read
			some_lock := fd.get_lock (lock)
			assert ("There is no lock.", some_lock = Void)

			-- Create an exclusive lock.
			lock.set_allow_none
			lock.set_start (0)
			lock.set_length (4)
			fd.set_lock (lock)

			fork (Current)

			-- Wait for child to terminate.
			wait

			fd.close

			unlink ("test.berend")
		end


feature -- forked child

	execute is
		local
			fd: POSIX_FILE_DESCRIPTOR
			lock,
			some_lock: POSIX_LOCK
		do
			create fd.open_read ("test.berend")

			-- See if there is a lock.
			create lock.make
			lock.set_allow_read
			lock.set_start (2)
			lock.set_length (2)
			some_lock := fd.get_lock (lock)
			assert ("There is a lock.", some_lock /= Void)
			debug
				print ("Locked by: ")
				print (some_lock.pid)
				print ("%N")
				print ("Lock starts at: ")
				print (some_lock.start)
				print ("%N")
			end

			fd.close
		end


end
