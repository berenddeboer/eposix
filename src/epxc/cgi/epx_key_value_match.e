note

	description:

		"Callback class when EPX_CGI_KEY_VALUE_CURSOR has found a match."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"


deferred class

	EPX_KEY_VALUE_MATCH


feature {EPX_CGI_KEY_VALUE_CURSOR} -- Callback

	on_match (a_cursor: EPX_CGI_KEY_VALUE_CURSOR): BOOLEAN
			-- Callback when `a_cursor'.`key_re' and
			-- `a_cursor'.`value_re' has matched and should return True
			-- if match is valid
		require
			key_re_void_or_compiled: attached a_cursor.key_re as re implies re.has_matched
			value_re_void_or_compiled: attached a_cursor.value_re as re implies re.has_matched
		deferred
		end


end
