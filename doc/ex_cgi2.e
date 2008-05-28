class EX_CGI2

inherit

	EPX_CGI

create

	make

feature

	execute is
		do
			content_text_html

			doctype
			b_html

			b_head
			title ("e-POSIX CGI form example.")
			e_head

			b_body

			b_form_get ("ex_cgi2.bin")

			b_p
			puts ("Name: ")
			b_input ("text", "name")
			set_attribute ("size", "32")
			e_input
			e_p

			b_p
			puts ("City: ")
			input_text ("city", 40, "enter city here")
			e_p

			b_p
			b_button_submit ("action", "GO!")
			e_button_submit

			nbsp

			button_reset
			e_p

			e_form

			hr

			p ("In your last submit you entered:")
			b_p
			if not has_key ("name") then
				puts ("!!!!!")
			end
			puts ("name: ")
			puts (value ("name"))
			puts (", ")
			puts ("city: ")
			puts (raw_value ("city"))
			e_p

			e_body
			e_html

		end

end
