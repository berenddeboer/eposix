indexing

	description: "getest based test for writing XML messages."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	TEST_XML_WRITER

inherit

	TS_TEST_CASE

feature -- Tests

	test_tags is
		local
			xml: EPX_XML_WRITER
		do
			create xml.make
			xml.add_header_utf_8_encoding
			xml.start_tag ("a")
			xml.start_tag ("b")
			xml.stop_tag
			xml.stop_tag
			debug ("test")
				print (xml.as_string)
			end
			assert_equal ("XML correct", test_tags_result, xml.as_string)
		end

	test_comments is
		local
			xml: EPX_XML_WRITER
		do
			create xml.make_fragment
			xml.start_tag ("a")
			xml.add_comment ("test")
			xml.stop_tag
			debug ("test")
				print (xml.as_string)
			end
			assert_equal ("XML correct", test_comments_result1, xml.as_string)
			xml.clear
			xml.start_tag ("b")
			xml.add_comment ("<!--test-->")
			xml.stop_tag
			debug ("test")
				print (xml.as_string)
			end
			assert_equal ("XML correct", test_comments_result2, xml.as_string)
		end

	test_attributes is
		local
			xml: EPX_XML_WRITER
		do
			create xml.make_fragment
			xml.start_tag ("a")
			xml.set_attribute ("b", Void)
			xml.set_attribute ("c", "")
			xml.set_attribute ("d", "a")
			xml.stop_tag
			debug ("test")
				print (xml.as_string)
			end
			assert_equal ("XML correct", test_attributes_result, xml.as_string)
		end

	test_streaming_attributes is
		local
			xml: EPX_XML_WRITER
		do
			create xml.make_fragment
			xml.start_tag ("a")
			xml.add_attribute ("b", Void)
			xml.add_attribute ("c", "")
			xml.add_attribute ("d", "a")
			xml.stop_tag
			debug ("test")
				print (xml.as_string)
			end
			assert_equal ("XML correct", test_attributes_result, xml.as_string)
			xml.clear
			xml.start_tag ("a")
			xml.add_attribute ("b", Void)
			xml.add_data ("test")
			xml.start_tag ("b")
			xml.add_attribute ("a", Void)
			xml.stop_tag
			xml.stop_tag
			debug ("test")
				print (xml.as_string)
			end
			--assert_equal ("XML correct", test_attributes_result, xml.as_string)
		end

	test_escape is
		local
			xml: EPX_XML_WRITER
		do
			create xml.make_fragment
			xml.start_tag ("a")
			xml.add_data ("this & that")
			xml.stop_tag
			assert_equal ("Escaped content treated correctly.", "<a>this &amp; that</a>%N", xml.as_string)

			xml.clear
			xml.start_tag ("a")
			xml.add_data ("test>")
			xml.stop_tag
			assert_equal ("Escaped content treated correctly.", "<a>test></a>%N", xml.as_string)

			xml.clear
			xml.start_tag ("a")
			xml.add_data ("test]]>")
			xml.stop_tag
			assert_equal ("Escaped content treated correctly.", "<a>test]]&gt;</a>%N", xml.as_string)

			xml.clear
			xml.start_tag ("a")
			xml.add_data ("test]>")
			xml.stop_tag
			assert_equal ("Escaped content treated correctly.", "<a>test]></a>%N", xml.as_string)

			xml.clear
			xml.start_tag ("a")
			xml.add_data ("]>")
			xml.stop_tag
			assert_equal ("Escaped content treated correctly.", "<a>]></a>%N", xml.as_string)

			xml.clear
			xml.start_tag ("a")
			xml.add_data ("]]>")
			xml.stop_tag
			assert_equal ("Escaped content treated correctly.", "<a>]]&gt;</a>%N", xml.as_string)

			xml.clear
			xml.start_tag ("a")
			xml.add_data ("]]>ab")
			xml.stop_tag
			assert_equal ("Escaped content treated correctly.", "<a>]]&gt;ab</a>%N", xml.as_string)
		end

	test_cdata is
		local
			xml: EPX_XML_WRITER
		do
			create xml.make_fragment
			xml.start_tag ("a")
			xml.add_cdata ("hello")
			xml.stop_tag
			assert_equal ("CDATA added", "<a><![CDATA[hello]]></a>%N", xml.as_string)

			create xml.make_fragment
			xml.start_tag ("a")
			xml.add_cdata ("hel]]>lo")
			xml.stop_tag
			assert_equal ("CDATA escape works", "<a><![CDATA[hel]]>]]&gt;<![CDATA[lo]]></a>%N", xml.as_string)

			create xml.make_fragment
			xml.start_tag ("a")
			xml.add_cdata ("hel]]>]]>lo")
			xml.stop_tag
			assert_equal ("CDATA really works", "<a><![CDATA[hel]]>]]&gt;<![CDATA[]]>]]&gt;<![CDATA[lo]]></a>%N", xml.as_string)

		end

	test_incremental is
		local
			xml: EPX_INCREMENTAL_XML_WRITER
		do
			create xml.make_fragment
			xml.start_tag ("a")
			xml.start_tag ("b")
			xml.incremental_write
			debug ("test")
				print ("XML:%N")
				print (xml.last_string)
				print ("%N")
			end
			xml.set_attribute ("c", "")
			xml.set_attribute ("d", "a")
			xml.incremental_write
			debug ("test")
				print ("XML:%N")
				print (xml.last_string)
				print ("%N")
			end
			xml.stop_tag
			xml.incremental_write
			debug ("test")
				print ("XML:%N")
				print (xml.last_string)
				print ("%N")
			end
			xml.stop_tag
			xml.incremental_write
			debug ("test")
				print ("XML:%N")
				print (xml.last_string)
				print ("%N")
			end
		end


feature {NONE} -- Implementation

	test_tags_result: STRING is "<?xml version=%"1.0%" encoding=%"UTF-8%" ?>%N<a>%N  <b/>%N</a>%N"

	test_comments_result1: STRING is "<a><!--test--></a>%N"
	test_comments_result2: STRING is "<b><!--<!--test--&gt;--></b>%N"

	test_attributes_result: STRING is "<a b=%"%" c=%"%" d=%"a%"/>%N"

end
