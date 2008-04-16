indexing

	description: "Test URI parsing."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	TEST_URI_PARSER

inherit

	TS_TEST_CASE

feature -- Tests

	test_parsing is
		local
			uri: UT_URI
		do
			create uri.make ("http://www.ics.uci.edu/pub/ietf/uri/#Related")
			check_uri (uri, "http", "www.ics.uci.edu", "/pub/ietf/uri/", Void, "Related")

			create uri.make ("http://www.ics.uci.edu/cgi-bin/test?id=1")
			check_uri (uri, "http", "www.ics.uci.edu", "/cgi-bin/test", "id=1", Void)

			create uri.make ("http:/cgi-bin/test?id=1")
			check_uri (uri, "http", Void, "/cgi-bin/test", "id=1", Void)

			create uri.make ("http:/cgi-bin/test")
			check_uri (uri, "http", Void, "/cgi-bin/test", Void, Void)

			create uri.make ("various.html")
			check_uri (uri, Void, Void, "various.html", Void, Void)

			create uri.make ("various.html#index")
			check_uri (uri, Void, Void, "various.html", Void, "index")

			create uri.make ("http://ad.doubleclick.net/adj/reuters.com.dart/news/usnews/article;type=interstitial;articleID=5901464;sz=1x1;dcopt=ist;ord=498688466?")
			check_uri (uri, "http", "ad.doubleclick.net", "/adj/reuters.com.dart/news/usnews/article;type=interstitial;articleID=5901464;sz=1x1;dcopt=ist;ord=498688466", "", Void)
		end

	test_abnormal_cases is
		local
			uri: UT_URI
		do
			create uri.make ("//")
			check_uri (uri, Void, "", "", Void, Void)
		end


feature {NONE} -- Implementation

	check_uri (uri: UT_URI; scheme, authority, path, query, fragment: STRING) is
		require
			ur_not_void: uri /= Void
		do
			do_check ("scheme", scheme, uri.scheme)
			if uri.has_authority then
				do_check ("authority", authority, uri.authority)
			else
				assert_equal ("No authority expected", Void, authority)
			end
			do_check ("path", path, uri.path)
			if uri.has_query then
				do_check ("query", query, uri.query)
			else
				assert_equal ("No query expected", Void, query)
			end
			if uri.has_fragment then
				do_check ("fragment", fragment, uri.fragment)
			else
				assert_equal ("No fragment expected", Void, fragment)
			end
		end

	do_check (what, s1, s2: STRING) is
		do
			assert_equal (what, s1, s2)
		end

end
