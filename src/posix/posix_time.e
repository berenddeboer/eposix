indexing

	description: "Class that covers Posix time related routines."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

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


create

	make_date,
	make_date_time,
	make_from_now,
	make_time,
	make_from_unix_time


end
