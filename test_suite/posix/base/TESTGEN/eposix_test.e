class EPOSIX_TEST

inherit

	TS_TESTER

creation

	make, make_default

feature -- Access

	suite: TS_TEST_SUITE is
			-- Suite of tests to be run
		local
			a_test: TS_TEST
		do
			create Result.make ("eposix_test", variables)
			create {EPOSIX_TEST_P_BUFFER} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_ENVIRONMENT} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_EXEC_PROCESS} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_EXEC_PROCESS} a_test.make_test (2, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_EXEC_PROCESS} a_test.make_test (3, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE} a_test.make_test (2, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE} a_test.make_test (3, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE} a_test.make_test (4, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE} a_test.make_test (5, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_DESCRIPTOR} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_DESCRIPTOR} a_test.make_test (2, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_SYSTEM} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_SYSTEM} a_test.make_test (2, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_SYSTEM} a_test.make_test (3, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_SYSTEM} a_test.make_test (4, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_SYSTEM} a_test.make_test (5, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_SYSTEM} a_test.make_test (6, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_SYSTEM} a_test.make_test (7, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_SYSTEM} a_test.make_test (8, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_FILE_SYSTEM} a_test.make_test (9, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_GROUP} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_GROUP} a_test.make_test (2, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_MEMORY_MAP} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_MODEM} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_SEMAPHORE} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_SEMAPHORE} a_test.make_test (2, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_SEMAPHORE} a_test.make_test (3, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_SHARED_MEMORY} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_SYSTEM} a_test.make_test (1, variables)
			Result.put_test (a_test)
			create {EPOSIX_TEST_P_TIME} a_test.make_test (1, variables)
			Result.put_test (a_test)
		end

end
