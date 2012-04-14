note

	description:

		"WGI_OUTPUT_STREAM binding for eposix"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_WGI_FASTCGI_OUTPUT_STREAM


inherit

	WGI_OUTPUT_STREAM


inherit {NONE}

	HTTP_STATUS_CODE_MESSAGES


create

	make


feature {NONE} -- Initialization

	make (a_fcgi: like fcgi)
		require
			valid_fcgi: a_fcgi /= Void
		do
			fcgi := a_fcgi
		end


feature -- Status report

	is_open_write: BOOLEAN
			-- Can items be written to output stream?
		do
			Result := fcgi.socket.is_open_write
		end


feature -- Status writing

	put_status_line (a_code: INTEGER; a_reason_phrase: detachable READABLE_STRING_8)
			-- Put status code line for `a_code'
			--| Note this is a default implementation, and could be redefined
			--| for instance in relation to NPH CGI script
		local
			s: STRING
		do
			--| Do not send any Status line back to the FastCGI client
			--| According to http://www.fastcgi.com/docs/faq.html#httpstatus
			if a_code /= 200 then
				create s.make (16)
				s.append ("Status:")
				s.append_character (' ')
				s.append_integer (a_code)
				if attached a_reason_phrase as l_status_message then
					s.append_character (' ')
					s.append_string (l_status_message)
				elseif attached http_status_code_message (a_code) as l_status_message then
					s.append_character (' ')
					s.append_string (l_status_message)
				end
				put_header_line (s)
			end
		end

feature -- Basic operation

	put_character (c: CHARACTER_8)
			-- Send `c' to http client
		do
			fcgi.put_character (c)
		end

	put_string (s: READABLE_STRING_8)
			-- Send `s' to http client
		do
			fcgi.put_string (s)
		end


feature -- Basic operations

	flush
			-- Flush buffered data to disk.
		do
		end


feature {NONE} -- Implementation

	fcgi: EPX_FAST_CGI
			-- Bridge to Fast CGI world


invariant

	fcgi_attached: fcgi /= Void

end
