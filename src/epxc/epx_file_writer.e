indexing

   description: "Writer for STDC_FILE class."
   
   author: "Berend de Boer"
   date: "$Date: 2007/11/22 $"
   revision: "$Revision: #3 $"

class 

   EPX_FILE_WRITER
   
   
inherit
   
   EPX_WRITER
   

create
   
   make
   
   
feature -- creation

   make (a_output: STDC_FILE) is
      require
         is_a_file: a_output /= Void
         is_open: a_output.is_open
      do
         file := a_output
      end


feature -- commands
   
   write_character (c: CHARACTER) is
      do
         file.write_character  (c)
      end
   
   write_pointer (p: POINTER; size: INTEGER) is
      do
         file.write (p, 0, size)
      end
   
   write_string (s: STRING) is
      do
         file.write_string (s)
      end
   

feature {NONE} -- private state
   
   file: STDC_FILE


invariant
   
   can_write: file /= Void

end -- class EPX_FILE_WRITER
