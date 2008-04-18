indexing

	description:

		"Class to use native facilities of Eiffel compiler for fastest i/o"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	ABSTRACT_IO_HELPER


inherit

	ANY

	STDC_CONSTANTS
		export
			{NONE} all
		end

	CAPI_STDIO
		export
			{NONE} all
		end

	UC_STRING_HANDLER
		export
			{NONE} all
		end


feature -- Stream i/o

	stream_put_string (a_stream: POINTER; a_string: STRING): INTEGER is
			-- Number of bytes written if writing `a_string' to
			-- `a_stream' was successful, `const_EOF' otherwise.
			-- It is probably a very good idea to turn on buffering for
			-- `a_stream'.
		require
			stream_not_nil: a_stream /= default_pointer
			a_string_not_void: a_string /= Void
		local
			uc: UC_STRING
			r: INTEGER
			i: INTEGER
		do
			uc ?= a_string
			if uc /= Void then
				from
					i := 1
				until
					r = const_EOF or else
					i >= uc.byte_count
				loop
					r := posix_fputc (uc.byte_item (i).code, a_stream)
					r := posix_fputc (uc.byte_item (i + 1).code, a_stream)
					i := i + 2
				end
				if r /= const_EOF and then i = uc.byte_count then
					r := posix_fputc (uc.byte_item (i).code, a_stream)
				end
				if r /= const_EOF then
					Result := uc.byte_count
				else
					Result := r
				end
			else
				-- Write using unrolled loop
				from
					i := 1
				until
					r = const_EOF or else
					i >= a_string.count
				loop
					r := posix_fputc (a_string.item (i).code, a_stream)
					r := posix_fputc (a_string.item (i + 1).code, a_stream)
					i := i + 2
				end
				if i = a_string.count then
					r := posix_fputc (a_string.item (i).code, a_stream)
				end
				if r /= const_EOF then
					Result := a_string.count
				else
					Result := r
				end
			end
		end


end
