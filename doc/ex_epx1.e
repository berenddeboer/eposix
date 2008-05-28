class EX_EPX1

inherit

   EPX_FILE_SYSTEM

create

   make

feature

   make is
      local
         dir: STRING
      do
         print ("Current directory: ")
         dir := current_directory
         print (dir)
         print ("%N")
         change_directory ("..")
         change_directory (dir)
         make_directory ("abc")
         rename_to ("abc", "def")
         remove_directory ("def")
      end

end
