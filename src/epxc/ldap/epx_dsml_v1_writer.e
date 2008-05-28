indexing

	description:

		"Write DSML v1 XML"

	examples: "http://www.dsmltools.org/dsml.org/dsml.html"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_DSML_V1_WRITER


inherit

	EPX_XML_WRITER
		export
			{NONE} all;
			{ANY} add_header_utf_8_encoding, is_header_written, is_tag_started, as_string, as_uc_string, is_string
		end


create

	make,
	make_with_capacity,
	make_fragment,
	make_fragment_with_capacity


feature -- DSML specific calls

	start_dsml is
		require
			have_header: is_header_written
			this_is_root_tag: not is_tag_started
		do
			start_tag (dsml_dsml)
			-- write default value for complete attribute
			set_attribute (dsml_complete, "true")
			set_default_name_space (dsml_name_space)
		end

	start_directory_entries is
		require
			dsml_started: is_dsml_started
		do
			start_tag (dsml_directory_entries)
		end

	start_entry (a_distinguished_name: STRING) is
		require
			directory_entries_started: is_directory_entries_started
		do
			start_tag (dsml_entry)
			set_attribute(dsml_dn, a_distinguished_name)
		end

	start_objectclass is
		require
			dsml_started: is_entry_started
		do
			start_tag (dsml_objectclass)
		end

	add_oc_value (a_value: STRING) is
		require
			objectclass_started: is_objectclass_started
		do
			add_tag (dsml_oc_value, a_value)
		end

	start_attr (a_name: STRING) is
		require
			entry_started: is_entry_started
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			start_tag (dsml_attr)
			set_attribute (dsml_name, a_name)
		end

	add_attr (a_name, a_value: STRING) is
		require
			entry_started: is_entry_started
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			start_tag (dsml_attr)
			set_attribute (dsml_name, a_name)
			start_tag (dsml_value)
			add_data (a_value)
			stop_tag
			stop_tag
		end

	add_value (a_value: STRING) is
		require
			attr_started: is_attr_started
			no_invalid_control_characters: is_string (a_value)
		do
			start_tag (dsml_value)
			add_data (a_value)
			stop_tag
		end

	stop_dsml is
		require
			dsml_started: is_dsml_started
		do
			stop_tag
		end

	stop_directory_entries is
		require
			directory_entries_started: is_directory_entries_started
		do
			stop_tag
		end

	stop_entry is
		require
			entry_started: is_entry_started
		do
			stop_tag
		end

	stop_objectclass is
		require
			objectclass_started: is_objectclass_started
		do
			stop_tag
		end

	stop_attr is
		require
			attr_started: is_attr_started
		do
			stop_tag
		end


feature -- Queries if tags started

	is_dsml_started: BOOLEAN is
		do
			Result := is_started (dsml_dsml)
		end

	is_directory_entries_started: BOOLEAN is
		do
			Result := is_started (dsml_directory_entries)
		end

	is_entry_started: BOOLEAN is
		do
			Result := is_started (dsml_entry)
		end


	is_objectclass_started: BOOLEAN is
		do
			Result := is_started (dsml_objectclass)
		end

	is_attr_started: BOOLEAN is
		do
			Result := is_started (dsml_attr)
		end


feature -- DSML tags

	dsml_dsml: STRING is "dsml"
	dsml_directory_entries: STRING is "directory-entries"
	dsml_entry: STRING is "entry"
	dsml_objectclass: STRING is "objectclass"
	dsml_oc_value: STRING is "oc-value"
	dsml_attr: STRING is "attr"
	dsml_value: STRING is "value"


feature -- DSML attributes

	dsml_complete: STRING is "complete"
	dsml_dn: STRING is "dn"
	dsml_name: STRING is "name"


feature -- DSML name spaces

	dsml_prefix: STRING is "dsml"

	dsml_name_space: STRING is "http://www.dsml.org/DSML"

end
