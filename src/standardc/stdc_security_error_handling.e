indexing

   description:
   "Describes error handling related security."

   usage: "Inherit from STDC_SECURITY_ACCESSOR."

   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class

   STDC_SECURITY_ERROR_HANDLING


inherit

   STDC_SECURITY_ASPECT


create

   make


feature -- creation

   make is
         -- allow everything
      do
         exceptions_enabled := True
      end


feature -- query parameters

   exceptions_enabled: BOOLEAN


feature -- set parameters

   disable_exceptions is
      do
         disabled_counter := disabled_counter + 1
         exceptions_enabled := False
      ensure
         enabled_when_needed: disabled_counter = 0 implies exceptions_enabled
      end

   enable_exceptions is
      do
         if not exceptions_enabled then
            disabled_counter := disabled_counter - 1
            if disabled_counter = 0 then
               exceptions_enabled := True
            end
         end
      end


feature {NONE} -- private state

   disabled_counter: INTEGER
         -- make nested `disable_exceptions'/`enable_exceptions' possible


invariant

   correct_counter1: exceptions_enabled implies disabled_counter = 0
   correct_counter2: not exceptions_enabled implies disabled_counter > 0
   valid_counter: disabled_counter >= 0

end
