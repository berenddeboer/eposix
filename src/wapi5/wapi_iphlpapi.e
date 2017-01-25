note

	description: "Class that covers Windows IPHlpApi.h, a header that lets you retrieve various IP statistics."

	to_link: "If you use this library, you must link with IPHlpApi.Lib"
	xace_tip: "For Gobo's xace, just add this: <option name='link' value='-lIPHlpApi.Lib'/>"


	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	WAPI_IPHLPAPI


feature -- C binding

	posix_gettcptable (pTcpTable, pwdSize: POINTER; bOrder: BOOLEAN): INTEGER
			-- Retrieve the TCP connection table. Data is put
			-- in`pTcpTable', size of the table should be in
			-- `pwdSize'. `pdwSize' is set if table is not large enough.
			-- If `bOrder', then the data is sorted in order of local ip
			-- address, local port, remote ip address, remote port.
		require
			pTcpTable_not_nil: pTcpTable /= default_pointer
			pwdSize_not_nil: pwdSize /= default_pointer
		external "C"
		end


feature -- C binding for members of _MIB_TCPTABLE

	posix_mib_tcptable_size: INTEGER
		external "C"
		ensure
			valid_size: Result > 0
		end

	posix_mib_tcptable_dwnumentries (a_mib_tcptable: POINTER): INTEGER
		require
			have_struct_pointer: a_mib_tcptable /= default_pointer
		external "C"
		end

	posix_mib_tcptable_table_item (a_mib_tcptable: POINTER; an_index: INTEGER): POINTER
			-- Pointer to a _MIB_TCPROW
		require
			have_struct_pointer: a_mib_tcptable /= default_pointer
			valid_index: an_index >= 0 and then an_index < posix_mib_tcptable_dwnumentries (a_mib_tcptable)
		external "C"
		end


feature -- C binding for members of _MIB_TCPROW

	posix_mib_tcprow_size: INTEGER
		external "C"
		ensure
			valid_size: Result > 0
		end

	posix_mib_tcprow_dwstate (a_mib_tcprow: POINTER): INTEGER
		require
			have_struct_pointer: a_mib_tcprow /= default_pointer
		external "C"
		end

	posix_mib_tcprow_dwlocaladdr (a_mib_tcprow: POINTER): INTEGER
		require
			have_struct_pointer: a_mib_tcprow /= default_pointer
		external "C"
		end

	posix_mib_tcprow_dwlocalport (a_mib_tcprow: POINTER): INTEGER
		require
			have_struct_pointer: a_mib_tcprow /= default_pointer
		external "C"
		end

	posix_mib_tcprow_dwremoteaddr (a_mib_tcprow: POINTER): INTEGER
		require
			have_struct_pointer: a_mib_tcprow /= default_pointer
		external "C"
		end

	posix_mib_tcprow_dwremoteport (a_mib_tcprow: POINTER): INTEGER
		require
			have_struct_pointer: a_mib_tcprow /= default_pointer
		external "C"
		end


feature -- State of a TCP connection

	MIB_TCP_STATE_CLOSED: INTEGER = 1

	MIB_TCP_STATE_LISTEN: INTEGER = 2

	MIB_TCP_STATE_SYN_SENT: INTEGER = 3

	MIB_TCP_STATE_SYN_RCVD: INTEGER = 4

	MIB_TCP_STATE_ESTAB: INTEGER = 5

	MIB_TCP_STATE_FIN_WAIT1: INTEGER = 6

	MIB_TCP_STATE_FIN_WAIT2: INTEGER = 7

	MIB_TCP_STATE_CLOSE_WAIT: INTEGER = 8

	MIB_TCP_STATE_CLOSING: INTEGER = 9

	MIB_TCP_STATE_LAST_ACK: INTEGER = 10

	MIB_TCP_STATE_TIME_WAIT: INTEGER = 11

	MIB_TCP_STATE_DELETE_TCB: INTEGER = 12


end
