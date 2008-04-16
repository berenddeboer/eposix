class EX_ENV2
   
creation
   
   make
   
feature
   
   make is
      local
         env: STDC_ENV_VAR
      do
         create env.make ("HOME")
         print (env.value)
         print ("%N")
      end
   
end
