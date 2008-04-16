class EPOSIX_TEST_P_ENVIRONMENT

inherit

	TEST_P_ENVIRONMENT

creation

	make_test

feature {NONE} -- Execution

	execute_i_th (an_id: INTEGER) is
			-- Run test case of id `an_id'.
		do
			inspect an_id
			when 1 then
				test_all
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
				Result := "TEST_P_ENVIRONMENT.test_all"
			else
				Result := "Unknown id"
			end
		end

end
