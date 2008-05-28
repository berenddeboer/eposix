class EX_FACTORY1

inherit

   EPX_FACTORY

create

   make

feature

   make is
      local
         dir: STRING
      do
         print ("Current directory: ")
         dir := fs.current_directory
         print (dir)
         print ("%N")
         fs.change_directory ("..")
         fs.change_directory (dir)
         fs.make_directory ("abc")
         fs.rename_to ("abc", "def")
         fs.remove_directory ("def")
      end

end
