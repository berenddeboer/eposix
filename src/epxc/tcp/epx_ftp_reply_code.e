indexing

	description:

		"FTP reply codes"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_FTP_REPLY_CODE


inherit

	EPX_REPLY_CODE


feature -- Status for second digit of reply code in case of FTP

	is_syntax_error: BOOLEAN is
			-- Does `reply_code' denote a syntax error?
		do
			Result :=
				reply_code /= 0 and
				reply_code.out.item (2) = '0'
		end

	is_authentication_error: BOOLEAN is
			-- Does `reply_code' denote an authentication error?
		do
			Result :=
				reply_code /= 0 and
				reply_code.out.item (2) = '3'
		end

end
