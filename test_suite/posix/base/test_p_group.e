indexing

	description: "Test POSIX group class."

  author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

deferred class

	TEST_P_GROUP

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS
		export
			{NONE} all
		end

	POSIX_SYSTEM
		export
			{NONE} all
		end

feature -- Tests

	test_group is
		local
			group: POSIX_GROUP
		do
			create group.make_from_gid (effective_group_id)
			group.refresh
			print_group (group)
			print ("%N")

			create group.make_from_gid (group.gid)
			print_group (group)
			print ("%N")
			group.refresh

			create group.make_from_name (group.name)
			print_group (group)
			print ("%N")
		end

	test_group_database is
			-- Access group database.
		local
			db: POSIX_GROUP_DATABASE
		do
			create db
			assert ("gid 0 exists.", db.is_existing_gid (0))
			assert ("group wheel exists.", db.is_existing_group ("daemon"))
			if system_name.substring_index ("CYGWIN", 1) = 0 then
				assert ("Assume group 61431 does not exist.", not db.is_existing_gid (61431))
			else
				print ("Cygwin always returns a group, even when non-existent.%N")
			end
		end


feature {NONE} -- Implementation

	print_group (group: POSIX_GROUP) is
		do
			print ("name: ")
			print (group.name)
			print ("%N")
			print ("gid: ")
			print (group.gid)
			print ("%N")
		end


end
