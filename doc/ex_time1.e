class EX_TIME1

create
   
   make
   
feature

   make is
      local
         time1,
         time2: POSIX_TIME
      do
         create time1.make_from_now
         time1.to_local
         print_time (time1)
         time1.to_utc
         print_time (time1)
         create time2.make_time (0, 0, 0)
         print_time (time2)         
         create time2.make_date_time (1970, 10, 31, 6, 55, 0)
         time2.to_utc
         print_time (time2)         

         if time2 < time1 then
            print ("time2 is less than time1 as expected.%N")
         else
            print ("!! time2 is not less than time1.%N")
         end
      end
   
   print_time (time: POSIX_TIME) is
      do
         print ("Date: ")
         print (time.year)
         print ("-")
         print (time.month)
         print ("-")
         print (time.day)
         print (" ")
         print (time.hour)
         print (":")
         print (time.minute)
         print (":")
         print (time.second)
         print ("%N")                          
         print ("Weekday: ")
         print (time.weekday)
         print ("%N")                          
         print ("default string: ")
         print (time.default_format)
         print ("%N")                          
      end

end
