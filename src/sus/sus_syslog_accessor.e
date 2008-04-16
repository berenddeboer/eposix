indexing

   description: "Class that makes the singleton SUS_SYSLOG available."

   usage: "Inherit from this class."

   author: "Berend de Boer"
   date: "$Date: 2002/02/06 $"
   revision: "$Revision: #2 $"

class

   SUS_SYSLOG_ACCESSOR


feature -- the singleton

   syslog: SUS_SYSLOG is
         -- singleton entry point for syslog daemon
      once
         create Result.make
      ensure
         has_syslog: Result /= Void
      end


feature {NONE} -- private test

   syslog_is_real_singleton: BOOLEAN is
         -- Do multiple calls to `singleton' return the same result?
      do
         Result := syslog = syslog
      end


invariant

   accessing_real_singleton: syslog_is_real_singleton

end
