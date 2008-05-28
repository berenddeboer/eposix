indexing

	description: "Safely Writes XML Documents; with Incremental Writing"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_INCREMENTAL_XML_WRITER


inherit

	EPX_XML_WRITER

create

	make,
	make_with_capacity,
	make_fragment,
	make_fragment_with_capacity


feature -- Incremental Output

	incremental_write is
			-- Write xml added since last call to `incremental_write' or
			-- `incremental_put_to_file' and make available in
			-- `last_string' and `last_uc_string'.
			-- `incremental_write' will not output any open tags. Use
			-- `add_raw' to open and close the root element or nothing
			-- will be written until you stop the root element (not very
			-- incremental).
		local
			xml_count: INTEGER
		do
			xml_count := my_xml.count
			if xml_count > last_index then
				last_uc_string := my_xml.substring (last_index + 1, xml_count)
				last_string := last_uc_string.as_string
				last_index := xml_count
			else
				last_string := ""
				create last_uc_string.make_empty
			end
		ensure
			valid_last_string: last_string /= Void
			valid_last_uc_string: last_uc_string /= Void
		end

	incremental_put_to_file (the_file: KI_TEXT_OUTPUT_FILE) is
			-- Write xml added since last call to `incremental_write' or
			-- `incremental_put_to_file' to `the_file' and make available
			-- in `last_string' and `last_uc_string'.
			-- `incremental_put_to_file' will not output any open
			-- tags. Use `add_raw' to open and close the root element or
			-- nothing will be written until you stop the root element
			-- (not very incremental).
		require
			the_file_is_open_write: the_file /= Void and then the_file.is_open_write
		do
			incremental_write
			the_file.put_string (last_string)
		end

	last_string: STRING
			-- XML output from last call to `incremental_write' as a STRING

	last_uc_string: UC_STRING
			-- XML output from last call to `incremental_write' as a UC_STRING


feature {NONE} -- Implementation

	last_index: INTEGER
			-- Index of last character written from last call to
			-- `incremental_write'

end
