indexing

	description: "Class that covers the Linux specifics in the netinet/tcp.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	LAPI_TCP


feature {NONE} -- C binding for members of tcp_info

	posix_tcp_info_size: INTEGER is
		external "C"
		ensure
			valid_size: Result > 0
		end

	posix_tcp_info_tcpi_state (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_ca_state (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_retransmits (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_probes (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_backoff (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_options (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_snd_wscale (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_rto (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_ato (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_snd_mss (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_rcv_mss (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_unacked (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_sacked (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_lost (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_retrans (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_fackets (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_last_data_sent (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_last_ack_sent (a_tcp_info: POINTER): INTEGER is
			-- Not remembered, sorry.
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_last_data_recv (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_last_ack_recv (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_pmtu (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_rcv_ssthresh (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_rtt (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_rttvar (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_snd_ssthresh (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_snd_cwnd (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_advmss (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end

	posix_tcp_info_tcpi_reordering (a_tcp_info: POINTER): INTEGER is
		require
			have_struct_pointer: a_tcp_info /= default_pointer
		external "C"
		end


feature -- Socket level constants

	SOL_TCP: INTEGER is 6


feature -- SOL_TPC options

	TCP_INFO: INTEGER is 11


feature -- TCP socket states

	TCP_ESTABLISHED: INTEGER is
		external "C"
		alias "const_tcp_established"
		end

	TCP_SYN_SENT: INTEGER is
		external "C"
		alias "const_tcp_syn_sent"
		end

	TCP_SYN_RECV: INTEGER is
		external "C"
		alias "const_tcp_syn_recv"
		end

	TCP_FIN_WAIT1: INTEGER is
		external "C"
		alias "const_tcp_fin_wait1"
		end

	TCP_FIN_WAIT2: INTEGER is
		external "C"
		alias "const_tcp_fin_wait2"
		end

	TCP_TIME_WAIT: INTEGER is
		external "C"
		alias "const_tcp_time_wait"
		end

	TCP_CLOSE: INTEGER is
		external "C"
		alias "const_tcp_close"
		end

	TCP_CLOSE_WAIT: INTEGER is
		external "C"
		alias "const_tcp_close_wait"
		end

	TCP_LAST_ACK: INTEGER is
		external "C"
		alias "const_tcp_last_ack"
		end

	TCP_LISTEN: INTEGER is
		external "C"
		alias "const_tcp_listen"
		end

	TCP_CLOSING: INTEGER is
		external "C"
		alias "const_tcp_closing"
		end


end
