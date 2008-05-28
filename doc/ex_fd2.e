class EX_FD2

create

	make

feature

	make is
		local
			fd: POSIX_FILE_DESCRIPTOR
			file: POSIX_TEXT_FILE
		do
			create fd.open_read ("/etc/group")
			create file.make_from_file_descriptor (fd, "r")
			from
				file.read_string (256)
			until
				file.end_of_input
			loop
				print (file.last_string)
				file.read_string (256)
			end
			file.close
			fd.close
		end

end
