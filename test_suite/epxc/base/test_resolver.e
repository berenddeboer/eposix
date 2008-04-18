indexing

	description:

		"Test eposix resolver classes"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_RESOLVER


inherit

	TS_TEST_CASE


feature

	test_http is
		local
			resolver: EPX_HTTP_URI_RESOLVER
			uri: UT_URI
			stack:  DS_LINKED_STACK [UT_URI]
		do
			create uri.make ("http://www.freebsd.org/")
			create stack.make
			create resolver.make (stack)
			resolver.resolve (uri)
			assert ("Resolved", not resolver.has_error)
		end

	test_https is
		local
			resolver: EPX_HTTPS_URI_RESOLVER
			uri: UT_URI
			stack:  DS_LINKED_STACK [UT_URI]
		do
			create uri.make ("https://fnc.asbbank.co.nz/")
			create stack.make
			create resolver.make (stack)
			resolver.resolve (uri)
			assert ("Resolved", not resolver.has_error)
		end


end
