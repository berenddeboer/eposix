note

	description:

		"Cursor to iterate over the key/value data structure of EPX_CGI, optionally filtering keys and/or values"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"

class

	EPX_CGI_KEY_VALUE_CURSOR


inherit

	DS_HASH_TABLE_CURSOR [EPX_KEY_VALUE, READABLE_STRING_8]
		rename
			make as make_cursor
		redefine
			forth,
			is_first,
			start,
			new_iterator
		end


create

	make


feature {NONE} -- Initialization

	make (a_container: like container; a_key_re, a_value_re: detachable RX_PCRE_REGULAR_EXPRESSION; an_on_match_found: EPX_KEY_VALUE_MATCH)
		require
			match_found_callback: an_on_match_found /= Void
			key_re_void_or_compiled: attached a_key_re implies a_key_re.is_compiled
			value_re_void_or_compiled: attached a_value_re implies a_value_re.is_compiled
		do
			make_cursor (a_container)
			key_re := a_key_re
			value_re := a_value_re
			on_match_found := an_on_match_found
		end


feature -- Status report

	new_iterator: DS_HASH_TABLE_CURSOR [EPX_KEY_VALUE, READABLE_STRING_8]
			-- For unknown reason, I had to redefine this, else ISE didn't
			-- allow me to compiler this class.
		do
			Result := container.new_iterator
		end

	is_first: BOOLEAN


feature -- Access

	on_match_found: EPX_KEY_VALUE_MATCH
			-- Callback when a match is found

	key_re,
	value_re: detachable RX_PCRE_REGULAR_EXPRESSION
			-- Optional regular expressions to mach keys and/or values


feature -- Cursor movement

	forth
			-- Move cursor to next position included in the filter.
		do
			is_first := False
			from
				precursor
			until
				after or else
				is_included
			loop
				precursor
			end
		end

	start
			-- Move cursor to first position included in the filter.
		do
			is_first := not container.is_empty
			precursor
			if not after then
				if not is_included then
					forth
				end
			end
			is_first := not after
		end


feature -- Filter check

	is_included: BOOLEAN
			-- Is current item included in the filter?
		require
			not_after: not after
		do
			Result := True
			if attached key_re as my_key_re then
				my_key_re.match (key)
				Result := my_key_re.has_matched
			end
			if Result and then attached value_re as my_value_re then
				my_value_re.match (item.value)
				Result := my_value_re.has_matched
			end
			if Result then
				Result := on_match_found.on_match (Current)
			end
		end


invariant

	key_re_void_or_compiled: attached key_re as kr implies kr.is_compiled
	value_re_void_or_compiled: attached value_re as vr implies vr.is_compiled

end
