indexing

	description:

		"As UT_BASE64_ENCODING_OUTPUT_STREAM, but can flush output without having to close the base stream."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2009, Berend de Boer"
	license: "MIT License (see LICENSE)"
	date: "$Date$"
	revision: "$Revision$"


class

	EPX_BASE64_OUTPUT_STREAM


inherit

	UT_BASE64_ENCODING_OUTPUT_STREAM
		redefine
			flush
		end


create

	make


feature -- Change

	flush is
		do
			if triplet_count /= 0 then
				-- Padding will take place.
				write_quartet
			end
			base_stream.flush
		end

end
