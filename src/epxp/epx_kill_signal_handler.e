note

	description:

		"Register if signal has been sent"


	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License"


class

	EPX_KILL_SIGNAL_HANDLER


inherit

	EPX_SIGNALLED_SIGNAL_HANDLER
		rename
			is_signalled as should_stop
		end


end
