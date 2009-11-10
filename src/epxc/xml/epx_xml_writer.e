indexing

	description: "Class that lets you safely create an XML document."

	notes: "This is not DOM, but a kind of streaming XML generation."

	known_bugs: "Does not output correct XML for mixed content nodes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #17 $"


class

	EPX_XML_WRITER


inherit

	STDC_BASE

	EPX_XML_ROUTINES

	KL_IMPORTED_STRING_ROUTINES

	UT_CHARACTER_CODES
		export
			{NONE} all
		end


create

	make,
	make_with_capacity,
	make_fragment,
	make_fragment_with_capacity


feature -- Initialization

	make is
			-- Create an XML document with initial capacity of 1024 characters.
		do
			make_with_capacity (1024)
		ensure
			no_tag_started: not is_tag_started
			as_string_empty: as_string.is_empty
			as_uc_string_empty: as_uc_string.is_empty
			header_written: is_fragment = is_header_written
			not_fragment: not is_fragment
		end

	make_fragment is
			-- Create an XML fragment (document without header) with
			-- initial capacity of 1024 characters.
		do
			make_fragment_with_capacity (1024)
		ensure
			no_tag_started: not is_tag_started
			as_string_empty: as_string.is_empty
			as_uc_string_empty: as_uc_string.is_empty
			header_written: is_fragment = is_header_written
			fragment: is_fragment
		end

	make_with_capacity (a_capacity: INTEGER) is
			-- Create an XML document with initial capacity of
			-- `a_capacity' characters.
		local
			tester: UC_STRING_EQUALITY_TESTER
		do
			is_fragment := False
			is_indenting := True
			create my_xml.make (a_capacity)
			create my_xml.make_empty
			create tags.make (12)
			create tester
			tags.set_equality_tester (tester)
			create attributes.make
			attributes.set_equality_tester (tester)
			create values.make (48)
			values.set_key_equality_tester (tester)
			clear
		ensure
			no_tag_started: not is_tag_started
			as_string_empty: as_string.is_empty
			as_uc_string_empty: as_uc_string.is_empty
			header_written: is_fragment = is_header_written
			not_fragment: not is_fragment
		end

	make_fragment_with_capacity (a_capacity: INTEGER) is
			-- Create an XML fragment (document without header) with
			-- initial capacity of `a_capacity' characters.
		do
			make_with_capacity (a_capacity)
			is_fragment := True
			is_header_written := True
		ensure
			no_tag_started: not is_tag_started
			as_string_empty: as_string.is_empty
			as_uc_string_empty: as_uc_string.is_empty
			header_written: is_fragment = is_header_written
			fragment: is_fragment
		end


feature -- Status

	can_add_attributes: BOOLEAN is
			-- Can attributes be added to the current tag?
		do
			Result := tag_state = tag_pending or else tag_state = tag_started
		ensure
			tag_must_be_started: Result implies is_tag_started
		end

	is_a_parent (a_tag: STRING): BOOLEAN is
			-- Is `tag' the current element, or is it a parent of the
			-- current tag at some point?
		do
			Result := tags.has (a_tag)
		ensure
			started_implies_parent: is_started (a_tag) implies Result
		end

	is_attribute_set (a_name_space, an_attribute: STRING): BOOLEAN is
			-- Has `an_attribute' been given a value?
		require
			valid_attribute_name: is_ncname (an_attribute)
		do
			if a_name_space = Void or else a_name_space.is_empty then
				Result := attributes.has (an_attribute)
			else
				Result := attributes.has (a_name_space + ":" + an_attribute)
			end
		ensure
			must_be_settable: Result implies can_add_attributes
		end

	is_element_with_data: BOOLEAN
			-- Has data been added to this element or in case this
			-- element has not yet been written, has data been added to
			-- its parents element?

	is_fragment: BOOLEAN
			-- Is the XML document being created a fragment?

	is_header_written: BOOLEAN
			-- Is the XML header is written or is this a fragment that
			-- does not need a header?

	is_indenting: BOOLEAN
			-- When XML is written, is an attempt made to beautify the
			-- results? This is the default.
			-- Indented XML files are more readable, but it can create
			-- invalid XML, because the schema is not known. It also
			-- slows down writing the XML.

	is_ns_started (a_name_space, a_tag: STRING): BOOLEAN is
			-- Is name_space:tag the current element?
		require
			a_tag_not_void: a_tag /= Void
		local
			s: UC_STRING
		do
			if a_name_space /= Void and then not a_name_space.is_empty then
				create s.make_from_string (a_name_space)
				s.append_character (':')
				s.append_string (a_tag)
				Result := is_started (s)
			else
				Result := is_started (a_tag)
			end
		end

	is_started (a_tag: STRING): BOOLEAN is
			-- Is `tag' the current element?
		require
			a_tag_not_void: a_tag /= Void
		do
			Result :=
				not tags.is_empty and then
				STRING_.same_string (tags.item, a_tag)
		ensure
			definition:
				Result = (not tags.is_empty and then STRING_.same_string (tags.item, a_tag))
		end

	is_tag_started: BOOLEAN is
			-- Is there an unclosed element?
		do
			Result := not tags.is_empty
		end


feature -- Access

	as_string: STRING is
			-- The result as plain STRING
		require
			building_finished: not is_tag_started
		do
			Result := my_xml.out
		ensure
			result_not_void: Result /= Void
		end

	as_uc_string: UC_STRING is
			-- The result as Unicode string, i.e. UC_STRING
		require
			building_finished: not is_tag_started
		do
			Result := my_xml
		ensure
			result_not_void: Result /= Void
		end

	tag (i: INTEGER): STRING is
			-- Retrieve current or parents of current tag
		require
			valid_index: i >= 1 and then i <= tag_depth
		do
			Result := tags.i_th (i)
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	tag_depth: INTEGER is
			-- Number of tags that have been started, but not stopped
		do
			Result := tags.count
		ensure
			not_negative: Result >= 0
			consistent: is_tag_started = (Result /= 0)
		end

	unfinished_xml: STRING is
			-- The `xml' in progress
		do
			Result := my_xml
		ensure
			unfinished_xml_not_void: Result /= Void
		end

	xml: STRING is
			-- The result
		obsolete "Use either as_string or as_uc_string"
		do
			Result := as_string
		end


