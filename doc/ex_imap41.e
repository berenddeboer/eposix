class	EX_IMAP41

inherit

	POSIX_CURRENT_PROCESS

create

	make

feature

	make is
		local
			client: EPX_IMAP4_CLIENT
		do
			create client.make (host)
			if client.is_open then
				client.login (login_name, password)
				if client.response.is_ok then
					client.list_subscribed
					client.examine ("INBOX")
					client.fetch_message (4)
					print (client.response.current_message.message)
					client.close_mailbox
					client.logout
				else
					print ("Login failed.%N")
				end
				client.close
			else
				print ("Cannot connect to server.%N")
			end
		end

feature -- Access

	host: STRING is "bmach"

	password: STRING is
		local
			password_env: STDC_ENV_VAR
		once
			create password_env.make ("IMAP4_PASSWORD")
			Result := password_env.value
		ensure
			password_not_void: Result /= Void
		end


end
