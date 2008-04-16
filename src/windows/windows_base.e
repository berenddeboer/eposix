indexing

	description: "Base class for WINDOWS classes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

class

	WINDOWS_BASE


inherit

	STDC_BASE
		redefine
			raise_posix_error
		end

	WINDOWS_CONSTANTS
		export
			{NONE} all
		end

	WAPI_WINDOWS
		export
			{NONE} all
		end

	WAPI_WINSOCK2
		export
			{NONE} all
		end


feature {NONE} -- Windows specific exceptions

	raise_posix_error is
			-- Throws an exception when something that is considered
			-- fatal has occurred.
			-- Exception throwing can be disabled by calling
			-- `security.error_handling.disable_exceptions'.
			-- This routine usese `posix_geterrormessage' when an
			-- exception is raised instead of `posix_strmessage'.
		do
			if raise_exception_on_error then
				-- Unfreeze strings first because with exception we might
				-- not hit the unfreeze call in the caller.
				sh.unfreeze_all
				do_raise (sh.pointer_to_string (posix_geterrormessage (errno.value)))
			else
				if errno.first_value = 0 then
					errno.set_first
				end
			end
		end

	raise_windows_error is
			-- Windows specific variant of `raise_posix_error'
			-- Uses GetLastError for error handling.
		do
			errno.set_value (posix_getlasterror)
			if raise_exception_on_error then
				-- Unfreeze strings first because with exception we might
				-- not hit the unfreeze call in the caller.
				sh.unfreeze_all
				do_raise (sh.pointer_to_string (posix_geterrormessage (errno.value)))
			else
				if errno.first_value = 0 then
					errno.set_first
				end
			end
		end

	safe_win_call (success: BOOLEAN) is
			-- If not `success', raise an exception if exceptions are
			-- enabled.
		do
			if not success then
				raise_windows_error
			end
		end

	raise_wsa_error is
			-- Windows sockets specific variant of `raise_posix_error'.
			-- Uses GetLastError for error handling.
		do
			errno.set_value (posix_wsagetlasterror)
			if raise_exception_on_error then
				-- Unfreeze strings first because with exception we might
				-- not hit the unfreeze call in the caller.
				sh.unfreeze_all
				do_raise (once_wsa_error_message + errno.value.out)
			else
				if errno.first_value = 0 then
					errno.set_first
				end
			end
		end

	safe_wsa_call (return_code: INTEGER) is
			-- If `return_code' is `SOCKET_ERROR', raise an exception if
			-- exceptions are enabled.
		do
			if return_code = SOCKET_ERROR then
				raise_wsa_error
			end
		end


feature {NONE} -- Implementation

	once_wsa_error_message: STRING is "WSAGetLastError: "

end
