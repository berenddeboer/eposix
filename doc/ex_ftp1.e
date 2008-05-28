class	EX_FTP1

create

	make

feature

	make is
		local
			ftp: EPX_FTP_CLIENT
		do
			-- ftp://ftp.nlm.nih.gov/nlmdata/sample/serfile/serfilesamp2005.xml
			create ftp.make_anonymous (server_name, "guest")
			ftp.open
			if ftp.is_positive_completion_reply then
				ftp.change_directory (directory_name)
				ftp.name_list
				dump_data_connection (ftp.data_connection)
				ftp.read_reply
				ftp.retrieve (file_name)
				dump_data_connection (ftp.data_connection)
				ftp.read_reply
				ftp.quit
				ftp.close
			else
				print ("Connect fails.%N")
			end
		end

	dump_data_connection (stream: KI_CHARACTER_INPUT_STREAM) is
			-- Dump stream input.
		require
			stream_not_void: stream /= Void
		do
			from
				stream.read_character
			until
				stream.end_of_input
			loop
				print (stream.last_character)
				stream.read_character
			end
			stream.close
		end

feature -- Access

	directory_name: STRING is "/pub/FreeBSD"

	file_name: STRING is "README.TXT"

	server_name: STRING is "ftp.freebsd.org"

end
