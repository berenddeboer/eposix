indexing

	description: "Test Standard C signal class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_SIGNAL


inherit

	TS_TEST_CASE

	STDC_CONSTANTS

	STDC_SIGNAL_HANDLER


feature

	got_signal: BOOLEAN

	test_signal is
		local
			signal: STDC_SIGNAL
			start, now: STDC_TIME
		do
			create signal.make (SIGTERM)
			signal.set_ignore_action
			signal.apply
			signal.raise
			signal.set_default_action
			signal.apply
			signal.set_handler (Current)
			signal.apply
			signal.raise

			-- wait 2 seconds
			from
				create start.make_from_now
				create now.make_from_now
			until
				now.value - start.value > 2
			loop
				now.make_from_now
			end

			assert ("Signalled.", got_signal)
		end

	signalled (signal_value: INTEGER) is
		do
			got_signal := True
		end

end
