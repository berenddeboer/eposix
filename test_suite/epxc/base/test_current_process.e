indexing

	description:

		"Test for EPX_CURRENT_PROCESS"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_CURRENT_PROCESS


inherit

	TS_TEST_CASE

	EPX_CURRENT_PROCESS


feature -- Tests

	test_access is
		do
			assert ("Have effective_user_name", not effective_user_name.is_empty)
		end

	test_environment is
		local
			i: INTEGER
			env: ARRAY [STRING]
		do
			assert ("Has environment variables", raw_environment_variables.count > 0)
			debug ("test")
				print ("Number of environment variables: ")
				print (raw_environment_variables.count)
				print ("%N")
				env := raw_environment_variables
				from
					i := env.lower
				until
					i > env.upper
				loop
					print (env.item (i))
					print ("|%N")
					i := i + 1
				end
			end
			assert ("Has environment variables", environment_variables.count > 0)
			assert_equal ("name=value pairs equal to name pairs", raw_environment_variables.count, environment_variables.count)
			debug ("test")
-- 				env := environment_variables
-- 				from
-- 					i := env.lower
-- 				until
-- 					i > env.upper
-- 				loop
-- 					print (env.item (i))
-- 					print ("|%N")
-- 					i := i + 1
-- 				end
			end
		end

end
