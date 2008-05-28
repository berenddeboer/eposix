indexing

   description: 
   "Describes CPU related security."
   
   usage: "Inherit from STDC_SECURITY_ACCESSOR."
   
   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   STDC_SECURITY_CPU
   
   
inherit
   
   STDC_SECURITY_ASPECT
   
   STDC_SYSTEM

   STDC_CURRENT_PROCESS

   
create
   
   make
   
   
feature -- creation
   
   make is
         -- allow everything
      do
         start := clock
         max_process_time := Max_Int
      end
   

feature -- query parameters
   
   current_process_time: INTEGER is
         -- Returns number of seconds since monitoring
      do
         -- clock never wraps of course...
         Result := (clock - start) // clocks_per_second
      end

   max_process_time: INTEGER
         -- maximum allowed seconds this process may use
   
   
feature -- set parameters
   
   set_max_process_time (value: INTEGER) is
      do
         max_process_time := value
      end


feature -- query
   
   is_allowed_process_time: BOOLEAN is
         -- returns True if the maximum allowed process time has not 
         -- been exceeded.
      do
         Result := current_process_time < max_process_time
      end      
   
   check_process_time is
      do
         if not is_allowed_process_time then
            raise_security_error ("Maximum allowed process time " +
                                  max_process_time.out + "s exceeded.%N")
         end
      end
   
   
feature {NONE} -- private state
   
   start: INTEGER
         -- capture processor time


end -- class STDC_SECURITY_CPU
