indexing

	description: "Test POSIX daemon class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

deferred class

	TEST_P_DAEMON


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions,
			execute as test_execute
		end

	POSIX_DAEMON

	POSIX_FILE_SYSTEM


feature -- the parent

	test_detach is
		do
			remove_file ("/tmp/mydaemon")
			detach
			assert ("Got some pid.", last_child_pid > 0)
			sleep (7)
			assert ("File created.", is_existing ("/tmp/mydaemon"))
			remove_file ("/tmp/mydaemon")
		end


feature -- the daemon

	execute is
		local
			file: POSIX_TEXT_FILE
			now: POSIX_TIME
		do
			create file.create_write ("/tmp/mydaemon")
			file.set_no_buffering
			file.put ("My pid: ")
			file.put (pid)
			file.put_nl
			create now.make_from_now
			now.to_local
			file.put_string (now.local_time_string)
			file.put_newline
			sleep (2)
			now.make_from_now
			now.to_local
			file.put_string (now.local_time_string)
			file.put_newline
			file.close
		end

end
