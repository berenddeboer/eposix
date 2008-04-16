indexing

	description: "Class that covers Posix time related routines."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #3 $"

class

	POSIX_TIME

inherit

	STDC_TIME
		select
			is_equal
		end

	POSIX_BASE
		rename
			is_equal as posix_base_is_equal
		end


creation

	make_date,
	make_date_time,
	make_from_now,
	make_time,
	make_from_unix_time


end
