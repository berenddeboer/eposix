indexing

	description:

		"Test for eposix IRC client against a local ircd server."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	TEST_IRC_CLIENT


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_CURRENT_PROCESS


feature -- Tests

	test_open is
		local
			irc: EPX_IRC_CLIENT
		do
			create irc.make ("dullio.nederware.nl", "berend", Void)
			debug ("test")
				irc.set_print_response (True)
			end
			irc.set_real_name ("Berend de Boer")
			irc.open
			assert ("Connected", irc.is_open)
			irc.read_all
			sleep (1)
			irc.read_all
			debug ("test")
				print ("MOTD:%N")
				print (irc.message_of_the_day)
			end
			irc.quit ("Goodbye")
			sleep (1)
			irc.read_all
			irc.close
			assert ("Closed", not irc.is_open)
		end

	test_channel is
			-- Test accessing a channel.
			-- Because we're connecting two clients, make sure the local
			-- irc employs no throttling, else you get the connected too
			-- fast message.
		local
			irc,
			irc2: EPX_IRC_CLIENT
			eiffel: EPX_IRC_CHANNEL
		do
			create irc.make ("localhost", "berend", Void)
			debug ("test")
				irc.set_print_response (True)
			end
			irc.open
			assert ("Connected", irc.is_open)
			read_until_a_reply_received (irc)
			irc.list_all
			read_until_a_reply_received (irc)
			irc.all_names
			read_until_a_reply_received (irc)
			irc.part_all

			-- Join channel
			irc.join (channel_name)
			eiffel := irc.last_joined_channel
			assert ("Not open", not eiffel.is_open)
			from
				irc.read_all
			until
				eiffel.is_open
			loop
				irc.read_all
			end
			assert ("Open", eiffel.is_open)
			irc.names (channel_name)
			read_until_a_reply_received (irc)
			irc.set_topic (channel_name, topic)
			read_until_a_reply_received (irc)

			-- Connect a 2nd client
			create irc2.make ("localhost", "berend2", Void)
			debug ("test")
				irc2.set_print_response (True)
			end
			irc2.set_nick_name ("bdb2")
			irc2.open
			assert ("Connected", irc2.is_open)
			irc2.join (channel_name)
			read_until_a_reply_received (irc2)

			-- Should see join message
			from
				irc.read
			until
				irc.last_message /= Void and then
				irc.last_message.command.is_equal (commands.join)
			loop
				irc.read
			end
			assert_equal ("Noticed join of nick bdb2", "bdb2", irc.last_message.nick_name)
			assert_equal ("Noticed join of user berend2", "berend2", irc.last_message.user_name)

			-- Say hello to new user
			eiffel.privmsg ("hello " + irc.last_message.nick_name)

			-- See if new user gets this
			from
				irc2.read
			until
				irc2.last_message /= Void and then
				irc2.last_message.command.is_equal (commands.privmsg)
			loop
				irc2.read
			end
			assert_equal ("Noticed message from berend", "berend", irc2.last_message.nick_name)

			-- irc2 should have seen topic by now
			assert_equal ("Topic received by bdb2", topic, irc2.last_joined_channel.topic)

			-- 2nd client quits
			irc2.part (channel_name, "Outta here")
			read_until_a_reply_received (irc2)
			irc2.quit ("Goodbye all")
			sleep (1)
			irc2.read_all
			irc2.close
			assert ("Closed", not irc2.is_open)

			-- Client quits
			read_until_a_reply_received (irc)
			irc.quit ("Goodbye all")
			read_until_a_reply_received (irc)
			irc.close
			assert ("Closed", not irc.is_open)
		end

	test_dcc_initiate is
			-- Test DCC. Need to have ircd running in localhost, and iroffer.
		local
			irc: EPX_IRC_CLIENT
			channel: EPX_IRC_CHANNEL
			chat: EPX_IRC_DCC_CHAT_INITIATOR
		do
			create irc.make ("localhost", "berend", Void)
			irc.open
			assert ("Connected", irc.is_open)
			debug ("test")
				irc.set_print_response (True)
			end

			-- Join channel
			irc.join ("#survivor-central")
			channel := irc.last_joined_channel
			assert ("Not open", not channel.is_open)
			from
				irc.read_all
			until
				channel.is_open
			loop
				irc.read_all
			end
			assert ("Open", channel.is_open)

			-- Start chat with bot
			irc.dcc_chat ("mybotDCC")
			from
				chat := irc.last_dcc_chat_offer
			until
				chat.is_accepted
			loop
				sleep (1)
			end

			-- Wait a bit and then read all data that is available
			sleep (3)
			from
				chat.read
			until
				chat.end_of_input or else
				not chat.is_string_read
			loop
				print (chat.last_string)
				print ("%N")
				chat.read
			end

			-- Send the password
			chat.put ("iroffer")

			-- Again read input
			sleep (2)
			from
				chat.read
			until
				chat.end_of_input or else
				not chat.is_string_read
			loop
				print (chat.last_string)
				print ("%N")
				chat.read
			end
			chat.put ("exit%N")
			chat.close
			irc.read_all
			irc.close
		end

	test_dcc_accept is
			-- Test DCC. Need to have ircd running in localhost, and iroffer.
			-- iroffer should have admin chat available, so adminpass
			-- must be set to "iroffer".
		local
			irc: EPX_IRC_CLIENT
			channel: EPX_IRC_CHANNEL
			chat: EPX_IRC_DCC_CHAT_ACCEPTOR
		do
			create irc.make ("localhost", "berend", Void)
			irc.open
			assert ("Connected", irc.is_open)
			debug ("test")
				irc.set_print_response (True)
			end

			-- Join channel
			irc.join ("#survivor-central")
			channel := irc.last_joined_channel
			assert ("Not open", not channel.is_open)
			from
				irc.read_all
			until
				channel.is_open
			loop
				irc.read_all
			end
			assert ("Open", channel.is_open)

			-- Ask bot to initiate a chat
			irc.privmsg ("mybotDCC", "admin iroffer chatme")

			-- Wait until request received
			from
				irc.read_all
			until
				not irc.dcc_chat_requests.is_empty
			loop
				sleep (1)
				irc.read_all
			end

			-- Accept request
			chat := irc.dcc_chat_requests.first
			chat.open

			-- Wait a bit and then read all data that is available
			sleep (2)
			from
				chat.read
			until
				not chat.is_string_read
			loop
				print (chat.last_string)
				print ("%N")
				chat.read
			end

			-- Send the password
			chat.put ("iroffer")
			chat.put ("msgread")

			-- Again read input
			sleep (2)
			from
				chat.read
			until
				not chat.is_string_read
			loop
				print (chat.last_string)
				print ("%N")
				chat.read
			end
			chat.put ("exit%N")
			chat.close

			irc.read_all
			irc.close
		end

	test_color_removal is
		local
			color: expanded EPX_IRC_COLOR
		do
			assert_equal ("Color removed", ":Message:[Pete's Small-Size Eps! New...Supernanny 106, Ultimate Fighter 106, Osbournes 406, Iron Chef USA 105, Entertainer 105, Celeb Fit Club USA 106, Surreal Life 406, Wickedly Perfect 107, Australias Next Top Model 107 Plus Many More (Also Simpsons, Tru Calling, Scrubs, CSI & L&O)] - SysReset 2.53", color.without_color (":Message:[04Pete's Small-Size Eps! New...Supernanny 106, Ultimate Fighter 106, Osbournes 406, Iron Chef USA 105, Entertainer 105, Celeb Fit Club USA 106, Surreal Life 406, Wickedly Perfect 107, Australias Next Top Model 107 Plus Many More (Also Simpsons, Tru Calling, Scrubs, CSI & L&O)] - SysReset 2.53"))
			assert_equal ("More color removed", ":geek.de.eu.irchighway.net 332 bdb #survivor-central :Welcome to #Survivor Central  : Spoilers = BAN!!! : [ Type /join #Survivor for chat and spoiling ] : Triggers = !rules (rules and chan help files), !list, @find : NEWS: S10e01 RW-gandalf | this is a reality channel, why are you all downloading lost?", color.without_color (":geek.de.eu.irchighway.net 332 bdb #survivor-central :0,10Welcome to #Survivor Central  12: Spoilers = BAN!!! : 4[ Type /join #Survivor for chat and spoiling ]12 : Triggers = !rules (rules and chan help files), !list, @find : 7NEWS: S10e01 RW-gandalf | this is a reality channel, why are you all downloading lost?"))
		end


feature {NONE} -- Implementation

	channel_name: STRING is "#eiffel"

	commands: expanded EPX_IRC_COMMANDS

	read_until_a_reply_received (irc: EPX_IRC_CLIENT) is
		require
			irc_not_void: irc /= Void
			open: irc.is_open
			not_end_of_input: not irc.end_of_input
		do
			from
				irc.read
			until
				irc.last_response /= Void
			loop
				sleep (1)
				irc.read
			end
			irc.read_all
		end

	read_continually (irc: EPX_IRC_CLIENT) is
			-- Endless loop, used for testing.
		require
			irc_not_void: irc /= Void
			open: irc.is_open
			not_end_of_input: not irc.end_of_input
		do
			from
			until
				False
			loop
				irc.read_all
			end
		end

	topic: STRING is "Eiffel Rulez"

end
