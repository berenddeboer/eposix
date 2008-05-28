class EX_CGI3

inherit

	EPX_CGI

create

	make

feature

	execute is
		do
			content_text_html

			assert_key_value_pairs_created
			save_uploaded_files

			doctype
			b_html

			b_head
			title ("e-POSIX CGI file upload example.")
			e_head

			b_body

			b_form ("post", "ex_cgi3.bin")
			set_attribute ("enctype", mime_type_multipart_form_data)

			b_p
			puts ("Filename: ")
			b_input ("file", "filename")
			set_attribute ("size", "32")
			set_attribute ("maxlength", "128")
			e_input
			e_p

			b_p
			b_button_submit ("action", "Upload file(s)")
			e_button_submit

			nbsp

			button_reset
			e_p

			e_form

			e_body
			e_html

		end

	save_uploaded_files is
		local
			kv: EPX_KEY_VALUE
			buffer: STDC_BUFFER
			target_name: STRING
			target: STDC_BINARY_FILE
		do
			create buffer.allocate (8192)
			from
				cgi_data.start
			until
				cgi_data.after
			loop
				kv := cgi_data.item_for_iteration
				if kv.file /= Void then
					from
						target_name := "/tmp/" + kv.value
						create target.create_write (target_name)
						kv.file.read_buffer (buffer, 0, 8192)
					until
						kv.file.end_of_input
					loop
						target.write_buffer (buffer, 0, kv.file.last_read)
						kv.file.read_buffer (buffer, 0, 8192)
					end
					target.close
					kv.file.close
				end
				cgi_data.forth
			end
			buffer.deallocate
		end

end
