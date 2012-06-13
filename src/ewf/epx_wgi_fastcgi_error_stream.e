note

	description:

		"fastcgi error stream"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"
	date: "$Date$"
	revision: "$Revision$"

class

	EPX_WGI_FASTCGI_ERROR_STREAM


inherit

	WGI_ERROR_STREAM


create

	make


feature {NONE} -- Initialization

	make (a_fcgi: like fcgi)
		require
			valid_fcgi: a_fcgi /= Void
		do
			fcgi := a_fcgi
		end


feature -- Output

	put_error (a_message: READABLE_STRING_8)
			-- Report error described by `a_message'
			-- This might be used by the underlying connector
		do
			fcgi.stderr_put_line (a_message)
		end


feature {NONE} -- Implementation

	fcgi: EPX_FAST_CGI
			-- Bridge to Fast CGI world


invariant

	fcgi_attached: fcgi /= Void


end
