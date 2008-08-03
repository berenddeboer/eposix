indexing

	description: "Test POSIX signal class."

  author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	TEST_P_SIGNAL


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions,
			execute as test_execute
		end

	POSIX_CONSTANTS

	POSIX_SIGNAL_HANDLER

	POSIX_FORK_ROOT


feature -- Tests

	test_all is
		do
			create signal.make (SIGTERM)
			signal.set_ignore_action
			signal.apply
			signal.set_default_action
			signal.apply
			signal.set_handler (Current)
			signal.apply
			signal.raise

			sleep (2)
			assert ("Handled.", handled)
			signal := Void
		end

	test_pause is
			-- Test sending a signal to a paused child.
		do
			create signal.make (SIGTERM)
			signal.set_default_action
			signal.set_handler (Current)
			signal.apply
			fork (Current)
			sleep (2)
			signal.raise_in (last_child_pid)
			wait
			sleep (2)
			signal := Void
		end

	test_signal_set is
		local
			signal_set: POSIX_SIGNAL_SET
		do
			create signal.make (SIGTERM)
			signal.set_default_action
			signal.set_handler (Current)
			signal.apply
			create signal_set.make_empty
			create signal_set.make_full
			assert ("SIGTERM is a member.", signal_set.has (SIGTERM))
			signal_set.prune (SIGTERM)
			assert ("SIGTERM no longer a member.", not signal_set.has (SIGTERM))

			create signal_set.make_empty
			signal_set.extend (SIGTERM)
			signal_set.add_to_blocked_signals
			signal.raise
			create signal_set.make_pending
			assert ("SIGTERM pending.", signal_set.has (SIGTERM))
			-- give raised signal a chance to be processed
			signal_set.remove_from_blocked_signals
			sleep (2)

			-- Suspend until SIGALRM received.
			create signal.make (SIGALRM)
			signal.set_handler (Current)
			signal.apply
			cancel_alarm
			alarm (2)
			-- make sure SIGALRM is not blocked
			create signal_set.make_full
			signal_set.prune (SIGALRM)
			signal_set.suspend

			-- chance for signal to be delivered?
			sleep (1)
			signal := Void
		end


feature {NONE} -- Implementation

	handled: BOOLEAN

	signal: POSIX_SIGNAL

	b: BOOLEAN

	signalled (signal_value: INTEGER) is
		do
			handled := True
-- 			-- print ("signalled.%N")
-- 			reestablish (signal_value)
-- 			if not b then
-- 				b := True
-- 				signal.raise
-- 			else
-- 				handled := True
-- 			end
		end

	execute is
			-- Pause until signal delivered.
		do
			--print ("In child, before pause.%N")
			pause
			--print ("After pause.%N")
			sleep (1)
		end

end
