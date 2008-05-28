class EX_FILE5

create

   make

feature

   make is
      local
         file: POSIX_BINARY_FILE
         pos1: INTEGER
         pos2: STDC_FILE_POSITION
      do
         create file.create_read_write ("test.bin")
         file.put_string ("one")
         pos1 := file.tell
         pos2 := file.get_position
         file.put_string ("two")
         file.seek (pos1)
         -- or file.set_position (pos2)
         file.read_string (3)
         if not file.last_string.is_equal ("two") then
            print ("unexpected read.%N")
         end
         file.close
      end

end
