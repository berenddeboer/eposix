indexing

	description: "Test environment class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

deferred class

	TEST_P_ENVIRONMENT


inherit

	TS_TEST_CASE


feature -- Test

	test_all is
		do
			print_env ("HOME")
			print_env ("TMP")
			print_env ("TMPDIR")
			print_env ("PATH")
			print_env ("TZ")
		end


feature {NONE} -- Implementation

	print_env (a_name: STRING) is
		local
			env: POSIX_ENV_VAR
		do
			create env.make (a_name)
			debug
				print (a_name)
				print (": ")
				print (env.value)
				print ("%N")
			end
		end


end
