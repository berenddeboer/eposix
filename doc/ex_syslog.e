class EX_SYSLOG

inherit
   
   SUS_CONSTANTS

   SUS_SYSLOG_ACCESSOR

create
   
   make
   
feature

   make is
      do
         syslog.open ("test", LOG_ODELAY + LOG_PID, LOG_USER)
         
         syslog.debug_dump ("this is a debug message")
         syslog.info ("this is an informational message")
         syslog.warning ("this is a warning")
         syslog.error ("this is an error message")
         
         syslog.close
      end

end
