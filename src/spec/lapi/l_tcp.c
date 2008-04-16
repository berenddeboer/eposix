#include "l_tcp.h"

/* TCP states */

EIF_INTEGER const_tcp_established()
{
  return TCP_ESTABLISHED;
}

EIF_INTEGER const_tcp_syn_sent()
{
  return TCP_SYN_SENT;
}

EIF_INTEGER const_tcp_syn_recv()
{
  return TCP_SYN_RECV;
}

EIF_INTEGER const_tcp_fin_wait1()
{
  return TCP_FIN_WAIT1;
}

EIF_INTEGER const_tcp_fin_wait2()
{
  return TCP_FIN_WAIT2;
}

EIF_INTEGER const_tcp_time_wait()
{
  return TCP_TIME_WAIT;
}

EIF_INTEGER const_tcp_close()
{
  return TCP_CLOSE;
}

EIF_INTEGER const_tcp_close_wait()
{
  return TCP_CLOSE_WAIT;
}

EIF_INTEGER const_tcp_last_ack()
{
  return TCP_LAST_ACK;
}

EIF_INTEGER const_tcp_listen()
{
  return TCP_LISTEN;
}

EIF_INTEGER const_tcp_closing()
{
  return TCP_CLOSING;
}


/* struct tcp_info */

EIF_INTEGER posix_tcp_info_size()
{
   return (sizeof (struct tcp_info));
}


EIF_INTEGER posix_tcp_info_tcpi_state(struct tcp_info *p)
{
  return p->tcpi_state;
}

EIF_INTEGER posix_tcp_info_tcpi_ca_state(struct tcp_info *p)
{
  return p->tcpi_ca_state;
}

EIF_INTEGER posix_tcp_info_tcpi_retransmits(struct tcp_info *p)
{
  return p->tcpi_retransmits;
}

EIF_INTEGER posix_tcp_info_tcpi_probes(struct tcp_info *p)
{
  return p->tcpi_probes;
}

EIF_INTEGER posix_tcp_info_tcpi_backoff(struct tcp_info *p)
{
  return p->tcpi_backoff;
}

EIF_INTEGER posix_tcp_info_tcpi_options(struct tcp_info *p)
{
  return p->tcpi_options;
}

EIF_INTEGER posix_tcp_info_tcpi_snd_wscale(struct tcp_info *p)
{
  return p->tcpi_snd_wscale;
}

EIF_INTEGER posix_tcp_info_tcpi_rto(struct tcp_info *p)
{
  return p->tcpi_rto;
}

EIF_INTEGER posix_tcp_info_tcpi_ato(struct tcp_info *p)
{
  return p->tcpi_ato;
}

EIF_INTEGER posix_tcp_info_tcpi_snd_mss(struct tcp_info *p)
{
  return p->tcpi_snd_mss;
}

EIF_INTEGER posix_tcp_info_tcpi_rcv_mss(struct tcp_info *p)
{
  return p->tcpi_rcv_mss;
}

EIF_INTEGER posix_tcp_info_tcpi_unacked(struct tcp_info *p)
{
  return p->tcpi_unacked;
}

EIF_INTEGER posix_tcp_info_tcpi_sacked(struct tcp_info *p)
{
  return p->tcpi_sacked;
}

EIF_INTEGER posix_tcp_info_tcpi_lost(struct tcp_info *p)
{
  return p->tcpi_lost;
}

EIF_INTEGER posix_tcp_info_tcpi_retrans(struct tcp_info *p)
{
  return p->tcpi_retrans;
}

EIF_INTEGER posix_tcp_info_tcpi_fackets(struct tcp_info *p)
{
  return p->tcpi_fackets;
}

EIF_INTEGER posix_tcp_info_tcpi_last_data_sent(struct tcp_info *p)
{
  return p->tcpi_last_data_sent;
}

EIF_INTEGER posix_tcp_info_tcpi_last_ack_sent(struct tcp_info *p)
{
  return p->tcpi_last_ack_sent;
}

EIF_INTEGER posix_tcp_info_tcpi_last_data_recv(struct tcp_info *p)
{
  return p->tcpi_last_data_recv;
}

EIF_INTEGER posix_tcp_info_tcpi_last_ack_recv(struct tcp_info *p)
{
  return p->tcpi_last_ack_recv;
}

EIF_INTEGER posix_tcp_info_tcpi_pmtu(struct tcp_info *p)
{
  return p->tcpi_pmtu;
}

EIF_INTEGER posix_tcp_info_tcpi_rcv_ssthresh(struct tcp_info *p)
{
  return p->tcpi_rcv_ssthresh;
}

EIF_INTEGER posix_tcp_info_tcpi_rtt(struct tcp_info *p)
{
  return p->tcpi_rtt;
}

EIF_INTEGER posix_tcp_info_tcpi_rttvar(struct tcp_info *p)
{
  return p->tcpi_rttvar;
}

EIF_INTEGER posix_tcp_info_tcpi_snd_ssthresh(struct tcp_info *p)
{
  return p->tcpi_snd_ssthresh;
}

EIF_INTEGER posix_tcp_info_tcpi_snd_cwnd(struct tcp_info *p)
{
  return p->tcpi_snd_cwnd;
}

EIF_INTEGER posix_tcp_info_tcpi_advmss(struct tcp_info *p)
{
  return p->tcpi_advmss;
}

EIF_INTEGER posix_tcp_info_tcpi_reordering(struct tcp_info *p)
{
  return p->tcpi_reordering;
}
