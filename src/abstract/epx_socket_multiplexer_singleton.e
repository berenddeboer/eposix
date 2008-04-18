indexing

	description: "Singleton for EPX_SOCKET_MULTIPLEXER"

	library: "eposix library"
	author: "Till G. Bay"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	EPX_SOCKET_MULTIPLEXER_SINGLETON

feature

	socket_multiplexer: EPX_SOCKET_MULTIPLEXER is
			-- The one and only socket multiplexer
		once
			create Result.make
		ensure
			not_void: Result /= Void
		end


end
