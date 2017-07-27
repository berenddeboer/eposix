note

	description:

		"Class that covers Standard C time related routines. %
		%Assumes that ANSI C is POSIX compliant, so time is defined with %
		%base January 1, 1970. So dates before 1970 and after 2038 are not %
		%really supported...%
		%Time resolutation is one second."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2011, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_TIME

inherit

	STDC_TIME

create

	make_date,
	make_date_time,
	make_from_dt_date_time,
	make_from_utc_dt_date_time,
	make_from_now,
	make_from_unix_time,
	make_time,
	make_utc_date,
	make_utc_date_time,
	make_utc_time,
	make_from_iso_8601

end
