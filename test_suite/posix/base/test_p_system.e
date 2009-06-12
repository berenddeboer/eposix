indexing

	description: "Test POSIX system class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_P_SYSTEM

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_SYSTEM

feature

	test_methods is
		do
			print ("Begin test system.%N")

			print ("sysname      : ")
			print (system_name)
			print (".%N")
			print ("nodename     : ")
			print (node_name)
			print (".%N")
			print ("release      : ")
			print (release)
			print (".%N")
			print ("version      : ")
			print (version)
			print (".%N")
			print ("machine      : ")
			print (machine)
			print (".%N%N")

			print ("arg_max      : ")
			print (max_argument_size)
			print (".%N")
			print ("child_max    : ")
			print (child_max)
			print (".%N")
			print ("clock_ticks  : ")
			print (clock_ticks)
			print (".%N")
			print ("max_input    : ")
			print (MAX_INPUT)
			print (".%N")
			print ("name_max     : ")
			print (NAME_MAX)
			print (".%N")
			print ("ngroups_max  : ")
			print (ngroups_max)
			print (".%N")
			print ("open_max     : ")
			print (max_open_files)
			print (".%N")
			print ("page_size    : ")
			print (page_size)
			print (".%N")
			print ("path_max     : ")
			print (PATH_MAX)
			print (".%N")
			print ("pipe_buf     : ")
			print (PIPE_BUF)
			print (".%N")
			print ("stream_max   : ")
			print (max_open_streams)
			print (".%N")
			print ("ssize_max    : ")
			print (SSIZE_MAX)
			print (".%N")
			print ("tzname_max   : ")
			print (max_time_zone_name)
			print (".%N")
			print ("job_control  : ")
			print (has_job_control)
			print (".%N")
			print ("saved_ids    : ")
			print (has_saved_ids)
			print (".%N")
			print ("posix_version: ")
			print (posix_version)
			print (".%N")

			print_supports (supports_asynchronous_io, "Asynchronous io")
			print_supports (supports_file_synchronization, "File synchronization")
			print_supports (supports_memory_mapped_files, "Memory mapped files")
			print_supports (supports_memory_locking, "Memory locking")
			print_supports (supports_memlock_range, "Memory range locking")
			print_supports (supports_memory_protection, "Memory protection")
			print_supports (supports_message_passing, "Message passing")
			print_supports (supports_priority_scheduling, "Priority scheduling")
			print_supports (supports_semaphores, "Semaphores")
			print_supports (supports_shared_memory_objects, "Shared memory objects")
			print_supports (supports_synchronized_io, "Synchronous io")
			print_supports (supports_timers, "Timers")
			print_supports (supports_threads, "Threads")

			print ("End test system.%N")
		end


	print_supports (supported: BOOLEAN; what: STRING) is
		do
			if not supported then
				print ("!! ")
			end
			print (what)
			if not supported then
				print (" not")
			end
			print (" supported.%N")
		end

end
