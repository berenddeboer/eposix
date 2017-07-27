note

	description: "Class that covers Standard C signal.h."

	author: "Berend de Boer"


class

	CAPI_SIGNAL


feature -- Standard C binding

	posix_raise (a_sig: INTEGER): INTEGER
			-- Sends a signal
		require
			valid_signal: a_sig >= 0
		external "C"
		end

	posix_signal (a_sig: INTEGER; a_func: POINTER): POINTER
			-- Specifies signal handling
		require
			valid_signal: a_sig >= 0
		external "C"
		end

	posix_enable_custom_signal_handler_1 (a_sig: INTEGER)
			-- Listen to signal `a_sig'. Use
			-- `posix_is_custom_signal_handler_1_signalled' to check if
			-- it has been signalled.
			-- Signal handlers in Eiffel don't really work, so it's
			-- better to install a C based one. Listening for SIGTERM is
			-- usually fine if you quit the app, anything you want to
			-- listen to repeatedly, better use this.
		require
			valid_signal: a_sig >= 0
		external "C"
		end

	posix_is_custom_signal_handler_1_signalled (a_sig: INTEGER): BOOLEAN
		require
			valid_signal: a_sig >= 0
		external "C"
		end

	posix_enable_custom_signal_handler_2 (a_sig: INTEGER)
			-- Listen to signal `a_sig'. Use
			-- `posix_is_custom_signal_handler_2_signalled' to check if
			-- it has been signalled.
		require
			valid_signal: a_sig >= 0
		external "C"
		end

	posix_is_custom_signal_handler_2_signalled (a_sig: INTEGER): BOOLEAN
		require
			valid_signal: a_sig >= 0
		external "C"
		end

end
