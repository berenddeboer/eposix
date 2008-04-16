indexing

	description:

		"Class that covers the SUSv3 <stropts.h> header"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2007/05/18 $"
	revision: "$Revision: #1 $"


class

	SAPI_STROPTS


feature -- Functions

	posix_ioctl(a_fildes: INTEGER; a_request: INTEGER; a_arg: POINTER): INTEGER is
			--  control a STREAMS device.
		require
			valid_fildes: a_fildes >= 0

		external "C blocking"



		end


end
