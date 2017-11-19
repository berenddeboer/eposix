note

	description:

		"Write DSML v1 XML"

	examples: "http://www.dsmltools.org/dsml.org/dsml.html"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer"


class

	EPX_DSML_V1_WRITER


inherit
	ANY

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

	start_dsml
		require
			have_header: is_header_written
			this_is_root_tag: not is_tag_started
		do
			start_tag (dsml_dsml)
			-- write default value for complete attribute
			set_attribute (dsml_complete, "true")
			set_default_name_space (dsml_name_space)
		end

	start_directory_entries
		require
			dsml_started: is_dsml_started
		do
			start_tag (dsml_directory_entries)
		end

	start_entry (a_distinguished_name: STRING)
		require
			directory_entries_started: is_directory_entries_started
		do
			start_tag (dsml_entry)
			set_attribute(dsml_dn, a_distinguished_name)
		end

	start_objectclass
		require
			dsml_started: is_entry_started
		do
			start_tag (dsml_objectclass)
		end

	add_oc_value (a_value: STRING)
		require
			objectclass_started: is_objectclass_started
		do
			add_tag (dsml_oc_value, a_value)
		end

	start_attr (a_name: STRING)
		require
			entry_started: is_entry_started
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			start_tag (dsml_attr)
			set_attribute (dsml_name, a_name)
		end

	add_attr (a_name, a_value: STRING)
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

	add_value (a_value: STRING)
		require
			attr_started: is_attr_started
			no_invalid_control_characters: is_string (a_value)
		do
			start_tag (dsml_value)
			add_data (a_value)
			stop_tag
		end

	stop_dsml
		require
			dsml_started: is_dsml_started
		do
			stop_tag
		end

	stop_directory_entries
		require
			directory_entries_started: is_directory_entries_started
		do
			stop_tag
		end

	stop_entry
		require
			entry_started: is_entry_started
		do
			stop_tag
		end

	stop_objectclass
		require
			objectclass_started: is_objectclass_started
		do
			stop_tag
		end

	stop_attr
		require
			attr_started: is_attr_started
		do
			stop_tag
		end


feature -- Queries if tags started

	is_dsml_started: BOOLEAN
		do
			Result := is_started (dsml_dsml)
		end

	is_directory_entries_started: BOOLEAN
		do
			Result := is_started (dsml_directory_entries)
		end

	is_entry_started: BOOLEAN
		do
			Result := is_started (dsml_entry)
		end


	is_objectclass_started: BOOLEAN
		do
			Result := is_started (dsml_objectclass)
		end

	is_attr_started: BOOLEAN
		do
			Result := is_started (dsml_attr)
		end


feature -- DSML tags

	dsml_dsml: STRING = "dsml"
	dsml_directory_entries: STRING = "directory-entries"
	dsml_entry: STRING = "entry"
	dsml_objectclass: STRING = "objectclass"
	dsml_oc_value: STRING = "oc-value"
	dsml_attr: STRING = "attr"
	dsml_value: STRING = "value"


feature -- DSML attributes

	dsml_complete: STRING = "complete"
	dsml_dn: STRING = "dn"
	dsml_name: STRING = "name"


feature -- DSML name spaces

	dsml_prefix: STRING = "dsml"

	dsml_name_space: STRING = "http://www.dsml.org/DSML"

end
