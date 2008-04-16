class EPOSIX_TEST_P_FILE

inherit

	TEST_P_FILE

creation

	make_test

feature {NONE} -- Execution

	execute_i_th (an_id: INTEGER) is
			-- Run test case of id `an_id'.
		do
			inspect an_id
			when 1 then
				test_make_from_file
			when 2 then
				test_make_from_file_descriptor
			when 3 then
				test_wait_for_input
			when 4 then
				test_create_temporary_file
			when 5 then
				test_read
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
				Result := "TEST_P_FILE.test_make_from_file"
			when 2 then
				Result := "TEST_P_FILE.test_make_from_file_descriptor"
			when 3 then
				Result := "TEST_P_FILE.test_wait_for_input"
			when 4 then
				Result := "TEST_P_FILE.test_create_temporary_file"
			when 5 then
				Result := "TEST_P_FILE.test_read"
			else
				Result := "Unknown id"
			end
		end

end
