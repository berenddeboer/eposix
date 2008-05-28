class EX_SIGNAL3

inherit

	EPX_CURRENT_PROCESS

	STDC_CONSTANTS

	STDC_SIGNAL_HANDLER


create

	make


feature

	handled: BOOLEAN

	make is
		local
			signal: STDC_SIGNAL
		do
			create signal.make (SIGINT)
			signal.set_handler (Current)
			signal.apply

			print ("Wait 10s or press Ctrl+C.%N")
			sleep (10)
			if handled then
				print ("Ctrl+C pressed.%N")
			else
				print ("Ctrl+C not pressed.%N")
			end
		end

	signalled (signal_value: INTEGER) is
		do
			handled := True
		end


end
