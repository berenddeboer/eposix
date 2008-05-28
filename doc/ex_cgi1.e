class EX_CGI1

inherit

   EPX_CGI

create

   make

feature

   execute is
      do
         content_text_html

         doctype
         b_html

         b_head
         title ("e-POSIX CGI example.")
         e_head

         b_body

         p ("Hello World.")
         extend ("<p>you can use your <b>own</b> tags.</p>")
         b_p
         puts ("or use any tag by using:")
         e_p

         start_tag ("table")
         set_attribute ("border", Void)
         set_attribute ("cols", "3")
         start_tag ("tr")
         start_tag ("td")
         add_data ("start_tag")
         stop_tag
         start_tag ("td")
         add_data ("stop_tag")
         stop_tag
         stop_tag
         stop_tag

         e_body
         e_html

      end

end
