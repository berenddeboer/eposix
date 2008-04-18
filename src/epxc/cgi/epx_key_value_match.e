indexing

	description:

		"Callback class when EPX_CGI_KEY_VALUE_CURSOR has found a match."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	EPX_KEY_VALUE_MATCH


feature {EPX_CGI_KEY_VALUE_CURSOR} -- Callback

	on_match (a_cursor: EPX_CGI_KEY_VALUE_CURSOR): BOOLEAN is
			-- Callback when `a_cursor'.`key_re' and
			-- `a_cursor'.`value_re' has matched and should return True
			-- if match is valid
		require
			key_re_void_or_compiled: a_cursor.key_re /= Void implies a_cursor.key_re.has_matched
			value_re_void_or_compiled: a_cursor.value_re /= Void implies a_cursor.value_re.has_matched
		deferred
		end


end
