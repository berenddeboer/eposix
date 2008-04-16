indexing

	description: "Test resolving using examples from RFC2396, appendix C"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_URI_RESOLVE

inherit

	TS_TEST_CASE
		redefine
			set_up
		end

feature -- Setup

	set_up is
		do
			create base.make ("http://a/b/c/d;p?q")
		end

feature -- Tests

	test_normal_cases is
		local
			uri: UT_URI
		do
			create uri.make_resolve (base, "g:h")
			check_uri (uri, "g", Void, "h", Void, Void, "g:h")

			create uri.make_resolve (base, "g")
			check_uri (uri, "http", "a", "/b/c/g", Void, Void, "http://a/b/c/g")

			create uri.make_resolve (base, "./g")
			check_uri (uri, "http", "a", "/b/c/g", Void, Void, "http://a/b/c/g")

			create uri.make_resolve (base, "g/")
			check_uri (uri, "http", "a", "/b/c/g/", Void, Void, "http://a/b/c/g/")

			create uri.make_resolve (base, "/g")
			check_uri (uri, "http", "a", "/g", Void, Void, "http://a/g")

			create uri.make_resolve (base, "//g")
			check_uri (uri, "http", "g", "", Void, Void, "http://g")

			create uri.make_resolve (base, "?y")
			check_uri (uri, "http", "a", "/b/c/d;p", "y", Void, "http://a/b/c/d;p?y")

			create uri.make_resolve (base, "g?y")
			check_uri (uri, "http", "a", "/b/c/g", "y", Void, "http://a/b/c/g?y")

			create uri.make_resolve (base, "#s")
			-- current document is this?
			check_uri (uri, "http", "a", "/b/c/d;p", "q", "s", "http://a/b/c/d;p?q#s")

			create uri.make_resolve (base, "g#s")
			check_uri (uri, "http", "a", "/b/c/g", Void, "s", "http://a/b/c/g#s")

			create uri.make_resolve (base, "g?y#s")
			check_uri (uri, "http", "a", "/b/c/g", "y", "s", "http://a/b/c/g?y#s")

			create uri.make_resolve (base, ";x")
			check_uri (uri, "http", "a", "/b/c/;x", Void, Void, "http://a/b/c/;x")

			create uri.make_resolve (base, "g;x")
			check_uri (uri, "http", "a", "/b/c/g;x", Void, Void, "http://a/b/c/g;x")

			create uri.make_resolve (base, "g;x?y#s")
			check_uri (uri, "http", "a", "/b/c/g;x", "y", "s", "http://a/b/c/g;x?y#s")

			create uri.make_resolve (base, ".")
			check_uri (uri, "http", "a", "/b/c/", Void, Void, "http://a/b/c/")

			create uri.make_resolve (base, "./")
			check_uri (uri, "http", "a", "/b/c/", Void, Void, "http://a/b/c/")

			create uri.make_resolve (base, "..")
			check_uri (uri, "http", "a", "/b/", Void, Void, "http://a/b/")

			create uri.make_resolve (base, "../")
			check_uri (uri, "http", "a", "/b/", Void, Void, "http://a/b/")

			create uri.make_resolve (base, "../g")
			check_uri (uri, "http", "a", "/b/g", Void, Void, "http://a/b/g")

			create uri.make_resolve (base, "../..")
			check_uri (uri, "http", "a", "/", Void, Void, "http://a/")

			create uri.make_resolve (base, "../../")
			check_uri (uri, "http", "a", "/", Void, Void, "http://a/")

			create uri.make_resolve (base, "../../g")
			check_uri (uri, "http", "a", "/g", Void, Void, "http://a/g")
		end

	test_rfc293_bis_cases is
			-- See http://www.apache.org/~fielding/uri/rev-2002/rfc2396bis.html
		local
			my_base: UT_URI
			uri: UT_URI
		do
			create my_base.make ("http://a")
			create uri.make_resolve (my_base, "b")
			check_uri (uri, "http", "a", "/b", Void, Void, "http://a/b")
		end

	test_abnormal_cases is
		local
			uri: UT_URI
		do
				check
					have_base: base /= Void
				end
			-- start of current document
			create uri.make_resolve (base, "")
			check_uri (uri, "http", "a", "/b/c/d;p", "q", Void, "http://a/b/c/d;p?q")

			create uri.make_resolve (base, "../../../g")
			check_uri (uri, "http", "a", "/g", Void, Void, "http://a/g")

			create uri.make_resolve (base, "../../../../g")
			check_uri (uri, "http", "a", "/g", Void, Void, "http://a/g")

			create uri.make_resolve (base, "/./g")
			check_uri (uri, "http", "a", "/./g", Void, Void, "http://a/./g")

			create uri.make_resolve (base, "/../g")
			check_uri (uri, "http", "a", "/../g", Void, Void, "http://a/../g")

			create uri.make_resolve (base, "g.")
			check_uri (uri, "http", "a", "/b/c/g.", Void, Void, "http://a/b/c/g.")

			create uri.make_resolve (base, ".g")
			check_uri (uri, "http", "a", "/b/c/.g", Void, Void, "http://a/b/c/.g")

			create uri.make_resolve (base, "g..")
			check_uri (uri, "http", "a", "/b/c/g..", Void, Void, "http://a/b/c/g..")

			create uri.make_resolve (base, "..g")
			check_uri (uri, "http", "a", "/b/c/..g", Void, Void, "http://a/b/c/..g")

			create uri.make_resolve (base, "./../g")
			check_uri (uri, "http", "a", "/b/g", Void, Void, "http://a/b/g")

			create uri.make_resolve (base, "./g/.")
			check_uri (uri, "http", "a", "/b/c/g/", Void, Void, "http://a/b/c/g/")

			create uri.make_resolve (base, "g/./h")
			check_uri (uri, "http", "a", "/b/c/g/h", Void, Void, "http://a/b/c/g/h")

			create uri.make_resolve (base, "g/../h")
			check_uri (uri, "http", "a", "/b/c/h", Void, Void, "http://a/b/c/h")

			create uri.make_resolve (base, "g;x=1/./y")
			check_uri (uri, "http", "a", "/b/c/g;x=1/y", Void, Void, "http://a/b/c/g;x=1/y")

			create uri.make_resolve (base, "g;x=1/../y")
			check_uri (uri, "http", "a", "/b/c/y", Void, Void, "http://a/b/c/y")

			create uri.make_resolve (base, "g?y/./x")
			check_uri (uri, "http", "a", "/b/c/g", "y/./x", Void, "http://a/b/c/g?y/./x")

			create uri.make_resolve (base, "g?y/../x")
			check_uri (uri, "http", "a", "/b/c/g", "y/../x", Void, "http://a/b/c/g?y/../x")

			create uri.make_resolve (base, "g#s/./x")
			check_uri (uri, "http", "a", "/b/c/g", Void, "s/./x", "http://a/b/c/g#s/./x")

			create uri.make_resolve (base, "g#s/../x")
			check_uri (uri, "http", "a", "/b/c/g", Void, "s/../x", "http://a/b/c/g#s/../x")

		end


feature {NONE} -- Implementation

	base: UT_URI

	check_uri (uri: UT_URI; a_scheme, an_authority, a_path, a_query, a_fragment, a_reference: STRING) is
		require
			have_uri: uri /= Void
		do
			do_check ("scheme", uri.scheme, a_scheme)
			if uri.has_authority then
				do_check ("authority", uri.authority, an_authority)
			else
				assert_equal ("No authority expected", Void, an_authority)
			end
			do_check ("path", uri.path, a_path)
			if uri.has_query then
				do_check ("query", uri.query, a_query)
			else
				assert_equal ("No query expected", Void, a_query)
			end
			if uri.has_fragment then
				do_check ("fragment", uri.fragment, a_fragment)
			else
				assert_equal ("No fragment expected", Void, a_fragment)
			end
			do_check ("reference", uri.full_reference, a_reference)
		end

	do_check (what, got, expected: STRING) is
		do
			assert_equal(what, expected, got)
		end

end
