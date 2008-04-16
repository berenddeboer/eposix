indexing

	description: "Class that can execute something that should take %
	%X seconds to complete. If it takes more than X seconds, the command is%
	%terminated and execute returns False."

	idea: "Inherit from this class and implement do_execute."

	known_bugs: "VE doesn't deliver an exception on SIGALRM or does something weird, so this class does not work with VE."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	POSIX_TIMED_COMMAND


inherit

	POSIX_BASE

	LAST_SIGNAL

	PAPI_UNISTD


feature -- Initialization

	make (a_seconds: INTEGER) is
		require
			valid_seconds: a_seconds >= 1 and a_seconds <= 65535
		do
			seconds := a_seconds
		ensure
			seconds_set: seconds = a_seconds
		end


feature -- Execution

	execute: BOOLEAN is
			-- Did `do_execute' complete its task within `seconds' seconds?
		require
			signal_alarm_causes_an_exception: is_signal_alarm_handled
		local
			my_signalled: BOOLEAN
			execute_tried: BOOLEAN
			done: BOOLEAN
		do
			if execute_tried then
				Result := not my_signalled
			else
				execute_tried := True
				done := False
				alarm_on
				do_execute
				done := True
				alarm_off
				Result := True
			end
		rescue
			if not assertion_violation then
				my_signalled :=
					(not done) and
					(is_signal and then signal = SIGNAL_ALARM)
				retry
			end
		end


feature {NONE} -- Alarm

	alarm_on is
			-- Turns on alarm request at `seconds' real seconds.  You can
			-- check `remaining_seconds' > 0 if a previous alarm was
			-- scheduled.
		do
			remaining_seconds := posix_alarm (seconds)
		end

	alarm_off is
			-- Turns off alarm request.
			-- Remaining seconds are in `remaining_seconds'.
		do
			remaining_seconds := posix_alarm (0)
		end

	do_execute is
			-- does the real work
		deferred
		end


feature -- Access

	is_signal_alarm_handled: BOOLEAN is
			-- Does the signal SIGNAL_ALARM cause an Eiffel exception?
		local
			my_signal: POSIX_SIGNAL
		do
			create my_signal.make (SIGNAL_ALARM)
			Result := not (my_signal.is_ignored or else my_signal.is_defaulted)
		end


feature -- State

	remaining_seconds: INTEGER
			-- number of seconds left in previous request

	seconds: INTEGER
			-- the number of seconds available to execute the command

	set_seconds (a_seconds: INTEGER) is
		do
			seconds := a_seconds
		end


invariant

	valid_seconds: seconds >= 1 and seconds <= 65535

end
