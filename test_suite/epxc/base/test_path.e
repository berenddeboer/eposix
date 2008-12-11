indexing

	description: "Test STDC_PATH class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

deferred class

	TEST_PATH

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_FILE_SYSTEM
		export
			{NONE} all
		end

	EPX_SYSTEM
		export
			{NONE} all
		end


feature -- Tests

	test_portable_path is
		do
			if not is_windows then
				do_test_portable_path
			end
		end

	do_test_portable_path is
			-- Test portable path handling.
		local
			env_home: STDC_ENV_VAR
			p: STDC_PATH
		do
			create env_home.make ("HOME")
			path_ok ("dir", "dir")
			path_ok ("~/tmp", env_home.value + path_separator.out + "tmp")
			path_ok ("~\tmp", env_home.value + path_separator.out + "tmp")
			path_ok ("$HOME", env_home.value)
			path_ok ("$HOME/tmp", env_home.value + path_separator.out + "tmp")
			path_ok ("%%HOME%%/tmp", env_home.value + path_separator.out + "tmp")
			path_ok ("${HOME}/tmp", env_home.value + path_separator.out + "tmp")
			path_ok ("$(HOME)/tmp", env_home.value + path_separator.out + "tmp")
			path_ok ("tmp/test~", "tmp" + path_separator.out + "test~")
			path_ok ("\winnt\system32", path_separator.out + "winnt" + path_separator.out + "system32")
			path_ok ("$NOT_EXIST_QQ/dir", path_separator.out + "dir")

			create p.make_expand ("/usr/local/bin")
			assert ("Portable.", p.is_portable)

			-- test path parsing
			create p.make_from_string ("test.e")
			p.parse (<<".e">>)
			check_parse (p, "", "test", ".e")
			create p.make_from_string ("/a/b/c/test.e")
			p.parse (Void)
			check_parse (p, "/a/b/c", "test.e", "")
			create p.make_from_string ("../test.e")
			p.parse (<<".c">>)
			check_parse (p, "..", "test.e", "")
			create p.make_from_string ("../test.e")
			p.parse (<<".c", ".e">>)
			check_parse (p, "..", "test", ".e")
		end

feature {NONE} -- Implementation

	path_ok (path, expected: STRING) is
		require
			path_not_void: path /= Void
			expected_not_void: expected /= Void
		local
			p: STDC_PATH
			s: STRING
		do
			create p.make_expand (path)
			create s.make_from_string (p)
			assert_equal ("Path is as expected.", expected, s)
		end

	check_parse (p: STDC_PATH; a_dir, a_name, a_suffix: STRING) is
		require
			p_not_void: p /= Void
			dir_not_void: a_dir /= Void
			name_not_void: a_name /= Void
			suffix_not_void: a_suffix /= Void
		do
			assert_equal ("Directory equal.", a_dir, p.directory)
			assert_equal ("Basename equal.", a_name, p.basename)
			assert_equal ("Suffix equal.", a_suffix, p.suffix)
		end

end
