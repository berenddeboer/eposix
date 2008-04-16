class EPOSIX_TEST_P_FILE_SYSTEM

inherit

	TEST_P_FILE_SYSTEM

creation

	make_test

feature {NONE} -- Execution

	execute_i_th (an_id: INTEGER) is
			-- Run test case of id `an_id'.
		do
			inspect an_id
			when 1 then
				test_unlinking
			when 2 then
				test_file_system
			when 3 then
				test_accessibility
			when 4 then
				test_permissions
			when 5 then
				test_permissions_cache
			when 6 then
				test_directory
			when 7 then
				test_directory_reading
			when 8 then
				test_hard_link
			when 9 then
				test_fifo
			else
				-- Unknown id.
			end
		end

feature {NONE} -- Implementation

	name_of_id (an_id: INTEGER): STRING is
			-- Name of test case of id `an_id'
		do
			inspect an_id
			when 1 then
				Result := "TEST_P_FILE_SYSTEM.test_unlinking"
			when 2 then
				Result := "TEST_P_FILE_SYSTEM.test_file_system"
			when 3 then
				Result := "TEST_P_FILE_SYSTEM.test_accessibility"
			when 4 then
				Result := "TEST_P_FILE_SYSTEM.test_permissions"
			when 5 then
				Result := "TEST_P_FILE_SYSTEM.test_permissions_cache"
			when 6 then
				Result := "TEST_P_FILE_SYSTEM.test_directory"
			when 7 then
				Result := "TEST_P_FILE_SYSTEM.test_directory_reading"
			when 8 then
				Result := "TEST_P_FILE_SYSTEM.test_hard_link"
			when 9 then
				Result := "TEST_P_FILE_SYSTEM.test_fifo"
			else
				Result := "Unknown id"
			end
		end

end
