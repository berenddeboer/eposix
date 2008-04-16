indexing

	description: "Class for handling Standard C signals."

	usage: "A given handler may be called for multiple signals."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	STDC_SIGNAL_HANDLER


inherit

	STDC_SIGNAL_SWITCH_ACCESSOR

	CAPI_SIGNAL


feature {STDC_SIGNAL_SWITCH} -- Signal callback

	signalled (signal_value: INTEGER) is
			-- Callback when signal occurs, to be implemented in
			-- descendents.  Note that during the execution of this
			-- handler, the default handler for this signal is in effect
			-- or the signal handler is reset to the default one. You
			-- have to reestablish the handler to receive the signal again.
		deferred
		end


feature {NONE} -- Routines that only make sense within `signalled'

	reestablish (signal_value: INTEGER) is
			-- Many Unixes will not deliver the signal again, i.e. they
			-- will reset the signal handler. Call this routine in your
			-- signal handler to receive the signal again. Warning: this
			-- might cause the signal to be delivered, while you are
			-- still in the signalled routine!
		local
			r: POINTER
		do
			r := posix_signal (signal_value, signal_switch.handler)
			-- ignore whatever errors
		end


end
