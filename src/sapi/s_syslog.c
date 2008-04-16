#include "s_syslog.h"


/* functions */

void posix_openlog(EIF_POINTER ident, EIF_INTEGER option, EIF_INTEGER facility)
{
  openlog(ident, option, facility);
}

void posix_syslog(EIF_INTEGER priority, EIF_POINTER format)
{
  syslog(priority, "%s", format);
}

void posix_closelog()
{
  closelog();
}


/* facility codes */

EIF_INTEGER const_log_kern()
{
  return LOG_KERN;
}

EIF_INTEGER const_log_user()
{
  return LOG_USER;
}

EIF_INTEGER const_log_mail()
{
  return LOG_MAIL;
}

EIF_INTEGER const_log_daemon()
{
  return LOG_DAEMON;
}

EIF_INTEGER const_log_auth()
{
  return LOG_AUTH;
}

EIF_INTEGER const_log_lpr()
{
  return LOG_LPR;
}

EIF_INTEGER const_log_news()
{
  return LOG_NEWS;
}

EIF_INTEGER const_log_uucp()
{
  return LOG_UUCP;
}

EIF_INTEGER const_log_cron()
{
  return LOG_CRON;
}

EIF_INTEGER const_log_local0()
{
  return LOG_LOCAL0;
}

EIF_INTEGER const_log_local1()
{
  return LOG_LOCAL1;
}

EIF_INTEGER const_log_local2()
{
  return LOG_LOCAL2;
}

EIF_INTEGER const_log_local3()
{
  return LOG_LOCAL3;
}

EIF_INTEGER const_log_local4()
{
  return LOG_LOCAL4;
}

EIF_INTEGER const_log_local5()
{
  return LOG_LOCAL5;
}

EIF_INTEGER const_log_local6()
{
  return LOG_LOCAL6;
}

EIF_INTEGER const_log_local7()
{
  return LOG_LOCAL7;
}


/* options */

EIF_INTEGER const_log_pid()
{
  return LOG_PID;
}

EIF_INTEGER const_log_cons()
{
  return LOG_CONS;
}

EIF_INTEGER const_log_odelay()
{
  return LOG_ODELAY;
}

EIF_INTEGER const_log_ndelay()
{
  return LOG_NDELAY;
}

EIF_INTEGER const_log_perror()
{
#ifdef LOG_PERROR
  return LOG_PERROR;
#else
  return 0;
#endif
}


/* priorities */

EIF_INTEGER const_log_emerg()
{
  return LOG_EMERG;
}

EIF_INTEGER const_log_alert()
{
  return LOG_ALERT;
}

EIF_INTEGER const_log_crit()
{
  return LOG_CRIT;
}

EIF_INTEGER const_log_err()
{
  return LOG_ERR;
}

EIF_INTEGER const_log_warning()
{
  return LOG_WARNING;
}

EIF_INTEGER const_log_notice()
{
  return LOG_NOTICE;
}

EIF_INTEGER const_log_info()
{
  return LOG_INFO;
}

EIF_INTEGER const_log_debug()
{
  return LOG_DEBUG;
}