feature -- Change

	clear is
			-- Start fresh.
-- 		local
-- 			s: STRING
		do
			my_xml.wipe_out
-- 			s := my_xml
-- 			s.clear_all
			tags.wipe_out
			clear_attributes
			is_header_written := is_fragment
			tag_state := tag_closed
		ensure
			no_tags: tags.is_empty
			as_string_empty: as_string.is_empty
			as_uc_string_empty: as_uc_string.is_empty
			header_written: is_fragment = is_header_written
		end

	set_indenting (an_indenting: BOOLEAN) is
		do
			is_indenting := an_indenting
		ensure
			indenting_set: is_indenting = an_indenting
		end

feature -- Commands that expand `xml'

	add_attribute (an_attribute, a_value: STRING) is
			-- Add an attribute of the current tag. Attribute cannot be
			-- modified later unlike `set_attribute' and `a_value' does
			-- not have to be cloned if you want to reuse that STRING.
			-- `attribute' must be name-space less, else use `add_ns_attribute'.
			-- `value' may not contain an entity reference.
		require
			can_add_attributes: can_add_attributes
			valid_attribute: is_ncname (an_attribute)
			valid_value: a_value = Void or else is_string (a_value)
		do
			if a_value = Void then
				do_add_attribute (Void, an_attribute, Void)
			else
				do_add_attribute (Void, an_attribute, make_valid_attribute_value (a_value))
			end
		end

	add_a_name_space (a_prefix, a_uri: STRING) is
			-- Define a name space.
		require
			can_add_attributes: can_add_attributes
			prefix_valid: is_ncname (a_prefix)
			uri_not_empty: a_uri /= Void and then not a_uri.is_empty
		do
			add_name_space (a_prefix, a_uri)
		end

	add_cdata (a_data: STRING) is
			-- Add data within a CDATA tag. With CDATA much less
			-- meta-characters have to be quoted in case `a_data' is
			-- itself XML.
		require
			valid_point_for_data: is_tag_started
			valid_data: a_data = Void or else is_string (a_data)
		do
			assure_last_tag_written (False)
			if a_data /= Void and then not a_data.is_empty then
				extend (start_cdata_string)
				extend_with_cdata (a_data)
				extend (stop_cdata_string)
				is_element_with_data := True
			end
		ensure
			data_added:
				(a_data /= Void and then not a_data.is_empty) implies
					is_element_with_data
		end

	add_data, puts (a_data: STRING) is
			-- Write data in the current tag.
			-- Invalid characters like < or > are quoted.
			-- Use `add_raw' if you don't want quoting.
			-- This routine is not safe when writing data inside comments.
		require
			valid_point_for_data: is_tag_started
			valid_data: a_data = Void or else is_string (a_data)
		local
			uc: UC_STRING
			s: STRING
		do
			if a_data /= Void and then not a_data.is_empty then
				assure_last_tag_written (False)
				-- With the content being an UC_STRING, `extend_with_data'
				-- seems to be much faster when things have to be
				-- quoted. Do some check to call `extend_with_data' only
				-- when it might be faster.
				-- When there are no meta characters, the first method
				-- should be faster.
				uc ?= a_data
				if uc = Void and then a_data.count < 256 then
					s := a_data.twin
					replace_content_meta_characters (s)
					extend (s)
				else
					extend_with_data (a_data)
				end
				is_element_with_data := True
			end
		ensure
			data_added:
				(a_data /= Void and then not a_data.is_empty) implies
					is_element_with_data
		end

	add_entity (an_entity_name: STRING) is
			-- Write entity `name' as element data.
		require
			entity_name_not_empty:
				an_entity_name /= Void and then
				not an_entity_name.is_empty
		do
			assure_last_tag_written (False)
			extend_character ('&')
			extend (an_entity_name)
			extend_character (';')
			is_element_with_data := True
		ensure
			data_added: is_element_with_data
		end

	add_header (encoding: STRING) is
			-- Add the XML header, document is encoded in
			-- `encoding'. Making sure this encoding is followed, is the
			-- responsibility of the client.
		require
			valid_point_for_header: not is_header_written
		do
			extend (xml_header_start)
			extend (encoding)
			extend (xml_header_stop)
			new_line
			is_header_written := True
		ensure
			header_written: is_header_written
		end

	add_header_iso_8859_1_encoding is
			-- Document is iso-8859-1 encoded.
		require
			valid_point_for_header: not is_header_written
		do
			add_header (once_iso_8859_1)
		ensure
			header_written: is_header_written
		end

	add_header_utf_8_encoding is
			-- Document is utf8 encoded.
		require
			valid_point_for_header: not is_header_written
		do
			add_header (once_utf8)
		ensure
			header_written: is_header_written
		end

	add_name_space (a_prefix, a_uri: STRING) is
			-- Define a name space.
		require
			can_add_attributes: can_add_attributes
			prefix_valid: is_ncname (a_prefix)
			uri_not_empty: a_uri /= Void and then not a_uri.is_empty
		do
			do_add_attribute (xmlns, a_prefix, a_uri)
		end

	add_ns_attribute (a_name_space, an_attribute, a_value: STRING) is
			-- Add an attribute to the current tag. This attribute cannot
			-- be changed later, use `set_ns_attribute' for that.
			--  `a_value' does not have to be cloned if you want to reuse
			--  that STRING.
			-- `value' may not contain an entity reference. `name_space'
			-- is the optional prefix to be used, not the actual URI.
		require
			can_add_attributes: can_add_attributes
			valid_name_space: a_name_space = Void or else is_ncname (a_name_space)
			valid_attribute: is_ncname (an_attribute)
			attribute_not_set: not is_attribute_set (a_name_space, an_attribute)
			valid_data: a_value = Void or else is_string (a_value)
		do
			if a_value = Void then
				do_add_attribute (a_name_space, an_attribute, Void)
			else
				do_add_attribute (a_name_space, an_attribute, make_valid_attribute_value (a_value))
			end
		end

	add_raw (raw_data: STRING) is
			-- Write `raw_data' straight in the current tag, meta
			-- characters are not quoted, control characters are not
			-- checked, etc.
		do
			assure_last_tag_written (False)
			if raw_data /= Void then
				extend (raw_data)
			end
			is_element_with_data := True
			is_header_written := True
		ensure
			header_written: is_header_written
			data_added: is_element_with_data
		end

	add_system_doctype (root_tag, system_id: STRING) is
			-- Add a <!DOCTYPE element.
			-- Only allowed when no tags have been written.
		require
			have_header: is_header_written
			no_tags_written: not is_tag_started
			valid_root_tag: root_tag /= Void and then not root_tag.is_empty
			valid_system_id: system_id /= Void and then not system_id.is_empty
		do
			extend ("<!DOCTYPE ")
			extend (root_tag)
			extend (" SYSTEM %"")
			extend (system_id)
			extend ("%">")
			new_line
		end

	add_tag (a_tag, a_data: STRING) is
			-- Shortcut for `add_tag', `add_data' and `stop_tag'.
		require
			have_header: is_header_written
			valid_tag: is_name (a_tag)
			valid_data: a_data = Void or else is_string (a_data)
		do
			start_tag (a_tag)
			add_data (a_data)
			stop_tag
		end

	add_ns_tag (name_space, a_tag, a_data: STRING) is
			-- Shortcut for `add_ns_tag', `add_data' and `stop_tag'.
		require
			have_header: is_header_written
			valid_name_space:
				name_space = Void or else
				name_space.is_empty or else
				is_ncname (name_space)
			valid_tag: is_ncname (a_tag)
			valid_data: a_data = Void or else is_string (a_data)
		do
			start_ns_tag (name_space, a_tag)
			add_data (a_data)
			stop_tag
		end

	get_attribute (an_attribute: STRING): STRING is
			-- Get contents of attribute `attribute' for
			-- current tag. `attribute' may include a name space.
			-- Returns Void if attribute doesn't exist
		do
			if exist_attribute (an_attribute) then
				Result := get_value
			end
		end

	put (a: ANY) is
			-- Write data within the current tag.
		do
			add_data (a.out)
		ensure
			data_added: is_element_with_data
		end

	put_new_line is
			-- Add a new line in the current tag.
		do
			assure_last_tag_written (False)
			new_line
			is_element_with_data := True
		ensure
			data_added: is_element_with_data
		end

	set_attribute (an_attribute, a_value: STRING) is
			-- Set an attribute of the current tag.
			-- `attribute' must be name-space less, else use `set_ns_attribute'.
			-- `value' may not contain an entity reference.
			-- As the attribute is not immediately written, make sure
			-- `attribute' and `value' do not change (ie are cloned or
			-- immutable).
		require
			can_add_attributes: can_add_attributes
			valid_attribute: is_name (an_attribute)
			attribute_has_no_colon: not an_attribute.has (':')
			valid_data: a_value = Void or else is_string (a_value)
		do
			if a_value = Void then
				do_set_attribute (Void, an_attribute, Void)
			else
				do_set_attribute (Void, an_attribute, make_valid_attribute_value (a_value))
			end
		end

	set_a_name_space (a_prefix, a_uri: STRING) is
			-- Define a name space.
			-- As the attribute is not immediately written, make sure
			-- `a_prefix' and `a_uri' do not change (ie are cloned or
			-- immutable).
		require
			can_add_attributes: can_add_attributes
			prefix_not_empty: a_prefix /= Void and then not a_prefix.is_empty
			uri_not_empty: a_uri /= Void and then not a_uri.is_empty
		do
			do_set_attribute (xmlns, a_prefix, a_uri)
		end

	set_default_name_space (uri: STRING) is
			-- Set the default name space.
		require
			can_add_attributes: can_add_attributes
			uri_not_empty: uri /= Void and then not uri.is_empty
		do
			do_set_attribute (Void, xmlns, uri)
		end

	set_ns_attribute (name_space, an_attribute, value: STRING) is
			-- Set an attribute of the current tag.  `value' may not
			-- contain an entity reference. `name_space' is the optional
			-- prefix to be used, not the actual URI.
			-- As the attribute is not immediately written, make sure
			-- `name_space', `an_attribute' and `value' do not change (ie
			-- are cloned or immutable).
		require
			can_add_attributes: can_add_attributes
			valid_attribute: is_ncname (an_attribute)
		do
			if value = Void then
				do_set_attribute (name_space, an_attribute, Void)
			else
				do_set_attribute (name_space, an_attribute, make_valid_attribute_value (value))
			end
		end

	start_ns_tag (name_space, a_tag: STRING) is
			-- Start a new tag in the given `name_space'. `name_space' is
			-- a prefix only, not the actual URI. If `name_space' is Void
			-- or empty, the tag will not get a prefix.
			-- As the tag is not immediately written, be sure that `tag'
			-- does not change (ie is cloned or immutable) if
			-- `name_space' is Void or empty.
		require
			have_header: is_header_written
			valid_name_space:
				name_space = Void or else
				name_space.is_empty or else
				is_ncname (name_space)
			valid_tag: is_ncname (a_tag)
		local
			ns_tag: UC_UTF8_STRING
		do
			assure_last_tag_written (False)
			if name_space = Void or else name_space.is_empty then
				tags.put (a_tag)
			else
				create ns_tag.make (name_space.count + 1 + a_tag.count)
				ns_tag.append_string (name_space)
				ns_tag.append_character (':')
				ns_tag.append_string (a_tag)
				tags.put (ns_tag)
			end
			tag_state := tag_pending
		ensure
			tag_not_written: tag_state = tag_pending
		end

	start_tag (a_tag: STRING) is
			-- Start a new tag.
			-- As the tag is not immediately written, make sure `a_tag'
			-- does not change (ie is cloned or immutable).
		require
			have_header: is_header_written
			valid_tag: is_name (a_tag)
		do
			assure_last_tag_written (False)
			tags.force (a_tag)
			tag_state := tag_pending
		ensure
			tag_not_written: tag_state = tag_pending
		end

	stop_tag is
			-- Stop last started tag.
		require
			tag_is_started: is_tag_started
		do
			assure_last_tag_written (True)
			if tag_state /= tag_closed then
				if is_indenting then
					if not is_element_with_data and then on_new_line then
						indent
					end
				end
				extend_character ('<')
				extend_character ('/')
				extend (tags.item)
				extend_character ('>')
				if is_indenting then
					new_line_after_closing_tag (tags.item)
				end
			end
			tags.remove
			if is_tag_started then
				tag_state := tag_written
			else
				tag_state := tag_closed
			end
			is_element_with_data := False
		ensure
			no_data: not is_element_with_data
		end


