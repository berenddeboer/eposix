indexing

	description:

		"Test for eposix FTP client"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	TEST_FTP_CLIENT


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_CURRENT_PROCESS

	EPX_FILE_SYSTEM


feature -- Tests

	test_login is
		local
			ftp: EPX_FTP_CLIENT
		do
			create ftp.make ("localhost", "ftp", "test@localhost")
			ftp.open
			check_integers_equal ("Connected", 230, ftp.last_reply_code)
			ftp.quit
			check_integers_equal ("Quitted", 221, ftp.last_reply_code)
			ftp.close
		end

	test_list is
			-- Test the LIST and NLIST commands.
		local
			ftp: EPX_FTP_CLIENT
		do
			create ftp.make ("updates.redhat.com", "ftp", "test@localhost")
-- 			ftp.open ("localhost", "ftp", "test@localhost")
			from
				ftp.open
			until
				ftp.is_open
			loop
				if ftp.last_reply_code = 421 then
					-- Too many users, just retry
					sleep (5)
				end
				ftp.open
			end
			assert_integers_equal ("Connected", 230, ftp.last_reply_code)

			-- Test LIST
			ftp.list
			assert ("Have data connection", ftp.data_connection /= Void)
			dump_data_connection (ftp.data_connection)
			-- Get the 226 Transfer complete
			ftp.read_reply
			assert_integers_equal ("Connected", 226, ftp.last_reply_code)

			-- Test NLST
			ftp.name_list
			assert_integers_equal ("directory not empty.", 150, ftp.last_reply_code)
			assert ("Have data connection", ftp.data_connection /= Void)
			dump_data_connection (ftp.data_connection)
			-- Get the 226 Transfer complete
			ftp.read_reply
			assert_integers_equal ("Connected", 226, ftp.last_reply_code)

			ftp.quit
			ftp.close
		end

	test_retrieve is
		local
			ftp: EPX_FTP_CLIENT
		do
			create ftp.make ("localhost", "ftp", "test@localhost")
			ftp.open
			assert_integers_equal ("Connected", 230, ftp.last_reply_code)
			ftp.change_directory ("pub")
			ftp.change_to_parent_directory
			ftp.change_directory ("pub")
			ftp.retrieve ("test.pl")
			assert ("Have data connection", ftp.data_connection /= Void)
			dump_data_connection (ftp.data_connection)
			ftp.read_reply
			ftp.type_ascii
			ftp.retrieve ("test.pl")
			assert ("Have data connection", ftp.data_connection /= Void)
			dump_data_connection (ftp.data_connection)
			ftp.read_reply
			ftp.type_binary
			ftp.retrieve ("test.pl")
			assert ("Have data connection", ftp.data_connection /= Void)
			dump_data_connection (ftp.data_connection)
			ftp.read_reply
			assert_integers_equal ("Transfer complete", 226, ftp.last_reply_code)
			ftp.quit
			ftp.close
		end

	test_store is
		local
			ftp: EPX_FTP_CLIENT
			s: STRING
		do
			create ftp.make_anonymous ("localhost", "test@localhost")
			ftp.open
			assert_integers_equal ("Connected", 230, ftp.last_reply_code)
			ftp.change_directory ("incoming")
			ftp.make_directory ("upload")
			assert ("Directory created", ftp.is_command_ok)
			ftp.remove_directory ("upload")
			assert ("Directory created", ftp.is_command_ok)

			ftp.type_binary
			ftp.store ("test_ftp_client.e")
			s := file_content_as_string ("test_ftp_client.e")
			ftp.data_connection.write_string (s)
			ftp.data_connection.close
			ftp.read_reply
			assert ("Upload ok", ftp.is_command_ok)

			ftp.rename_to ("test_ftp_client.e", "to_be_removed")
			assert ("Rename successful", ftp.is_command_ok)
			ftp.remove_file ("to_be_removed")
			assert ("File removed", ftp.is_command_ok)

			ftp.quit
			ftp.close
		end

	test_status is
			-- Test various info and status commands.
		local
			ftp: EPX_FTP_CLIENT
		do
			create ftp.make ("localhost", "ftp", "test@localhost")
			ftp.open
			assert_integers_equal ("Connected", 230, ftp.last_reply_code)
			ftp.help
			ftp.operating_system
			assert_integers_equal ("Command ok", 215, ftp.last_reply_code)
			assert ("Got Operating System", not ftp.server_operating_system.is_empty)
			debug ("test")
				print ("os: '")
				print (ftp.server_operating_system)
				print ("'%N")
			end
			--ftp.status
			ftp.noop
			ftp.quit
			ftp.close
		end


feature {NONE} -- Implementation

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

end
