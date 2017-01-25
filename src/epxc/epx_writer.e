note

   description: "Abstract writer (output) class."
   
   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

deferred class 

   EPX_WRITER
   
   
feature -- commands
   
   write (a: ANY)
      do
         write_string (a.out)
      end
   
   write_character (c: CHARACTER)
      deferred
      end
   
   write_pointer (p: POINTER; size: INTEGER)
      deferred
      end

   write_string (s: STRING)
      deferred
      end

end -- class EPX_WRITER