feature {NONE} -- The only methods that operate directly on `my_xml'

	extend_character (c: CHARACTER) is
			-- Add `c' to `my_xml'.
		do
			my_xml.append_character (c)
		ensure
			c_added: my_xml.item (my_xml.count) = c
		end

	extend (a_data: STRING) is
			-- Add anything to the current `xml' string, you're on your own here!
			-- All changes to `my_xml' are made from here.
		require
			data_not_void: a_data /= Void
		do
			my_xml.append_string (a_data)
		end

	extend_with_cdata (a_data: STRING) is
			-- Extend `my_xml' with `a_data', but quote all >>] occurrences.
			-- Assumes a CDATA section has been started.
		require
			data_not_void: a_data /= Void
		local
			i: INTEGER
		do
			i := my_xml.count + 1
			my_xml.append_string (a_data)
			from
			--variant
				-- sort of like this: my_xml.count - i
				-- because string grows, a bit hard to express it seems
				-- but trust me, this loop will terminate :-)
			until
				i > my_xml.count - 2
			loop
				if
					my_xml.item (i) = ']' and then
					my_xml.item (i + 1) = ']' and then
					my_xml.item (i + 2) = '>'
				then
					-- CDATA sections cannot nest and don't use quoting, so
					-- stop current CDATA and start a new one, in between
					-- have the CDATA end that appears in `a_data'.
					my_xml.remove (i + 2) -- remove the >
					my_xml.insert_string (stop_cdata_string, i)
					i :=  i + stop_cdata_string.count + 2
					my_xml.insert_string (QuoteGt, i)
					i :=  i + QuoteGt.count
					my_xml.insert_string (start_cdata_string, i)
					i := i + start_cdata_string.count
				else
					i := i + 1
				end
			end
		end

	extend_with_comment (a_data: STRING) is
			-- Extend `my_xml' with `a_data', but quote all --> occurrences.
			-- Assumes a comment section has been started.
		require
			data_not_void: a_data /= Void
		local
			i: INTEGER
		do
			i := my_xml.count + 1
			my_xml.append_string (a_data)
			from
			--variant
				-- sort of like this: my_xml.count - i
				-- because string grows, a bit hard to express it seems
				-- but trust me, this loop will terminate :-)
			until
				i > my_xml.count - 2
			loop
				if
					my_xml.item (i) = '-' and then
					my_xml.item (i + 1) = '-' and then
					my_xml.item (i + 2) = '>'
				then
					-- Just quoting the > character should fix the issue.
					my_xml.remove (i + 2) -- remove the >
					my_xml.insert_string (QuoteGt, i + 2)
					i := i + 2 + QuoteGt.count
				else
					i := i + 1
				end
			end
		end

	extend_with_data (data: STRING) is
			-- Extend `my_xml' with `data', but quote any meta characters
			-- that occur in `data'.
		require
			data_not_void: data /= Void
		local
			i: INTEGER
			c: INTEGER
		do
			from
				i := 1
			until
				i > data.count
			loop
				c := data.item_code (i)
				inspect c
				when Less_than_code then
					my_xml.append_string (QuoteLt)
				when Ampersand_code then
					if i = data.count or else data.item (i+1) /= '#' then
						my_xml.append_string (QuoteAmp)
					else
						my_xml.append_item_code (c)
					end
				when Greater_than_code then
						-- Replace ]]> by ]]&gt;
					if
						i > 2 and then
						data.item (i - 1) = ']' and then
						data.item (i - 2) = ']'
					then
						my_xml.append_string (QuoteGt)
					else
						my_xml.append_item_code (c)
					end
				else
					my_xml.append_item_code (c)
				end
				i := i + 1
			end
		end


feature -- Quote unsafe characters

	replace_content_meta_characters (s: STRING) is
			-- Replace all characters in `s' that have a special meaning in
			-- XML. These characters are '<' and '&' and the sequence "]]>".
			-- This routine is slow when `data' is actually a UC_STRING
			-- and is very large. Moving bytes to the right to insert the
			-- quoting characters takes up a very long time.
		require
			s_not_void: s /= Void
		local
			i: INTEGER
			code: INTEGER
		do
			from
				i := 1
			variant
				2 + (s.count - i)
			until
				i > s.count
			loop
				code := s.item_code (i)
				inspect code
				when Less_than_code then
					s.put ('&', i)
					s.insert_string (PartQuoteLt, i+1)
					i := i + QuoteLt.count
				when Ampersand_code then
					if i = s.count or else s.item (i+1) /= '#' then
						s.insert_string (PartQuoteAmp, i+1)
						i := i + QuoteAmp.count
					else
						i := i + 3
					end
				when Greater_than_code then
						-- Replace ]]> by ]]&gt;
					if
						i > 2 and then
						s.item_code (i - 1) = Right_bracket_code and then
						s.item_code (i - 2) = Right_bracket_code
					then
						s.put ('&', i)
						s.insert_string (PartQuoteGt, i+1)
						i := i + QuoteGt.count
					else
						i := i + 1
					end
				else
					i := i + 1
				end
			end
		end


feature -- Conversion

	force_valid_string (s: STRING): STRING is
			-- `'s' with all invalid characters replaced by spaces; if
			-- there are no changes `s' is returned, else a new string
		local
			i: INTEGER
		do
			if  s /= Void then
				Result := s
				from
					i := 1
				until
					i > Result.count
				loop
					if not is_char (Result.item_code (i)) then
						if s = Result then
							Result := s.twin
						end
						Result.put (' ', i)
					end
					i := i + 1
				end
			end
		ensure
			valid_string: s /= Void implies is_string (Result)
		end


feature -- Comments

	add_comment (a_comment: STRING) is
			-- Add a comment.
			-- This routine does not yet quote meta data properly. Need a
			-- separate comment state to properly quote meta data inside
			-- comments.
		do
			start_comment
			if a_comment /= Void then
				extend_with_comment (a_comment)
			end
			stop_comment
		end


	start_comment is
			-- Write the XML comment start tag.
		do
			assure_last_tag_written (False)
			extend (start_comment_string)
			-- need to set I believe: is_element_with_data := False
		end

	stop_comment is
			-- Stop a started XML comment.
		do
			extend (stop_comment_string)
		end


feature {NONE} -- Internal xml change

	assure_last_tag_started is
			-- Make sure the current tag is written to the XML
			-- stream. Closing character '>' is not yet written, call
			-- `assure_last_tag_written' for that.
		do
			if tag_state = tag_pending then
				if is_indenting then
					if not is_element_with_data and then not on_new_line then
						new_line_before_starting_tag (tags.item)
					end
					if not is_element_with_data and then on_new_line then
						indent
					end
				end
				extend_character ('<')
				extend (tags.item)
				tag_state := tag_started
				is_element_with_data := False
			end
		ensure
			tag_is_started: tag_state = tag_started
			data_written_is_reset: old tag_state = tag_pending implies not is_element_with_data
		end

	assure_last_tag_written (may_close_tag: BOOLEAN) is
			-- Starting a tag is a delayed activity. This routine makes
			-- sure the tag is really written.
		do
			if tag_state = tag_pending or else tag_state = tag_started then
				assure_last_tag_started
				from
					attributes.start
				until
					attributes.after
				loop
					extend_character (' ')
					extend (attributes.item_for_iteration)
					extend_character ('=')
					extend_character ('"')
					values.search (attributes.item_for_iteration)
						check
							value_exists: values.found
						end
					if values.found_item /= Void then
						extend (values.found_item)
					end
					extend_character ('"')
					attributes.forth
				end
				clear_attributes
				if may_close_tag then
					extend (empty_tag_closing_chars) -- i.e. "/>"
					if is_indenting then
						new_line_after_closing_tag (tags.item)
					end
					-- This temporarily violates the invariant, is that ok?
					tag_state := tag_closed
				else
					extend_character ('>')
					tag_state := tag_written
				end
			end
		ensure
			tag_is_written: tag_state = tag_written or else tag_state = tag_closed
			tag_is_closed: (old tag_state = tag_pending or else old tag_state = tag_started) implies (may_close_tag implies tag_state = tag_closed)
			data_written_is_reset: (old tag_state = tag_pending or else old tag_state = tag_started) implies not is_element_with_data
		end

	empty_tag_closing_chars: STRING is
			-- Which characters to use for an empty tag?
			-- XHTML applications like an additional space.
		once
			Result := "/>"
		ensure
			empty_tag_closing_chars_not_empty: Result /= Void and then not Result.is_empty
		end

	indent is
			-- Indent to two spaces under parent.
		local
			spaces: STRING
		do
			inspect tags.count
			when 0, 1 then -- no indent
			when 2 then extend (two_spaces)
			when 3 then extend (four_spaces)
			when 4 then extend (six_spaces)
			when 5 then extend (eight_spaces)
			when 6 then extend (ten_spaces)
			else
				spaces := sh.make_spaces (2 * (tags.count - 1 ) )
				extend (spaces)
			end
		end

	make_valid_attribute_value (value: STRING): STRING is
			-- Convert value to something that is ok within an attribute.
			-- `value' should not contain an entity reference, because it
			-- will be quoted.
			-- Returns either `value' or a new string.
		require
			no_invalid_characters: is_string (value)
		local
			i: INTEGER
			cloned: BOOLEAN
		do
			if value /= Void then
				Result := value
				from
					i := 1
				until
					i > Result.count
				loop
					inspect Result.item (i)
					when '"' then
						if not cloned then
							create {UC_STRING} Result.make_from_string (value)
							cloned := True
						end
						Result.put ('&', i)
						Result.insert_string (PartQuoteQuote, i + 1)
						i := i + QuoteQuote.count
					when '<' then
						if not cloned then
							create {UC_STRING} Result.make_from_string (value)
							cloned := True
						end
						Result.put ('&', i)
						Result.insert_string (PartQuoteLt, i + 1)
						i := i + QuoteLt.count
					when '&' then
						if not cloned then
							create {UC_STRING} Result.make_from_string (value)
							cloned := True
						end
						Result.insert_string (PartQuoteAmp, i + 1)
						i := i + QuoteAmp.count
					else
						i := i + 1
					end
				end
			end
		end

	new_line is
			-- Write a new line now.
			-- Cannot be called indiscriminately, but only when a pending
			-- tag has been written. Use `put_new_line' for a safe variant.
		do
			extend_character ('%N')
		ensure
			cursor_on_new_line: on_new_line
		end

	new_line_after_closing_tag (a_tag: STRING) is
			-- Outputs a new line, called when `a_tag' is closed
			-- can be overridden to start a new line only occasionally
			-- For XHTML documents a new line is treated as a single
			-- space, so it can influence layout.
		require
			valid_tag: a_tag /= Void and then not a_tag.is_empty
		do
			new_line
		end

	new_line_before_starting_tag (a_tag: STRING) is
			-- Outputs a new line, called when `a_tag' is about to begin.
		require
			valid_tag: a_tag /= Void and then not a_tag.is_empty
		do
			new_line
		end


feature {NONE} -- Tags

	tags: DS_ARRAYED_STACK [STRING]
			-- Tags that have been started


feature {NONE} -- Tag attributes

	attributes: DS_LINKED_LIST [STRING]
			-- Order of attributes

	values: DS_HASH_TABLE [STRING, STRING]
			-- Attribute values

	clear_attributes is
		do
			attributes.wipe_out
			values.wipe_out
		ensure
			no_attributes: attributes.is_empty
		end

	do_add_attribute (a_name_space, an_attribute, a_value: STRING) is
			-- Raw write attribute for current tag including optional name space.
			-- Assumes all checks have been done, so `a_value' is
			-- properly quoted for example.
		require
			valid_name_space:
				a_name_space = Void or else a_name_space.is_empty or else is_ncname (a_name_space)
			attribute_is_ncname: is_ncname (an_attribute)
		do
			assure_last_tag_started
			extend_character (' ')
			if a_name_space /= Void and then not a_name_space.is_empty then
				extend (a_name_space)
				extend_character (':')
			end
			extend (an_attribute)
			extend_character ('=')
			extend_character ('"')
			if a_value /= Void then
				extend (a_value)
			end
			extend_character ('"')
		end

	do_set_attribute (a_name_space, an_attribute, a_value: STRING) is
			-- Raw set attribute for current tag including optional name space.
			-- Assumes all checks have been done, so `a_value' is
			-- properly quoted for example.
		require
			have_attribute:
				(a_name_space = Void implies
					(an_attribute /= Void and then not an_attribute.is_empty)) and
				(an_attribute = Void implies
					(a_name_space /= Void and then not a_name_space.is_empty))
			attribute_has_no_colon:
				an_attribute /= Void implies not an_attribute.has (':')
		local
			my_attribute: STRING
		do
			if a_name_space = Void or else a_name_space.is_empty then
				my_attribute := an_attribute
			else
				create {UC_UTF8_STRING} my_attribute.make (a_name_space.count + 1 + an_attribute.count)
				my_attribute.append_string (a_name_space)
				my_attribute.append_character (':')
				my_attribute.append_string (an_attribute)
			end
			values.search (my_attribute)
			if values.found then
				values.replace_found_item (a_value)
			else
				attributes.put_last (my_attribute)
				values.put (a_value, my_attribute)
			end
		ensure
			attribute_found: is_attribute_set (a_name_space, an_attribute)
			value_found:
				(a_name_space = Void or else a_name_space.is_empty implies values.has (an_attribute)) or else
				(a_name_space /= Void implies values.has (a_name_space + ":" + an_attribute))
		end

	exist_attribute (an_attribute: STRING): BOOLEAN is
			-- Has the current tag the attribute `an_attribute'?
			-- `an_attribute' may contain a name space. If true,
			-- `get_value' may be called.
		require
			attribute_not_empty: an_attribute /= Void and then not an_attribute.is_empty
		do
			values.search (an_attribute)
			Result := values.found
		ensure
			found_set: Result implies values.found
		end

	get_value: STRING is
			-- Return the contents of the last searched for attribute
			-- value. A value can be Void.
		require
			value_found: values.found
		do
			Result := values.found_item
		end


