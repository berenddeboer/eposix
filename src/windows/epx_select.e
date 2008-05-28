indexing

	description: "Windows select() call."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_SELECT


inherit

	ABSTRACT_SELECT
		undefine
			raise_posix_error
		end

	WINDOWS_BASE

	WAPI_WINSOCK2
		export
			{NONE} all
		end


create

	make


feature {NONE} -- Abstract API

	abstract_select (a_maxfdp1: INTEGER; a_readset, a_writeset, an_exceptset: POINTER; a_timeout: POINTER): INTEGER is
			-- Wait for a number of descriptors to change status.
			-- `a_maxfdp`' is the highest-numbered descriptor in any of
			-- the three sets, plus 1.
			-- If `a_timeout' is 0, function returns immediately (polling).
			-- If `a_timeout' is `default_pointer' function can block
			-- indefinitely.
			-- Returns -1 on error or else the number of descriptors that
			-- are ready.
		do
			assert_winsock_initialized
			Result := posix_select (a_maxfdp1, a_readset, a_writeset, an_exceptset, a_timeout)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			end
		end


end
