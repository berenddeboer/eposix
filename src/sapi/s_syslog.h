/*

C layer to POSIX syslog.h header

*/


#ifndef _P_SYSLOG_H_
#define _P_SYSLOG_H_

#include "s_defs.h"
#include <syslog.h>
#include "../supportc/eiffel.h"


/* functions */

void posix_openlog(EIF_POINTER ident, EIF_INTEGER option, EIF_INTEGER facility);
void posix_syslog(EIF_INTEGER priority, EIF_POINTER format);
void posix_closelog();

/* facility codes */

EIF_INTEGER const_log_kern();
EIF_INTEGER const_log_user();
EIF_INTEGER const_log_mail();
EIF_INTEGER const_log_daemon();
EIF_INTEGER const_log_auth();
EIF_INTEGER const_log_lpr();
EIF_INTEGER const_log_news();
EIF_INTEGER const_log_uucp();
EIF_INTEGER const_log_cron();
EIF_INTEGER const_log_local0();
EIF_INTEGER const_log_local1();
EIF_INTEGER const_log_local2();
EIF_INTEGER const_log_local3();
EIF_INTEGER const_log_local4();
EIF_INTEGER const_log_local5();
EIF_INTEGER const_log_local6();
EIF_INTEGER const_log_local7();

/* options */

EIF_INTEGER const_log_pid();
EIF_INTEGER const_log_cons();
EIF_INTEGER const_log_odelay();
EIF_INTEGER const_log_ndelay();
EIF_INTEGER const_log_perror();

/* priorities */

EIF_INTEGER const_log_emerg();
EIF_INTEGER const_log_alert();
EIF_INTEGER const_log_crit();
EIF_INTEGER const_log_err();
EIF_INTEGER const_log_warning();
EIF_INTEGER const_log_notice();
EIF_INTEGER const_log_info();
EIF_INTEGER const_log_debug();


#endif /* _P_SYSLOG_H_ */
