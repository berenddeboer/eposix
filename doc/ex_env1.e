class EX_ENV1
   
create
   
   make
   
feature
   
   make is
      local
         env: POSIX_ENV_VAR
      do
         create env.make ("HOME")
         print (env.value)
         print ("%N")
      end
   
end
