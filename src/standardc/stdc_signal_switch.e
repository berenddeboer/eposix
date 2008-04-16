indexing

	description: "Main switch for every handled signal."

	author: "Berend de Boer"
	date: "$Date: 2003/05/08 $"
	revision: "$Revision: #4 $"

class

	STDC_SIGNAL_SWITCH


inherit

	EPX_SINGLETON

	MEMORY
		redefine
			dispose
		end


creation

	make


feature -- Initialization

	make is
		do
			create switched_signals.make (1, 32)
			epx_set_signal_switch (Current)
		end


feature -- Commands

	default_all_changed_handlers is
			-- Make sure any installed handlers return to their default
			-- action.
		local
			i: INTEGER
			has_handler: BOOLEAN
			signal: STDC_SIGNAL
		do
			from
				i := switched_signals.lower
			until
				i > switched_signals.upper
			loop
				has_handler := switched_signals.item (i) /= Void
				if has_handler then
					create signal.make (i)
					signal.set_default_action
					signal.apply
					switched_signals.put (Void, i)
				end
				i := i + 1
			end
		ensure
			no_installed_handlers: True
				-- for_each s in switched_signals it_holds s = Void
		end


feature {NONE} -- Garbage collection

	dispose is
		do
			epx_clear_signal_switch
			precursor
		end


feature {STDC_SIGNAL} -- signals to catch or ignore

	catch (a_signal: STDC_SIGNAL; a_handler: STDC_SIGNAL_HANDLER) is
			-- Make this a catched signal.
		do
			assert_can_store_signal (a_signal)
			switched_signals.put (a_handler, a_signal.value)
		end

	ignore (a_signal: STDC_SIGNAL) is
			-- This signal is no longer handled.
		do
			switched_signals.put (Void, a_signal.value)
		end


feature {STDC_SIGNAL,STDC_SIGNAL_HANDLER} -- lowest level C signal handler

	handler: POINTER is
			-- pointer to C routine that is called on signal
		do
			Result := epx_signal_handler
		end


feature {NONE} -- core switch

	switcher (a_signal: INTEGER) is
			-- Core routine, is called when a signal occurs for a catched signal.
		local
			signal_handler: STDC_SIGNAL_HANDLER
		do
			if (a_signal >= switched_signals.lower) and
				(a_signal <= switched_signals.upper) then
				signal_handler := switched_signals.item (a_signal)
				if signal_handler /= Void then
					signal_handler.signalled (a_signal)
				end
			end
		end


feature {NONE} -- state

	switched_signals: ARRAY [STDC_SIGNAL_HANDLER]

	assert_can_store_signal (signal: STDC_SIGNAL) is
			-- Make sure `signal' can be stored in `switched_signals'.
		do
			if signal.value > switched_signals.upper then
				switched_signals.resize (switched_signals.lower, signal.value)
			end
		ensure
			signal_fits:
				signal.value >= switched_signals.lower and then
				signal.value <= switched_signals.upper
		end


feature {NONE} -- C binding

	epx_clear_signal_switch is
		external "C"
		end

	epx_set_signal_switch (a_switch: STDC_SIGNAL_SWITCH) is
		require
			valid_switch: a_switch /= Void
		external "C"
		end

	epx_signal_handler: POINTER is
			-- address for e-POSIX special signal handler
		external "C"
		ensure
			valid_handler: Result /= default_pointer
		end


feature {NONE} -- Implementation

	frozen singleton: EPX_SINGLETON is
		once
			Result := Current
		end


invariant

	switched_signals_not_void: switched_signals /= Void

end
