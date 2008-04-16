indexing

	description: "Test IMAP4rev1 client code."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	TEST_S_IMAP4


inherit

	TS_TEST_CASE
		redefine
			set_up
		end


feature -- Setup

	set_up is
		local
			password_env: STDC_ENV_VAR
		do
			host := "bmach"
			user_name := "berend"
			create password_env.make ("IMAP4_PASSWORD")
			password := password_env.value
		ensure then
			password_not_void: password /= Void
		end


feature -- Tests

	test_login is
		local
			client: EPX_IMAP4_CLIENT
		do
			assert ("Have password.", not password.is_empty)
			create client.make (host)
			debug ("imap4")
				print ("Greeting message: ")
				print (client.response.greeting_message)
				print ("%N")
			end
			client.login (user_name, password)
			assert ("Login ok", client.response.is_ok)

			client.logout
			assert ("Logout ok", client.response.is_ok)
			debug ("imap4")
				print ("Bye text: ")
				print (client.response.bye_response_text)
				print ("%N")
				print ("Response text: ")
				print (client.response.response_text)
				print ("%N")
			end
			client.close
		end

	test_list is
		local
			client: EPX_IMAP4_CLIENT
		do
			create client.make (host)
			client.login (user_name, password)
			assert ("Login ok", client.response.is_ok)
			client.list_all
			assert ("List ok", client.response.is_ok)
			client.list_subscribed
			assert ("List ok", client.response.is_ok)
			assert ("List ok", client.response.is_ok)
			client.logout
			client.close
		end

	test_message_reading is
		local
			client: EPX_IMAP4_CLIENT
		do
			create client.make (host)
			client.login (user_name, password)
			assert ("Login ok", client.response.is_ok)

			client.examine ("INBOX")
			assert ("Examine ok", client.response.is_ok)
			assert ("Read-only mailbox.", not client.response.current_mailbox.is_writable)
			assert ("At least two messages.", client.response.current_mailbox.count >= 2)
			debug ("imap4")
				print ("Mailbox identifier: ")
				print (client.response.current_mailbox.identifier)
				print ("%N")
				print ("Total messages: ")
				print (client.response.current_mailbox.count)
				print ("%N")
				print ("Recent messages: ")
				print (client.response.current_mailbox.recent)
				print ("%N")
				print ("First unseen message: ")
				print (client.response.current_mailbox.unseen)
				print ("%N")
			end
			client.fetch ("4", "RFC822.SIZE")
			assert ("Fetch size ok", client.response.is_ok)
			client.fetch_message (4)
			assert ("Fetch message ok", client.response.is_ok)
			assert_equal ("Message size as expected.", client.response.current_message.size, client.response.current_message.message.count)
			debug ("imap4")
				print ("Last email:%N")
				print (client.response.current_message.message.substring (1, 1024))
				--print (client.response.message)
				print ("%N")
			end

			client.fetch_header (2)
			assert ("Fetch header ok", client.response.is_ok)

			-- VE hangs with postconditions enabled
			-- but only when reading body (2)
			--	print ("## fetch body%N")
			client.fetch_body (1)
			assert ("Fetch body ok", client.response.is_ok)

			client.fetch ("2", "RFC822.SIZE")
			assert ("Fetch size ok", client.response.is_ok)
			client.fetch ("2", "ALL")
			assert ("Fetch all ok", client.response.is_ok)
			client.fetch ("2", "BODYSTRUCTURE")
			assert ("Fetch body structure ok", client.response.is_ok)
			client.fetch ("2", "FULL")
			assert ("Fetch full ok", client.response.is_ok)
			client.fetch ("2", "FAST")
			assert ("Fetch fast ok", client.response.is_ok)
			client.fetch ("2", "ENVELOPE")
			assert ("Fetch envelope ok", client.response.is_ok)
			client.fetch ("2", "UID")
			assert ("Fetch uid ok", client.response.is_ok)
			client.fetch ("2", "(FLAGS INTERNALDATE RFC822.SIZE ENVELOPE)")
			assert ("Fetch common flags ok", client.response.is_ok)
			client.fetch ("2", "(FLAGS BODY[HEADER.FIELDS (DATE FROM)])")
			assert ("Fetch common flags ok", client.response.is_ok)
			client.noop
			assert ("NOOP ok", client.response.is_ok)
			client.close_mailbox
			client.logout
			client.close
		end

	test_writing is
			-- Test all kinds of changes, like mail box creation, copying
			-- of messages and removing/setting flags.
		local
			client: EPX_IMAP4_CLIENT
		do
			create client.make (host)
			client.login (user_name, password)
			assert ("Login ok", client.response.is_ok)

			-- Delete it first, if it already exists.
			client.examine (new_mailbox_name)
			if client.response.is_ok then
				client.close_mailbox
				client.delete_mailbox (new_mailbox_name)
			end
			client.create_mailbox (new_mailbox_name)
			assert ("Created.", client.response.is_ok)
			client.delete_mailbox (new_mailbox_name)
			assert ("Deleted.", client.response.is_ok)

			-- Create mailbox
			client.create_mailbox (new_mailbox_name)
			assert ("Created.", client.response.is_ok)
			client.select_mailbox (new_mailbox_name)
			assert ("New mailbox can be selected.", client.response.is_ok)

			-- Copy first msg from INBOX to it
			client.examine ("INBOX")
			client.copy_message (1, new_mailbox_name)
			assert ("Message copied.", client.response.is_ok)
			client.close_mailbox
			client.select_mailbox (new_mailbox_name)
			assert ("New mailbox selected.", client.response.is_ok)
			client.fetch ("1", "(FLAGS RFC822.SIZE)")
			assert ("Fetch ok", client.response.is_ok)
			assert ("Size retrieved", client.response.current_message.size > 0)
			assert ("Seen in flags", client.response.current_message.flags.has ("\Seen"))
			assert ("Seen in status", client.response.current_message.is_seen)
			client.mark_unseen (1)
			client.fetch ("1", "FLAGS")
			assert ("Not seen", not client.response.current_message.is_seen)

			-- Clean up
			client.delete_mailbox (new_mailbox_name)
			assert ("Deleted.", client.response.is_ok)
			client.close
		end

	test_other is
			-- Miscellaneous tests
		local
			client: EPX_IMAP4_CLIENT
		do
			create client.make (host)
			client.login (user_name, password)
			assert ("Login ok", client.response.is_ok)

			client.examine ("NON-EXISTING-QWERTY")
			assert ("Examine not ok", client.response.is_no)

			client.examine ("INBOX")
			assert ("Examine ok", client.response.is_ok)
			client.check_mailbox
			assert ("Examine ok", client.response.is_ok)
			client.get_delimiter
			assert ("Examine ok", client.response.is_ok)
			debug ("imap4")
				print ("Delimiter: '")
				print (client.response.delimiter)
				print ("'%N")
			end

			client.logout
			client.close
		end

	test_ssl is
		local
			client: EPX_IMAP4_CLIENT
		do
			assert ("Have password.", not password.is_empty)
			create client.make_secure (host)
			debug ("imap4")
				print ("Greeting message: ")
				print (client.response.greeting_message)
				print ("%N")
			end
			client.login (user_name, password)
			assert ("Login ok", client.response.is_ok)

			client.list_all
			assert ("List ok", client.response.is_ok)
			client.list_subscribed
			assert ("List ok", client.response.is_ok)
			assert ("List ok", client.response.is_ok)

			client.logout
			assert ("Logout ok", client.response.is_ok)
			debug ("imap4")
				print ("Bye text: ")
				print (client.response.bye_response_text)
				print ("%N")
				print ("Response text: ")
				print (client.response.response_text)
				print ("%N")
			end
			client.close
		end


feature {NONE} -- Implementation

	host,
	user_name,
	password: STRING

	new_mailbox_name: STRING is "INBOX.abceposixtest"


end
