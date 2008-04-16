indexing

	description: "Test cgi form input iteration."

	author: "Berend de Boer"
	date: "$Date: 2007/01/25 $"
	revision: "$Revision: #1 $"


deferred class

	TEST_CGI_KEY_VALUE_ITERATION


inherit

	TS_TEST_CASE
		redefine
			make_test,
			set_up
		end

	EPX_CGI
		rename
			execute as test_execute
		end

	EPX_KEY_VALUE_MATCH


feature -- Initialization

	make_test (an_id: INTEGER; a_variables: like variables) is
		do
			precursor (an_id, a_variables)
			make_xhtml_writer
			create header.make_default
		end


feature -- Test

	set_up is
		do
			clear
		end

	test_execute is
		local
			c: EPX_CGI_KEY_VALUE_CURSOR
		do
			content_text_html

			doctype
			b_html

			b_head
			title ("e-POSIX CGI form handling example.")
			e_head

			b_body
			c := new_key_value_cursor (Void, Void, Current)
			from
				c.start
			until
				c.after
			loop
				c.forth
			end
			e_body

			e_html
		end


feature {EPX_CGI_KEY_VALUE_CURSOR} -- Callback

	on_match (a_cursor: EPX_CGI_KEY_VALUE_CURSOR): BOOLEAN is
			-- Callback when `a_cursor'.`key_re' and
			-- `a_cursor'.`value_re' has matched and should return True
			-- if match is valid
		do
			Result := True
		end


end
