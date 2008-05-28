class EX_CGI4

inherit

	EPX_CGI

	EPX_FACTORY

create

	make

feature

	execute is
		do
			assert_key_value_pairs_created
			save_values

			extend ("Location: /mydir/myfile.html")
			new_line
			new_line
		end

	save_values is
		local
			fout: STDC_TEXT_FILE
			kv: EPX_KEY_VALUE
		do
			create fout.create_write (fs.temporary_directory + "/list.txt")
			from
				cgi_data.start
			until
				cgi_data.after
			loop
				kv := cgi_data.item_for_iteration
				fout.puts (kv.key)
				fout.puts ("%T")
				fout.puts (kv.value)
				fout.puts ("%N")
				cgi_data.forth
			end
			fout.close
		end

end