feature {NONE} -- Internal state

	my_xml: UC_STRING
			-- The string builded as we go.

	on_new_line: BOOLEAN is
			-- Is cursor on a new line?
		local
			c: INTEGER
		do
			c := my_xml.count
			Result :=
				(c = 0) or else
				(my_xml.item (c) = '%N')
		ensure
			on_new_line:
				Result implies
					my_xml.is_empty or else
					my_xml.item (my_xml.count) = '%N'
		end

	tag_state: INTEGER

	tag_pending: INTEGER is 1
			-- Is there a new tag that must be written?

	tag_started: INTEGER is 2
			-- Is the '<' + tag name written?

	tag_written: INTEGER is 3
			-- Is the currently started tag written to the stream?
			-- We employ lazy writing so we can output <a/> when there is
			-- no data for example.

	tag_closed: INTEGER is 4
			-- Is tag closed?
			-- This means the '/>' part is written.


feature {NONE} -- Other once strings

	start_comment_string: UC_UTF8_STRING is
		once
			create Result.make_from_string ("<!--")
		end

	stop_comment_string: UC_UTF8_STRING is
		once
			create Result.make_from_string ("-->")
		end

	start_cdata_string: UC_UTF8_STRING is
		once
			create Result.make_from_string ("<![CDATA[")
		end

	stop_cdata_string: UC_UTF8_STRING is
		once
			create Result.make_from_string ("]]>")
		end

	xmlns: UC_UTF8_STRING is
		once
			create Result.make_from_string ("xmlns")
		end

	xml_header_start: UC_UTF8_STRING is
		once
			create Result.make_from_string ("<?xml version=%"1.0%" encoding=%"")
		end

	xml_header_stop: UC_UTF8_STRING is
		once
			create Result.make_from_string ("%" ?>")
		end

	once_iso_8859_1: UC_UTF8_STRING is
		once
			create Result.make_from_string ("ISO-8859-1")
		end

	once_utf8: UC_UTF8_STRING is
		once
			create Result.make_from_string ("UTF-8")
		end

	two_spaces: UC_UTF8_STRING is
		once
			create Result.make_filled (' ', 2)
		end

	four_spaces: UC_UTF8_STRING is
		once
			create Result.make_filled (' ', 4)
		end

	six_spaces: UC_UTF8_STRING is
		once
			create Result.make_filled (' ', 6)
		end

	eight_spaces: UC_UTF8_STRING is
		once
			create Result.make_filled (' ', 8)
		end

	ten_spaces: UC_UTF8_STRING is
		once
			create Result.make_filled (' ', 10)
		end


invariant

	my_xml_not_void: my_xml /= Void
	same_size: attributes.count = values.count
	has_tag_stack: tags /= Void
	comparing_references_is_not_good_enough: tags.equality_tester /= Void
	fragment_has_no_header: is_fragment implies is_header_written
	values_not_void: values /= Void
	attributes_not_void: attributes /= Void
	every_attribute_has_a_value: attributes.count = values.count
	tag_state_valid: tag_state >= tag_pending and tag_state <= tag_closed
	tag_started_and_pending_in_sync: tag_state = tag_pending implies is_tag_started
	tag_closed_is_not_started: (tag_state = tag_closed) = (not is_tag_started)

end
