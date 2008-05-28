class	EX_HTTP_SERVLET2

inherit

	EPX_HTTP_SERVLET
		redefine
			get_header
		end

create

	make

feature {EPX_HTTP_SERVER} -- Execution

	get_header is
		do
			doctype
			b_html
			b_head
			title ("Customers")
			e_head
			b_body
			p ("1. John")
			p ("2. Luke")
			p ("3. Matthew")
			p ("4. Pete")
			e_body
			e_html
			write_default_header
			add_content_length
		end

end
