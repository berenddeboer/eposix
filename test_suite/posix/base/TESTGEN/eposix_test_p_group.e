class EPOSIX_TEST_P_GROUP

inherit

	TEST_P_GROUP

creation

	make_test

feature {NONE} -- Execution

	execute_i_th (an_id: INTEGER) is
			-- Run test case of id `an_id'.
		do
			inspect an_id
			when 1 then
				test_group
			when 2 then
				test_group_database
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
				Result := "TEST_P_GROUP.test_group"
			when 2 then
				Result := "TEST_P_GROUP.test_group_database"
			else
				Result := "Unknown id"
			end
		end

end
