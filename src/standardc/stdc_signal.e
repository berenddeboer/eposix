indexing

	description: "Class that covers a single Standard C signal."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	STDC_SIGNAL

inherit

	STDC_BASE

	CAPI_SIGNAL

	STDC_SIGNAL_SWITCH_ACCESSOR


create

	make


feature -- creation

	make (a_value: INTEGER) is
		require
			valid_signal: a_value >= 1
		do
			value := a_value
		end


feature -- set signal properties, make effective with `apply'

	apply is
			-- Make changes effective.
		local
			r: POINTER
		do
			signal_switch.ignore (Current)
			r := posix_signal (value, my_handler)
			if r = SIG_ERR then
				raise_posix_error
			end
			if my_callback /= Void then
				signal_switch.catch (Current, my_callback)
			end
		end

	set_default_action is
			-- Install signal-specific default action.
			-- Call `apply' to make changes effective.
		do
			my_handler := SIG_DFL
			my_callback := Void
		end

	set_ignore_action is
			-- Set action to ignore signal.
			-- Call `apply' to make changes effective.
		require
			ignorable: is_ignorable
		do
			my_handler := SIG_IGN
			my_callback := Void
		end

	set_handler (a_handler: STDC_SIGNAL_HANDLER) is
			-- Install one's own signal handler.
		do
			my_handler := signal_switch.handler
			my_callback := a_handler
		end


feature -- signal functions

	raise is
			-- Raise the signal.
		do
			safe_call (posix_raise (value))
		end


feature -- signal state

	is_ignorable: BOOLEAN is
			-- All signals Standard C knows about are ignorable...
		do
			Result := True
		end

	value: INTEGER
			-- the signal


feature {NONE} -- private state

	my_callback: STDC_SIGNAL_HANDLER
			-- Eiffel callback class (if any)

	my_handler: POINTER
			-- C sigaction struct


invariant

	valid_signal_value: value >= 1


end -- class STDC_SIGNAL
