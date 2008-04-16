class EPOSIX_TEST_P_FILE_DESCRIPTOR

inherit

	TEST_P_FILE_DESCRIPTOR

creation

	make_test

feature {NONE} -- Execution

	execute_i_th (an_id: INTEGER) is
			-- Run test case of id `an_id'.
		do
			inspect an_id
			when 1 then
				test_various
			when 2 then
				test_create_from_file
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
				Result := "TEST_P_FILE_DESCRIPTOR.test_various"
			when 2 then
				Result := "TEST_P_FILE_DESCRIPTOR.test_create_from_file"
			else
				Result := "Unknown id"
			end
		end

end
