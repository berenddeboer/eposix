indexing

	description:

		"Tests if valid channel names, nick names, etc."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_IRC_NAMES


feature -- Status

	is_valid_channel_name (a_channel_name: STRING): BOOLEAN is
			-- Is `a_channel_name' a valid channel name?
			-- Channels names are strings (beginning with a '&', '#', '+'
			-- or '!'  character) of length up to fifty (50) characters.
			-- Apart from the requirement that the first character is
			-- either '&', '#', '+' or '!', the only restriction on a
			-- channel name is that it SHALL NOT contain any spaces ('
			-- '), a control G (^G or ASCII 7), a comma (',').
		do
			Result :=
				a_channel_name /= Void and then
				not a_channel_name.is_empty and then
				a_channel_name.count <= 50 and then
				channel_first_characters.has (a_channel_name.item (1)) and then
				not a_channel_name.has (' ') and then
				not a_channel_name.has (',') and then
				not a_channel_name.has (control_g)
		end

	is_valid_command (a_command: STRING): BOOLEAN is
		do
			Result :=
				a_command /= Void and then
				not a_command.is_empty and then
				not a_command.has ('%U') and then
				not a_command.has ('%N') and then
				not a_command.has ('%R')
		end

	is_valid_nick_name (a_nick_name: STRING): BOOLEAN is
			-- Is `a_nick_name' a valid nick name?
			-- `a_nick_name' should have a maximum length of 9
			-- characters, but this is not checked.
		do
			Result :=
				a_nick_name /= Void and then
				not a_nick_name.is_empty and then
				not a_nick_name.has (' ') and then
				not a_nick_name.has ('%U') and then
				not a_nick_name.has ('%N') and then
				not a_nick_name.has ('%R')
		ensure
			valid_implies_not_void: Result implies a_nick_name /= Void
		end

	is_valid_text (a_text: STRING): BOOLEAN is
			-- Can `a_text' be send as a message to a channel or a user?
			-- It must not be empty and not contain the NULL, CR or LF
			-- characters.
		do
			Result :=
				a_text /= Void and then
				not a_text.is_empty and then
				not a_text.has ('%U') and then
				not a_text.has ('%N') and then
				not a_text.has ('%R')
		end


feature -- Access

	channel_first_characters: STRING is "#&+!"
			-- Channel names must begin with one of the characters listed
			-- here

	control_g: CHARACTER is '%/007/'
		-- control G (ASCII 7)

end
