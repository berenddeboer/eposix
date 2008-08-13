/*

Eiffel to C glue layer to access Linux specific netinet/tcp.h

*/

#ifndef _L_TCP_H_
#define _L_TCP_H_

#if HAVE_CONFIG_H
#include <config.h>
#endif

#include "../../supportc/eiffel.h"

#include <netinet/tcp.h>


/* TCP states */

EIF_INTEGER const_tcp_established();
EIF_INTEGER const_tcp_syn_sent();
EIF_INTEGER const_tcp_syn_recv();
EIF_INTEGER const_tcp_fin_wait1();
EIF_INTEGER const_tcp_fin_wait2();
EIF_INTEGER const_tcp_time_wait();
EIF_INTEGER const_tcp_close();
EIF_INTEGER const_tcp_close_wait();
EIF_INTEGER const_tcp_last_ack();
EIF_INTEGER const_tcp_listen();
EIF_INTEGER const_tcp_closing();


/* struct tcp_info */

EIF_INTEGER posix_tcp_info_size();

EIF_INTEGER posix_tcp_info_tcpi_state(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_ca_state(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_retransmits(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_probes(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_backoff(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_options(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_snd_wscale(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_rto(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_ato(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_snd_mss(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_rcv_mss(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_unacked(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_sacked(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_lost(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_retrans(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_fackets(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_last_data_sent(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_last_ack_sent(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_last_data_recv(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_last_ack_recv(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_pmtu(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_rcv_ssthresh(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_rtt(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_rttvar(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_snd_ssthresh(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_snd_cwnd(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_advmss(struct tcp_info *p);
EIF_INTEGER posix_tcp_info_tcpi_reordering(struct tcp_info *p);


#endif /* _L_TCP_H_ */
