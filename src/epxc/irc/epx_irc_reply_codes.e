note

	description:

		"List of numeric replies which are generated in response to IRC commands"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_IRC_REPLY_CODES


feature -- Command responses

	RPL_WELCOME: INTEGER = 001
			-- "Welcome to the Internet Relay Network	<nick>!<user>@<host>"

	RPL_YOURHOST: INTEGER = 002
			-- "Your host is <servername>, running version <ver>"

	RPL_CREATED: INTEGER = 003
			-- "This server was created <date>"

	RPL_MYINFO: INTEGER = 004
			-- "<servername> <version> <available user modes> <available channel modes>"

	RPL_BOUNCE: INTEGER = 005
			-- "Try server <server name>, port <port number>";
			-- Sent by the server to a user to suggest an alternative
			-- server.  This is often used when the connection is refused
			-- because the server is already full.

	RPL_TRYAGAIN: INTEGER = 263
			-- "<command> :Please wait a while and try again."

	RPL_AWAY: INTEGER = 301
			-- "<nick> :<away message>"

	RPL_UNAWAY: INTEGER = 305
			-- ":You are no longer marked as being away"

	RPL_NOWAWAY: INTEGER = 306
			-- ":You have been marked as being away"

	RPL_LIST: INTEGER = 322
			-- "<channel> <# visible> :<topic>"

	RPL_LISTEND: INTEGER = 323
			-- ":End of LIST"

	RPL_NOTOPIC: INTEGER = 331
			-- "<channel> :No topic is set"

	RPL_TOPIC: INTEGER = 332
			-- "<channel> :<topic>"

	RPL_NAMREPLY: INTEGER = 353
			-- "( "=" / "*" / "@" ) <channel> :[ "@" / "+" ] <nick> *( " " [ "@" / "+" ] <nick> )"

	RPL_ENDOFNAMES: INTEGER = 366
			-- "<channel> :End of NAMES list"

	RPL_MOTDSTART: INTEGER = 375
			-- ":- <server> Message of the day - "

	RPL_MOTD: INTEGER = 372
			-- ":- <text>"

	RPL_ENDOFMOTD: INTEGER = 376
			-- ":End of MOTD command"


feature -- Error Replies

	ERR_NOSUCHNICK: INTEGER = 401
			-- "<nickname> :No such nick/channel"

	ERR_TOOMANYCHANNELS: INTEGER = 405
			-- "<channel name> :You have joined too many channels";
			-- Sent to a user when they have joined the maximum number of
			-- allowed channels and they try to join another channel.

	ERR_WASNOSUCHNICK: INTEGER = 406
			-- "<nickname> :There was no such nickname";
			-- Returned by WHOWAS to indicate there is no history
			-- information for that nickname.

	ERR_UNKNOWNCOMMAND: INTEGER = 421
			-- "<command> :Unknown command";
			-- Returned to a registered client to indicate that the
			-- command sent is unknown by the server.

	ERR_NONICKNAMEGIVEN: INTEGER = 431
			-- ":No nickname given";
			-- Returned when a nickname parameter expected for a command
			-- and isn't found.

	ERR_ERRONEUSNICKNAME: INTEGER = 432
			-- "<nick> :Erroneous nickname"
			-- Returned after receiving a NICK message which contains
			-- characters which do not fall in the defined set.  See
			-- section 2.3.1 for details on valid nicknames.

	ERR_NICKNAMEINUSE: INTEGER = 433
			-- "<nick> :Nickname is already in use";
			-- Returned when a NICK message is processed that results in
			-- an attempt to change to a currently existing nickname.

	ERR_NICKCOLLISION: INTEGER = 436
			-- "<nick> :Nickname collision KILL from <user>@<host>";
			-- Returned by a server to a client when it detects a
			-- nickname collision (registered of a NICK that already
			-- exists by another server).

	ERR_USERNOTINCHANNEL: INTEGER = 441
			-- "<nick> <channel> :They aren't on that channel";
			-- Returned by the server to indicate that the target user of
			-- the command is not on the given channel.

	ERR_NOTONCHANNEL: INTEGER = 442
			-- "<channel> :You're not on that channel";
			-- Returned by the server whenever a client tries to perform
			-- a channel affecting command for which the client isn't a
			-- member.

	ERR_USERONCHANNEL: INTEGER = 443
			-- "<user> <channel> :is already on channel";
			-- Returned when a client tries to invite a user to a channel
			-- they are already on.

	ERR_YOUREBANNEDCREEP: INTEGER = 465
			-- ":You are banned from this server";
			-- Returned after an attempt to connect and register yourself
			-- with a server which has been setup to explicitly deny
			-- connections to you.

	ERR_YOUWILLBEBANNED: INTEGER = 466
			-- Sent by a server to a user to inform that access to the
			-- server will soon be denied.

	ERR_CHANNELISFULL: INTEGER = 471
			-- "<channel> :Cannot join channel (+l)"

	ERR_NOCHANMODES: INTEGER = 477
			-- "<channel> :Channel doesn't support modes";
			-- It seems this is also send if user does not have permission.

end
