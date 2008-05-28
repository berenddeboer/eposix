indexing

   description: "Class that reads a string from a stream,%
   %waiting a given number of seconds for that string, or else returns."

   author: "Berend de Boer"
   date: "$Date";
   revision: "$Revision: #3 $"

class

   POSIX_TIMED_FIN_STRING


inherit

   POSIX_TIMED_COMMAND
      rename
         make as inherited_make
      end


create

   make


feature -- creation

   make (a_seconds: INTEGER; a_stream: POSIX_FILE) is
      do
         inherited_make (a_seconds)
         stream := a_stream
      end


feature -- state

   stream: POSIX_FILE


feature {NONE}

   do_execute is
      do
         -- stream.read_string (256)
         stream.read_character
      end


end -- class POSIX_TIMED_FIN_STRING
