indexing

	description: "Test cgi form input."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_CGI_FORM


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		redefine
			initialize
		end

	EPX_CGI
		rename
			execute as do_execute
		end


feature -- Initialization

	initialize is
			-- Initialize current test case.
			-- (This routine is called by the creation routine
			-- and can be redefined in descendant classes.)
		do
			make_xhtml_writer
		end


feature -- Test

	test_execute is
		do
			make_no_rescue
		end


feature -- Execution

	do_execute is
		do
			content_text_html

			doctype
			b_html

			b_head
			title ("e-POSIX CGI form handling example.")
			stop_tag

			b_body

			br

			if not value("ButtonSave").is_equal ("save")  then

				b_p
				puts ("Here.")
				e_p

				b_form_get ("eposix_test")

				puts ("Your name: ")
				b_input ("text", "MyName")
				e_input
				b_input ("submit", "ButtonSave")
				set_attribute ("value", "save")
				e_input

				e_form

			else

				b_p
				puts ("You entered: ")
				puts (value ("MyName"))
				e_p

				b_p
				puts ("You didn't enter: ")
				puts (value ("NotExist"))
				e_p

			end

			stop_tag
			stop_tag

			if is_tag_started then
				print ("!! Unended tags present.%N")
			end
		end

end
