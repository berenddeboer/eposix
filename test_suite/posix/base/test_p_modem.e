indexing

	description: "Test Posix terminal functions by querying a modem."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

deferred class

	TEST_P_MODEM


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS

	POSIX_FILE_SYSTEM


feature

	test_all is
		local
			modem: POSIX_FILE_DESCRIPTOR
			term: POSIX_TERMIOS
		do
			if is_writable ("/dev/modem") then
				create modem.open_read_write ("/dev/modem")
				term := modem.terminal
				term.flush_input
				print ("Input speed: ")
				print (term.speed_to_baud_rate (term.input_speed))
				print ("%N")
				print ("Output speed: ")
				print (term.speed_to_baud_rate (term.output_speed))
				print ("%N")
				print ("Receive enabled: ")
				print (term.is_receiving)
				print ("%N")
				term.set_input_speed (B9600)
				term.set_output_speed (B9600)
				term.set_receive (True)
				term.set_echo_input (False)
				term.set_echo_new_line (False)
				term.set_input_control (True)
				term.apply_flush

				print ("Input speed: ")
				print (term.speed_to_baud_rate (term.input_speed))
				print ("%N")
				print ("Output speed: ")
				print (term.speed_to_baud_rate (term.output_speed))
				print ("%N")
				print ("Receive enabled: ")
				print (term.is_receiving)
				print ("%N")
				print ("Input echoed: ")
				print (term.is_input_echoed)
				print ("%N")

				-- expect modem to echo commands
				modem.write_string ("AT%N")
				-- sleep (2)
				modem.read_string (64)
				print ("Command: ")
				print (modem.last_string)
				modem.read_string (64)
				print ("Response (expect ok): ")
				print (modem.last_string)
				modem.write_string ("ATI0%N")
				-- sleep (2)
				modem.read_string (64)
				print ("Command: ")
				print (modem.last_string)
				modem.read_string (64)
				print ("Response: ")
				print (modem.last_string)
				modem.read_string (64)
				print ("Response: ")
				print (modem.last_string)
				modem.close
			else
				print ("!! modem link /dev/modem not found or not writable.%N")
			end
		end

end
