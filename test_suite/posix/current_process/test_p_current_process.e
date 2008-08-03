indexing

	description: "Test POSIX current process class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_P_CURRENT_PROCESS

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS


feature

	test_all is
		do
			assert_not_equal ("pid greater as zero.", 0, pid)

			-- sleep 4 seconds
			sleep (4)

			print ("Login name  : '")
			print (login_name)
			print ("'.%N")

			print ("My pid       : ")
			print (pid)
			print (".%N")
			print ("Parent pid   : ")
			print (parent_pid)
			print (".%N%N")

			print ("real uid     : ")
			print (real_user_id)
			print (".%N")
			print ("effective uid: ")
			print (effective_user_id)
			print (".%N")
			print ("real gid     : ")
			print (real_group_id)
			print (".%N")
			print ("effective gid: ")
			print (effective_group_id)
			print (".%N%N")

			print ("process gid  : ")
			print (process_group_id)
			print (".%N%N")

			print ("Restore user id.%N")
			restore_user_id
			restore_group_id
			if real_user_id = 0 then
				print ("Attempt to set user id to 0.%N")
				set_user_id (0)
				set_user_id (real_user_id)
			else
				print ("Because you are not root, you cannot set uid to 0.%N")
			end
		end

end
