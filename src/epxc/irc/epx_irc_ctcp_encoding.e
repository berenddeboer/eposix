indexing

	description:

		"CTCP encoding and decoding"

	known_bugs: "I'm afraid my quoting isn't perfect yet"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_IRC_CTCP_ENCODING


inherit

	ANY

	EPX_IRC_NAMES
		export
			{NONE} all
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end

	EPX_EXTERNAL_HELPER
		export
			{NONE} all
		end


feature -- Low level quoting

	ctcp_low_dequote (s: STRING): STRING is
			-- Properly unquote `s' according to the
			-- CTCP low level dequoting rules
		require
			s_not_empty: s /= Void and then not s.is_empty
		local
			i: INTEGER
		do
			Result := s.twin
			from
				i := 1
			until
				i > Result.count
			loop
				if Result.item (i) = ctcp_m_quote then
					Result.remove (i)
					if i <= Result.count then
						inspect Result.item (i)
						when '0' then
							Result.put ('%U', i)
						when 'n' then
							Result.put ('%N', i)
						when 'r' then
							Result.put ('%R', i)
						else -- continue
						end
					end
				end
				i := i + 1
			end
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	ctcp_low_quote (s: STRING): STRING is
			-- Properly quote `s' according to the
			-- CTCP low level quoting rules;
			-- Returns a new string.
		require
			s_not_empty: s /= Void and then not s.is_empty
		local
			i: INTEGER
		do
			Result := s.twin
			from
				i := 1
			until
				i > Result.count
			loop
				inspect Result.item (i)
				when '%U' then
					Result.put (ctcp_m_quote, i)
					Result.insert_character ('0', i + 1)
					i := i + 2
				when '%N' then
					Result.put (ctcp_m_quote, i)
					Result.insert_character ('n', i + 1)
					i := i + 2
				when '%R' then
					Result.put (ctcp_m_quote, i)
					Result.insert_character ('r', i + 1)
					i := i + 2
				when ctcp_m_quote then
					Result.insert_character (ctcp_m_quote, i)
					i := i + 2
				else
					i := i + 1
				end
			end
		ensure
			not_empty: Result /= Void and then not Result.is_empty
			valid_text: is_valid_text (s)
			new_string: Result /= s
		end


feature -- CTCP level quoting

	ctcp_dequote (s: STRING): STRING is
			-- `s' but without the quoting applied by `ctcp_quote';
			-- Returns a new string
		require
			s_not_void: s /= Void
		local
			i: INTEGER
		do
			Result := s.twin
			from
				i := 1
			until
				i > Result.count
			loop
				if Result.item (i) = ctcp_x_quote then
					Result.remove (i)
					-- If the quote character is the last or when any other
					-- character than the specified quoted characters
					-- follows, just remove the quote character. Shouldn't
					-- happen...
					if i <= Result.count then
						inspect Result.item (i)
						when 'a' then
							Result.put (ctcp_x_delimiter, i)
						when ctcp_x_quote then
						else -- continue
						end
					end
				end
				i := i + 1
			end
			Result := ctcp_low_dequote (Result)
		ensure
			not_empty: Result /= Void and then not Result.is_empty
			new_string: Result /= s
		end

	ctcp_quote (s: STRING): STRING is
			-- A properly quote `s', where no CTCP quoting whatsover as
			-- yet has been taken place to `s'.
		require
			s_not_empty: s /= Void and then not s.is_empty
		local
			i: INTEGER
		do
			Result := ctcp_low_quote (s)
			from
				i := 1
			until
				i > Result.count
			loop
				inspect Result.item (i)
				when ctcp_x_delimiter then
					Result.put (ctcp_x_quote, i)
					Result.insert_character ('a', i + 1)
					i := i + 2
				when ctcp_x_quote then
					Result.insert_character (ctcp_x_quote, i)
					i := i + 2
				else
					i := i + 1
				end
			end
		ensure
			not_empty: Result /= Void and then not Result.is_empty
			valid_text: is_valid_text (s)
			new_string: Result /= s
			properly_quoted: STRING_.same_string (ctcp_dequote (s), s)
		end


feature -- Extract

	extract_extended_messages (s: STRING): DS_LIST [EPX_IRC_CTCP_MESSAGE] is
			-- Extract all extended messages in `s'
		require
			s_not_void: s /= Void
		local
			i, j: INTEGER
			even_delimiter_pos: INTEGER
			data: STRING
			data_parts: ARRAY [STRING]
			msg: EPX_IRC_CTCP_MESSAGE
		do
			create { DS_LINKED_LIST [EPX_IRC_CTCP_MESSAGE] } Result.make
			from
				i := 1
			variant
				(s.count - i) + 1
			until
				i > s.count
			loop
				inspect s.item (i)
				when ctcp_x_delimiter then
					even_delimiter_pos := s.index_of (ctcp_x_delimiter, i + 1)
					-- When there is no even delimiter, this is not a CTCP
					-- message, so skip this delimiter. Also when there is
					-- no CTCP data.
					if
						even_delimiter_pos /= 0 and then
						even_delimiter_pos - i > 1
					then
						data := ctcp_dequote (s.substring (i + 1, even_delimiter_pos - 1))
						data_parts := sh.split_on (data, ' ')
						create msg.make (data_parts.item (data_parts.lower))
						Result.put_last (msg)
						from
							j := data_parts.lower + 1
						until
							j > data_parts.upper
						loop
							msg.parameters.put_last (data_parts.item (j))
							j := j + 1
						end
						i := even_delimiter_pos + 1
					else
						-- Because there are no more delimiters, we can stop
						-- scanning.
						i := s.count + 1
					end
				else
					i := i + 1
				end
			end
		end


feature -- Status

	is_valid_ctcp_tag (a_tag: STRING): BOOLEAN is
			-- Does `a_tag' follow the CTCP rules for tags?
		do
			Result :=
				a_tag /= Void and then
				not a_tag.is_empty and then
				not a_tag.has (' ')
		end


feature -- Quote characters

	ctcp_x_delimiter: CHARACTER is '%/001/'
			-- Ctrl+A

	ctcp_m_quote: CHARACTER is '%/020/'
			-- Ctrl+P

	ctcp_x_quote: CHARACTER is '%/134/'
			-- Ctrl+X, used for quoting `ctcp_x_delimiter'

end
