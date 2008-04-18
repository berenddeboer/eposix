indexing

	description:

		"Base class for any date."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	EPX_MIME_FIELD_A_DATE


inherit

	EPX_MIME_STRUCTURED_FIELD


feature -- Initialization

	make (a_date_time: STDC_TIME) is
		require
			date_time_not_void: a_date_time /= Void
			time_zone_known: a_date_time.is_time_zone_known
		do
			date_time := a_date_time
		end


feature -- Access

	date_time: STDC_TIME
			-- date-time contents of field.

	value: STRING is
			-- Value of a field.
		do
			Result := date_time.rfc_date_string
		end


invariant

	date_time_not_void: date_time /= Void
	time_zone_known: date_time.is_time_zone_known

end
