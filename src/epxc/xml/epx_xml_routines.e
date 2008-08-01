indexing

	description: "Various routines to help creating XML."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"


class

	EPX_XML_ROUTINES


inherit

	XM_UNICODE_CHARACTERS_1_0


feature -- Status

	is_valid_attribute_name (a_name: STRING): BOOLEAN is
		obsolete "2006-06-30: Please use `is_name' instead"
		do
			Result := is_name (a_name)
		end

	is_valid_tag_name (a_name: STRING): BOOLEAN is
		obsolete "2006-06-30: Please use `is_name' instead"
		do
			Result := is_name (a_name)
		end

	is_valid_ncname (a_name: STRING): BOOLEAN is
		obsolete "2006-06-30: Please use `is_ncname' instead"
		do
			Result := is_ncname (a_name)
		end

	has_invalid_control_characters (s: STRING): BOOLEAN is
			-- If `s' is not Void, does `s' contain characters in the range
			-- 0x00-0x1F other then TAB (0x09), CR (0x0A) and LF (0x0D)?
		obsolete "2006-06-30: Please use not `is_string' instead"
		do
			Result := not is_string (s)
		ensure
			void_or_empty_is_correct: (s = Void or else s.is_empty) implies not Result
		end


feature -- Conversions

	as_valid_tag_name (a_tag_name: STRING): STRING is
			-- Return `a_tag_name' with invalid characters removed or
			-- replaced by '_'.
		require
			a_tag_name_not_empty: a_tag_name /= Void and then not a_tag_name.is_empty
		local
			i: INTEGER
		do
			if not is_name_first (a_tag_name.item_code (1)) then
				Result := a_tag_name.twin
				Result.put ('_', 1)
			end
			from
				i := 2
			invariant
				Result = Void or else Result.count = a_tag_name.count
			variant
				(a_tag_name.count + 1) - i
			until
				i > a_tag_name.count
			loop
				if not is_name_char (a_tag_name.item_code (i)) then
					if Result = Void then
						Result := a_tag_name.twin
					end
					Result.put ('-', i)
				end
				i := i + 1
			end
			if Result = Void then
				Result := a_tag_name
			end
		ensure
			valid_tag_name: is_ncname (Result)
		end

	quote_apostrophe (s: STRING): STRING is
			-- `s' with every occurrence of ' replaced by &apos;
		require
			s_not_void: s /= Void
		local
			p: INTEGER
			i: INTEGER
			c: CHARACTER
		do
			-- Optimized for the case that `s' does not contain an
			-- apostrophe. Read optimized as: I think it is faster.
			p := s.index_of ('%'', 1)
			if p = 0 then
				Result := s
			else
				from
					create Result.make_from_string (s)
					i := p
				until
					i > Result.count
				loop
					c := Result.item (i)
					if c = '%'' then
						Result.put ('&', i)
						Result.insert_string (PartQuoteApos, i + 1)
						i := i + QuoteApos.count
					else
						i := i + 1
					end
				end
			end
		ensure
			result_not_void: Result /= Void
			result_at_least_s: Result.count >= s.count
			has_no_apostrophe: not Result.has ('%'')
		end


feature {NONE} -- Data sanitize

	Ampersand_code: INTEGER is 38
			-- '&'

	QuoteAmp: STRING is "&amp;"
	QuoteApos: STRING is "&apos;"
	QuoteLt: STRING is "&lt;"
	QuoteGt: STRING is "&gt;"
	QuoteQuote: STRING is "&quot;"

	PartQuoteAmp: STRING is "amp;"
	PartQuoteApos: STRING is "apos;"
	PartQuoteLt: STRING is "lt;"
	PartQuoteGt: STRING is "gt;"
	PartQuoteQuote: STRING is "quot;"


feature -- Constants from the XML specification, should be Unicode...

	ValidFirstChars: STRING is
			-- Which characters are valid as the first character.
		obsolete "2006-06-30: please use `is_name_first'"
		once
			Result :=  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_:"
		end

	ValidOtherChars: STRING is
			-- Which characters are valid as second etc characters.
		obsolete "2006-06-30: please use `is_name_char'"
		once
			Result := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_:.-0123456789"
		end


end
