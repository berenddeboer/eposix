indexing

	description:

		"Abstraction for an IRC channel"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_IRC_CHANNEL


inherit

	ANY

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end

	EPX_IRC_MESSAGE_HANDLER
		rename
			make as make_handler
		end


create {EPX_IRC_CLIENT}

	make


feature {NONE} -- Initialization

	make (a_client: EPX_IRC_CLIENT; a_channel_name: STRING) is
		require
			client_not_void: a_client /= Void
			valid_channel_name: a_client.is_valid_channel_name (a_channel_name)
		local
			user_tracker: EPX_IRC_USER_TRACKER
			tester: EPX_IRC_NICK_NAME_EQUALITY_TESTER
		do
			make_handler (a_client)
			channel_name := a_channel_name
			joined_under_nick_name := a_client.nick_name.twin
			create users.make (256)
			create tester
			users.set_key_equality_tester (tester)
			create { DS_LINKED_LIST [EPX_IRC_CHANNEL_HANDLER] } message_handlers.make
			create user_tracker.make (Current)
			message_handlers.put_last (user_tracker)
		end


feature -- Status

	is_message_for_channel (a_message: EPX_IRC_MESSAGE): BOOLEAN is
			-- Is `a_message' send to this channel?
		require
			message_not_void: a_message /= Void
		do
			-- TODO: Channel name comparison must be case-insensitive.
			-- There does not seem to be an algorithm to determine if a
			-- message is for a channel or not.
			if a_message.has_reply_code then
				-- If there is a reply code and it is a RPL_NAMREPLY for
				-- this channel or the 2nd parameter is a channel name, it
				-- is meant for this channel.
				Result :=
					(a_message.parameters.count >= 2 and then
					 STRING_.same_string (a_message.parameters.item (2), channel_name)) or else
					(a_message.reply_code = RPL_NAMREPLY and then
					 a_message.parameters.count = 4 and then
					 STRING_.same_string (a_message.parameters.item (3), channel_name))
			else
				-- If the first parameter is the channel name, it's for
				-- this channel, as well as a nick name change or a quit.
				Result :=
					(not a_message.parameters.is_empty and then
					 STRING_.same_string (a_message.parameters.first, channel_name)) or else
					STRING_.same_string (a_message.command, commands.nick) or else
					STRING_.same_string (a_message.command, commands.quit)
			end
		end

	is_open: BOOLEAN
			-- Is channel successfully joined?

	is_refused: BOOLEAN
			-- Did join to channel failed?


feature -- Access

	channel_name: STRING
			-- Name of channel

	message_handlers: DS_LIST [EPX_IRC_CHANNEL_HANDLER]
			-- User defined handlers for incoming messages to this channel

	topic: STRING
			-- Topic for this channel if a topic was received after
			-- succesfully joining the channel

	users: DS_HASH_TABLE [EPX_IRC_CHANNEL_USER, STRING]
			-- List of all users in this channel, including myself


feature -- Sending messages

	notice (a_text: STRING) is
			-- Send a message to this channel. Automatic replies will
			-- never be send in response to `notice', this is the main
			-- difference with `privmsg'.
		require
			is_valid_text: client.is_valid_text (a_text)
		do
			client.notice (channel_name, a_text)
		end

	privmsg (a_text: STRING) is
			-- Send a message to this channel.
		require
			is_valid_text: client.is_valid_text (a_text)
		do
			client.privmsg (channel_name, a_text)
		end


feature {EPX_IRC_CLIENT} -- Handling

	handle (a_message: EPX_IRC_MESSAGE) is
			-- Respond to message if this is a message destined for this channel.
		do
			if is_message_for_channel (a_message) then
				if is_open then
					if a_message.has_reply_code then
						inspect a_message.reply_code
						when RPL_NOTOPIC then
							topic := Void
						when RPL_TOPIC then
							if a_message.parameters.count < 3 then
								topic := Void
							else
								topic := a_message.parameters.item (3)
							end
						else
							-- not handled
						end
					end
					from
						message_handlers.start
					until
						message_handlers.after
					loop
						message_handlers.item_for_iteration.handle (a_message)
						message_handlers.forth
					end
				else
					if
						a_message.nick_name /= Void and then
						a_message.nick_name.is_equal (joined_under_nick_name) and then
						a_message.command.is_equal (commands.join)
					then
						is_open := True
						joined_under_nick_name := Void
						after_open
					elseif a_message.reply_code = ERR_NOCHANMODES then
						is_refused := True
					end
				end
			end
		end


feature {NONE} -- Events

	after_open is
			-- Called if joining this channel was successful. Override if
			-- you want to do something immediately after joining a
			-- channel.
		require
			open: is_open
		do
		end


feature {EPX_IRC_CHANNEL, EPX_IRC_CHANNEL_HANDLER} -- Events

	user_in_channel (a_nick_name: STRING) is
			-- Called in response to /names (or when channel first joined).
		require
			nick_name_not_empty: a_nick_name /= Void and then not a_nick_name.is_empty
		local
			user: EPX_IRC_CHANNEL_USER
		do
			users.search (a_nick_name)
			if not users.found then
				user := new_user (a_nick_name)
				users.force (user, user.nick_name)
			end
		ensure
			nick_name_added_as_user: users.has (a_nick_name)
		end

	user_joined (a_message: EPX_IRC_MESSAGE) is
			-- Called if a user has joined the channel.
		require
			message_not_void: a_message /= Void
		local
			user: EPX_IRC_CHANNEL_USER
		do
			user := new_user (a_message.nick_name)
			users.force (user, user.nick_name)
		end

	user_left (a_message: EPX_IRC_MESSAGE) is
			-- Called if a user has left the channel.
		require
			message_not_void: a_message /= Void
			in_channel: users.has (a_message.nick_name)
		do
			users.search (a_message.nick_name)
			users.remove_found_item
		end

	user_nick_name_change (a_message: EPX_IRC_MESSAGE) is
			-- Called if a user has left the channel.
		require
			message_not_void: a_message /= Void
			in_channel: users.has (a_message.nick_name)
		local
			user: EPX_IRC_CHANNEL_USER
		do
			user := users.found_item
			users.remove_found_item
			if not a_message.parameters.is_empty then
				user.set_nick_name (a_message.parameters.first)
				users.put (user, user.nick_name)
			end
		end


feature {NONE} -- Factory

	new_user (a_nick_name: STRING): EPX_IRC_CHANNEL_USER is
			-- A new EPX_IRC_CHANNEL_USER object
		require
			nick_name_not_empty: a_nick_name /= Void and then not a_nick_name.is_empty
		do
			create Result.make (a_nick_name)
		ensure
			have_new_user: Result /= Void
		end


feature {NONE} -- Implementation

	joined_under_nick_name: STRING
			-- Temporary copy of the nick name used when joined this channel


invariant

	valid_channel_name: client.is_valid_channel_name (channel_name)
	users_not_void: users /= Void

end
