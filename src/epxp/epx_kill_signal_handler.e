indexing

	description:

		"Register if signal has been sent"


	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License"


class

	EPX_KILL_SIGNAL_HANDLER


inherit

	STDC_SIGNAL_HANDLER


feature -- Access

	should_stop: BOOLEAN


feature {STDC_SIGNAL_SWITCH} -- Signal callback

	signalled (signal_value: INTEGER) is
		do
			should_stop := True
		end


end
