note

	description:

		"Register if signal has been received"


	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License"


class

	EPX_SIGNALLED_SIGNAL_HANDLER


inherit

	STDC_SIGNAL_HANDLER


feature -- Status

	is_signalled: BOOLEAN


feature {STDC_SIGNAL_SWITCH} -- Signal callback

	signalled (signal_value: INTEGER)
		do
			is_signalled := True
		end


end
