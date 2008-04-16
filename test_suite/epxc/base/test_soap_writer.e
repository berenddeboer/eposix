indexing

	description: "getest based test for writing SOAP messages."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_SOAP_WRITER

inherit

	TS_TEST_CASE

feature -- Tests

	test_basics is
		local
			soap: EPX_SOAP_WRITER
		do
			create soap.make
			soap.add_header_iso_8859_1_encoding
			soap.start_envelope

			soap.start_header
			soap.start_tag ("t:Transaction")
			soap.set_a_name_space ("t", "some-URI")
			soap.set_must_understand (True)
			soap.add_data ("5")
			soap.stop_tag
			soap.stop_header

			soap.start_body
			soap.start_ns_tag ("m", "GetLastTradePrice")
			soap.set_a_name_space ("m", "Some-URI")
			soap.start_tag ("symbol")
			soap.add_data ("DIS")
			soap.stop_tag
			soap.stop_tag
			soap.stop_body

			soap.stop_envelope
			debug
				print (soap.message)
			end
		end

end
