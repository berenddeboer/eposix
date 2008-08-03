indexing

	description: "Test various Eiffel structure to pointer and vice versa routines."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	TEST_POINTER_OPERATIONS


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	STDC_BASE
		export
			{NONE} all
		end

	MEMORY
		export
			{NONE} all
		end


feature

	test_string is
			-- Test getting pointers to normal strings and vice versa.
		local
			p: POINTER
			s: STRING
		do
			p := sh.string_to_pointer (hello)
			assert_not_equal ("Got real pointer.", default_pointer, p)
			s := sh.pointer_to_string (p)
			assert_equal ("String still there.", hello, s)
			sh.unfreeze_all
			p := sh.string_to_pointer (Void)
			assert_equal ("nil pointer for Void.", default_pointer, p)
			s := sh.pointer_to_string (default_pointer)
			assert ("Empty string for nil pointer.", s.is_empty)
		end

	test_string_without_gc is
			-- As `test_string' but with gc disabled.
		local
			p: POINTER
			s: STRING
		do
			collection_off
			p := sh.string_to_pointer (hello)
			assert_not_equal ("Got real pointer.", default_pointer, p)
			s := sh.pointer_to_string (p)
			assert_equal ("String still there.", hello, s)
			sh.unfreeze_all
			p := sh.string_to_pointer (Void)
			assert_equal ("nil pointer for Void.", default_pointer, p)
			s := sh.pointer_to_string (default_pointer)
			assert ("Empty string for nil pointer.", s.is_empty)
			collection_on
			full_collect
		end

	test_uc_string is
			-- Unicode strings
		local
			p: POINTER
			s: STRING
		do
			p := sh.string_to_pointer (uc_hello)
			assert_not_equal ("Got real pointer.", default_pointer, p)
			s := sh.pointer_to_string (p)
			assert_equal ("hello still there.", hello, s)
			sh.unfreeze_all

			collection_off
			p := sh.string_to_pointer (uc_hello)
			assert_not_equal ("Got real pointer.", default_pointer, p)
			s := sh.pointer_to_string (p)
			assert_equal ("hello still there without gc.", hello, s)
			sh.unfreeze_all
			collection_on
			full_collect

			p := sh.string_to_pointer (uc_hello2)
			assert_not_equal ("Got real pointer.", default_pointer, p)
			s := sh.pointer_to_string (p)
			assert_equal ("real utf8 string still there.", uc_hello2.as_string, s)
			sh.unfreeze_all
		end


feature {NONE} -- Implementation

	hello: STRING is "Hello World!"

	uc_hello: UC_STRING is
		once
			create Result.make_from_string ("Hello World!")
		ensure
			uc_hello_not_empty: Result /= Void and then not Result.is_empty
			not_prematurely_terminated: Result.index_of_item_code (0, 1) = 0
			count_correct: Result.count = hello.count
		end

	uc_hello2: UC_STRING is
		once
			create Result.make_from_string ("Hello World!")
			Result.put_item_code (9878, 2)
		ensure
			uc_hello2_not_empty: Result /= Void and then not Result.is_empty
			not_prematurely_terminated: Result.index_of_item_code (0, 1) = 0
			count_correct: Result.count = hello.count
		end


invariant

	hello_not_prematurely_terminated: not hello.has ('%U')

end
