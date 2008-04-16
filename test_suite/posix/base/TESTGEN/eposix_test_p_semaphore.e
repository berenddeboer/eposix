class EPOSIX_TEST_P_SEMAPHORE

inherit

	TEST_P_SEMAPHORE

creation

	make_test

feature {NONE} -- Execution

	execute_i_th (an_id: INTEGER) is
			-- Run test case of id `an_id'.
		do
			inspect an_id
			when 1 then
				test_unnamed
			when 2 then
				test_named
			when 3 then
				test_acquire
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
				Result := "TEST_P_SEMAPHORE.test_unnamed"
			when 2 then
				Result := "TEST_P_SEMAPHORE.test_named"
			when 3 then
				Result := "TEST_P_SEMAPHORE.test_acquire"
			else
				Result := "Unknown id"
			end
		end

end
