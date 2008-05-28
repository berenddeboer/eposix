class EX_CMD

create
   
   make
   
feature

   make is
      local
         command: POSIX_SHELL_COMMAND
      do
         create command.make ("/bin/ls *")
         command.execute
         print ("Exit code: ")
         print (command.exit_code)
         print ("%N")
      end

end
