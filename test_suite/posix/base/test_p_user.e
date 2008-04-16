indexing

	description: "Test POSIX user class."

  author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

deferred class TEST_P_USER

inherit

	POSIX_CURRENT_PROCESS


feature

	make is
		local
			user: POSIX_USER
			db: POSIX_USER_DATABASE
		do
			print ("Begin test user.%N")

			print ("Access user database.%N")
			create db
			if db.is_existing_uid (0) then
				print ("uid 0 exists.%N")
			else
				print ("!! uid 0 does not exist.%N")
			end
			if db.is_existing_login ("root") then
				print ("user root exists.%N")
				create user.make_from_name ("root")
				print_user (user)
				print ("%N")
				create user.make_from_uid (user.uid)
				print_user (user)
				user.refresh
				print ("%N")
			else
				print ("!! user root does not exist.%N")
			end
			if db.is_existing_uid (61431) then
				print ("!! uid 61431 unexpectedly exists :-) .%N")
				create user.make_from_uid (61431)
				print_user (user)
			else
				print ("uid 61431 does not exist.%N")
			end

			if login_name.is_empty then
				print ("not running on controlling terminal, user not known.%N")
			else
				create user.make_from_name (login_name)
			end
			user.refresh
			print_user (user)

			print ("End test user.%N")
		end

	print_user (user: POSIX_USER) is
		do
			print ("login: ")
			print (user.name)
			print ("%N")
			print ("uid: ")
			print (user.uid)
			print ("%N")
			print ("gid: ")
			print (user.gid)
			print ("%N")
			print ("home: ")
			print (user.home_directory)
			print ("%N")
			print ("shell: ")
			print (user.shell)
			print ("%N")
		end


end -- class TEST_P_USER
