class EX_FILE4

create

	make

feature

	make is
		local
			file: STDC_TEXT_FILE
		do
			create file.open_read ("/etc/group")
			from
				file.read_line
			until
				file.end_of_input
			loop
				print (file.last_string)
				print ("%N")
				file.read_line
			end
			file.close
		end

end
