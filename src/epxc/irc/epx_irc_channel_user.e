indexing

	description:

		"A user in an IRC channel"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_IRC_CHANNEL_USER


create

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
