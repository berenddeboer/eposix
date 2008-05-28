class	EX_IRC1

create

	make

feature

	make is
		local
			irc: EPX_IRC_CLIENT
			eiffel: EPX_IRC_CHANNEL
		do
			create irc.make (host, username, password)
			irc.set_print_response (True)
			irc.set_real_name ("EiffelBot")
			irc.open
			if irc.is_open then
				irc.read_all
				irc.join ("#eiffel")
				eiffel := irc.last_joined_channel
				irc.set_blocking_io (True)
				from
					irc.read
				until
					False
				loop
					irc.read
				end
				-- We won't come here.,,
				irc.close
			end
		end

	host: STRING is "irc.freenode.net"

	username: STRING is "eiffelbot"

	password: STRING
			-- n/a

end
