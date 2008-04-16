class EPOSIX_TEST_P_EXEC_PROCESS

inherit

	TEST_P_EXEC_PROCESS

creation

	make_test

feature {NONE} -- Execution

	execute_i_th (an_id: INTEGER) is
			-- Run test case of id `an_id'.
		do
			inspect an_id
			when 1 then
				test_input
			when 2 then
				test_kill
			when 3 then
				test_exit_code
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
				Result := "TEST_P_EXEC_PROCESS.test_input"
			when 2 then
				Result := "TEST_P_EXEC_PROCESS.test_kill"
			when 3 then
				Result := "TEST_P_EXEC_PROCESS.test_exit_code"
			else
				Result := "Unknown id"
			end
		end

end
