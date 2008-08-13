indexing

	description:

		"Test the SHA1 functions"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2008, Berend de Boer"
	license: "MIT License (see LICENSE)"
	date: "$Date$"
	revision: "$Revision$"


deferred class

	TEST_CRYPTO


inherit

	TS_TEST_CASE

	EPX_OCTET_ENCODING
		export
			{NONE} all
		end


feature -- Tests

	test_sha1 is
		do
			do_test ("test", "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3")
			do_test ("abc", "a9993e364706816aba3e25717850c26c9cd0d89d")
			do_test ("abcdbcdecdefdefgefghfghighijhi" + "jkijkljklmklmnlmnomnopnopq", "84983e441c3bd26ebaae4aa1f95129e5e54670f1")

			do_test ("a", "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")
			do_test_sha1 (create {STRING}.make_filled ('a', 1000000), "34aa973cd4c4daa4f61eeb2bdbad27316534016f")
			do_repeat_test_sha1 ("01234567012345670123456701234567" + "01234567012345670123456701234567", "dea356a2cddd90c7a7ecedc5ebb563934f460452", 10)
		end

	test_hmac is
			-- Includes all test-cases from rFC 2202.
		local
			sha1: EPX_SHA1_CALCULATION
			hmac: EPX_HMAC_CALCULATION
		do
			create sha1.make
			create hmac.make (create {STRING}.make_filled ('%/011/', 16), sha1)
			hmac.put_string ("Hi There")
			hmac.finalize
			assert_equal ("Checksum for `Hi There'", "675b0b3a1b4ddf4e124872da6c2f632bfed957e9", hmac.checksum)
			create hmac.make (create {STRING}.make_filled ('%/011/', 20), sha1)
			hmac.put_string ("Hi There")
			hmac.finalize
			assert_equal ("Checksum for `Hi There'", "b617318655057264e28bc0b6fb378c8ef146be00", hmac.checksum)
			create hmac.make ("Jefe", sha1)
			hmac.put_string ("what do ya want for nothing?")
			hmac.finalize
			assert_equal ("Checksum for `what do ya want for nothing?'", "effcdf6ae5eb2fa2d27416d5f184df9c259a7c79", hmac.checksum)
			do_test_hmac ("0xdd repeated 50 times", create {STRING}.make_filled ('%/0xaa/', 20),  create {STRING}.make_filled ('%/0xdd/', 50), "125d7342b9ac11cd91a39af48aa17b4f63f175d3")
			do_test_hmac ("0xcd repeated 50 times", pack ("0102030405060708090a0b0c0d0e0f10111213141516171819"),  create {STRING}.make_filled ('%/0xcd/', 50), "4c9007f4026250c6bc8414f9bf50c86c2d7235da")
			do_test_hmac ("Test With Truncation", create {STRING}.make_filled ('%/0x0c/', 20),  "Test With Truncation", "4c1a03424b55e07fe7f27be1d58bb9324a9a5a04")
			do_test_hmac ("Test Using Larger Than Block-Size Key - Hash Key First", create {STRING}.make_filled ('%/0xaa/', 80),  "Test Using Larger Than Block-Size Key - Hash Key First", "aa4ae5e15272d00e95705637ce8a3b55ed402112")
			do_test_hmac ("Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data", create {STRING}.make_filled ('%/0xaa/', 80),  "Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data", "e8e99d0f45237d786d6bbaa7965c7808bbff1a91")
		end


feature {NONE} -- Implementation

	pack (s: STRING): STRING is
		local
			i: INTEGER
		do
			create Result.make (s.count // 2)
			from
				i := 1
			until
				i > s.count
			loop
				Result.append_character (from_hex_string (s.substring (i, i+1)))
				i := i + 2
			end
		end

	do_test_sha1 (value, checksum: STRING) is
		require
			value_not_empty: value /= Void and then not value.is_empty
			checksum_not_empty: checksum /= Void and then not checksum.is_empty
		local
			sha1: EPX_SHA1_CALCULATION
		do
			create sha1.make
			sha1.put_string (value)
			sha1.finalize
			assert_equal ("Checksum for '" + value + "' correct", checksum, sha1.checksum)
			-- Test reuse
			sha1.wipe_out
			sha1.put_string (value)
			sha1.finalize
			assert_equal ("Checksum for '" + value + "' correct", checksum, sha1.checksum)
		end

	do_repeat_test_sha1 (value, checksum: STRING; a_repeat_count: INTEGER) is
		require
			value_not_empty: value /= Void and then not value.is_empty
			checksum_not_empty: checksum /= Void and then not checksum.is_empty
			repeat_count_positive: a_repeat_count > 0
		local
			sha1: EPX_SHA1_CALCULATION
			i: INTEGER
		do
			create sha1.make
			from
			until
				i = a_repeat_count
			loop
				sha1.put_string (value)
				i := i + 1
			end
			sha1.finalize
			assert_equal ("Checksum for '" + value + "' correct", checksum, sha1.checksum)
		end

	do_test_hmac (a_test_case, a_key, a_data, a_checksum: STRING) is
		require
			a_test_case_not_empty: a_test_case /= Void and then not a_test_case.is_empty
			a_key_not_empty: a_key /= Void and then not a_key.is_empty
			a_data_not_empty: a_data /= Void and then not a_data.is_empty
			a_checksum_not_empty: a_checksum /= Void and then not a_checksum.is_empty
		local
			sha1: EPX_SHA1_CALCULATION
			hmac: EPX_HMAC_CALCULATION
		do
			create sha1.make
			create hmac.make (a_key, sha1)
			hmac.put_string (a_data)
			hmac.finalize
			assert_equal (a_test_case, a_checksum, hmac.checksum)
		end

end
