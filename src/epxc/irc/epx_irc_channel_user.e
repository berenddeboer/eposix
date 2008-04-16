indexing

	description:

		"A user in an IRC channel"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/03/03 $"
	revision: "$Revision: #1 $"


class

	EPX_IRC_CHANNEL_USER


creation

	make


feature {NONE} -- Initialisation

	make (a_nick_name: STRING) is
		do
			nick_name := a_nick_name
		end


feature -- Access

	nick_name: STRING
			-- Nick name of user


feature -- Change

	set_nick_name (a_nick_name: STRING) is
		do
			nick_name := a_nick_name
		end

end
