indexing

	description:

		"Easy access to crypto calculations"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2010, Berend de Boer"
	license: "MIT License (see LICENSE)"
	date: "$Date$"
	revision: "$Revision$"


class

	EPX_CRYPTO_FEATURES


feature -- Queries

	md5sum (s: STRING): STRING is
			-- md5 checksum of string `s'
		local
			c: EPX_MD5_CALCULATION
		do
			create c.make
			c.put_string (s)
			c.finalize
			Result := c.checksum
		ensure
			not_void: Result /= Void
			valid_length: Result.count = 32
		end


end
