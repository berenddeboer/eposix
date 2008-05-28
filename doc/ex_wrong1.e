class EX_WRONG1

create

	make

feature

	make is
		local
			file: POSIX_TEXT_FILE
		do
			create file.open_read ("/etc/group")
			from
			until
				file.end_of_input
			loop
				file.read_string (256)
				print (file.last_string)
			end
			file.close
		end

end
