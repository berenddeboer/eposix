indexing

	description: "Test Standard C securiy class."

	warning: "Works only if garbage collection cycle can be triggered. So it uses check instead of assert, else compiliation fails for compilers that do not support this."

	author: "Berend de Boer"


deferred class

	TEST_SECURITY


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	STDC_BASE

	MEMORY

feature -- Security tests

	test_cpu_time is
		local
			rescued: BOOLEAN
		do
			if not rescued then
				security.cpu.set_max_process_time (0)
				security.cpu.check_process_time
			end
			assert ("Max process time detected.", rescued)
		rescue
			rescued := True
			retry
		end

	test_max_memory is
		local
			rescued: BOOLEAN
			buf1, buf2: STDC_DYNAMIC_MEMORY
		do
			if not rescued then
				security.memory.set_max_allocated_memory (1024)
				create buf1.allocate (1024)
				create buf2.allocate (1024)
			end
			assert ("Max memory allocation detected.", rescued)
		rescue
			rescued := True
			security.memory.set_max_allocated_memory (65536)
			retry
		end

	test_memory_dispose is
		require
			gc_enabled_and_working: collecting
		local
			base_line: INTEGER
		do
			-- SmartEiffel needs this print...
			print ("%N")
			-- This does not work for gec as it seems you cannot force a
			-- collect call.
			full_collect
			base_line := security.memory.allocated_memory
			create_buffer (base_line)
			print ("%N")
			full_collect
			assert_equal ("Allocated memory decremented by dispose.", base_line, security.memory.allocated_memory)
		end

	test_max_open_files is
			-- Test if maximum allowed number of files is properly
			-- detected. This test does not work with SmartEiffel (tested
			-- with 1.2b5, it core dumps).
		local
			rescued: BOOLEAN
			file1, file2, file3: STDC_TEXT_FILE
		do
			if not rescued then
				create file1.create_write ("/tmp/file1")
				-- One file opened, allow one more file to open
				security.files.set_max_open_files (security.files.open_files + 1)
				create file2.create_write ("/tmp/file2")
				create file3.create_write ("/tmp/file3")
			end
			assert ("Max open files detected.", rescued)
		rescue
			rescued := True
			security.files.set_max_open_files (50)
			if file2 /= Void then
				file2.close
			end
			if file1 /= Void then
				file1.close
			end
			retry
		end

	test_file_close_and_dispose is
		require
			gc_enabled_and_working: collecting
		local
			base_line: INTEGER
		do
			-- SmartEiffel likes lots of prints to really collect...
			print ("%N")
			full_collect
			base_line := security.files.open_files
			create_a_file (base_line)
			print ("%N")
			full_collect
			assert_equal ("Open files decremented by dispose.", base_line, security.files.open_files)
		end

	test_exception_handling is
			-- No exception should occur in this test.
		local
			file: STDC_BINARY_FILE
		do
			security.error_handling.disable_exceptions
			create file.open_read ("does.not.exist")
			assert_not_equal ("First error set.", 0, file.errno.first_value)

			file.errno.clear_first
			create file.create_read_write ("/a/b/c/x/y/z/does.not.exist")
			assert_not_equal ("First error set.", 0, file.errno.first_value)

			security.error_handling.enable_exceptions
		end


feature {NONE} -- Implementation

	create_a_file (base_line: INTEGER) is
		local
			file: STDC_TEXT_FILE
		do
			create file.create_write ("/tmp/file")
			assert_equal ("Open files incremented.", base_line + 1, security.files.open_files)
			file.close
			assert_equal ("Open files decremented by close.", base_line, security.files.open_files)
			create file.create_write ("/tmp/file")
			assert_equal ("Open files incremented.", base_line + 1, security.files.open_files)
			-- rely on gc to decrement number of open files...
		end


	create_buffer (base_line: INTEGER) is
		local
			buffer: STDC_BUFFER
		do
			create buffer.allocate (1024)
			assert_equal ("Allocated memory incremented.", base_line + 1024, security.memory.allocated_memory)
			buffer.deallocate
			assert_equal ("Allocated memory decremented by deallocate.", base_line, security.memory.allocated_memory)
			create buffer.allocate (1024)
			assert_equal ("Allocated memory incremented.", base_line + 1024, security.memory.allocated_memory)
			-- rely on gc to decrement number of open files...
		end


end
