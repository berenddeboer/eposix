indexing

	description: "Test Single Unix Specification environment class."

	author: "Berend de Boer"
	date: "$Date: 2005/02/10 $"
	revision: "$Revision: #2 $"

deferred class

	TEST_S_ENVIRONMENT


inherit

	TS_TEST_CASE


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
