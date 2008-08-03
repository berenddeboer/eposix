indexing

	description: "Test POSIX system class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_A_SYSTEM

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_SYSTEM

feature

	test_methods is
		do
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
			print ("open_max     : ")
			print (max_open_files)
			print (".%N")
			print ("stream_max   : ")
			print (max_open_streams)
			print (".%N")
			print ("tzname_max   : ")
			print (max_time_zone_name)
			print (".%N")

		end

end
