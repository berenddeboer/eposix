indexing

	description:

		"Various tests on IP addresses"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

deferred class

	TEST_IP_ADDRESS


inherit

	TS_TEST_CASE


feature -- Tests

	test_ip4_components is
		local
			address: EPX_IP4_ADDRESS
		do
			create address.make_from_components (127, 132, 176, 40)
			assert_integers_equal ("Correct address", 2139402280,  address.value)
			create address.make_from_components (128, 0, 0, 0)
			assert_integers_equal ("Correct address", (-2147483648).to_integer,  address.value)
			create address.make_from_components (209, 132, 176, 40)
			assert_integers_equal ("Correct address", -779833304, address.value)
			create address.make_from_components (130, 14, 74, 3)
			assert_integers_equal ("Correct address", -2112992765, address.value)
		end

	test_ip4_unsigned_integer is
		local
			address: EPX_IP4_ADDRESS
			i: INTEGER_64
		do
			-- C9081A3D
			-- 2147483647
			i := ("3372751421").to_integer_64
			create address.make_from_integer (i.to_integer)
			assert_equal ("Correct address", -922215875, address.value)
		end

end
