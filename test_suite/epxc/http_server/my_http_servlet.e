indexing

	description: "Test HTTP servlet."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	MY_HTTP_SERVLET


inherit

	EPX_HTTP_SERVLET
		redefine
			allowed_methods,
			get_header,
			post_body,
			post_header
		end


create

	make


feature -- Access

	allowed_methods: STRING is "GET, POST"
			-- What methods does the resource captured by this servlet
			-- allow?

	last_request_form_fields: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]


feature {EPX_HTTP_SERVER} -- Servlet implementation

	get_header is
			-- Write response body.
		do
			write_default_header
			last_request_form_fields := connection.request_form_fields
		end

	post_header is
			-- Write response header to POST request. You have to
			-- write everything, including the response code.
		do
			write_default_header
			last_request_form_fields := connection.request_form_fields
		end

	post_body is
		do
			doctype_strict
			b_html
			b_body
			b_p
			add_data (connection.request_body.parts_count.out)
			e_p
			e_body
			e_html
		end

end
