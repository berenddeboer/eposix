indexing

	description: "Test HTTPS client by connecting to an HTTP server."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_HTTPS_CLIENT


inherit

	TS_TEST_CASE

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all
		end

	EPX_HTTP_REPLY_CODE
		export
			{NONE} all
		end


feature

	test_get is
		local
			client: EPX_HTTP_11_CLIENT
		do
			create client.make_secure ("www.intrade.com")
			client.get ("/")
			client.read_response
			assert_equal ("Response code", reply_code_ok, client.response_code)
			assert_equal ("Response phrase", "OK", client.response_phrase)
		end

	test_non_existing is
		local
			client: EPX_HTTP_11_CLIENT
		do
			create client.make_secure ("www.tradesports.com")
			client.get ("/nonexisting.html")
			client.read_response
			assert_equal ("Response code", reply_code_not_found, client.response_code)
		end


end
