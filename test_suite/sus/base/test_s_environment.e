indexing

	description: "Test Single Unix Specification environment class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

deferred class

	TEST_S_ENVIRONMENT


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end


feature -- Tests

	test_all is
		local
			env: SUS_ENV_VAR
		do
			create env.make ("TESTTEST")
			assert_equal ("Not set.", "", env.value)
			env.set_value ("tada")
			assert_equal ("Set.", "tada", env.value)
			env.set_value ("oops")
			assert_equal ("Set.", "oops", env.value)
			create env.make ("TESTTEST")
			env.set_value ("new")
			assert_equal ("Set.", "new", env.value)
		end

end
