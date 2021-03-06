note

	description:

		"NetLogger routines shared by various classes"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2008, Berend de Boer"
	license: "MIT License"


class

	NET_LOGGER_ROUTINES


feature -- Status

	is_valid_value (a_value: READABLE_STRING_8): BOOLEAN
			-- Is `a_value' valid according to the NetLogger spec?
			-- Should not contain the null or newline character.
		local
			c: CHARACTER
			i: INTEGER
		do
			if not a_value.is_empty then
				from
					i := 1
					Result := True
				until
					not Result or else
					i > a_value.count
				loop
					c := a_value.item (i)
					Result := c /= '%U' and then c /= '%N'
					i := i + 1
				end
			else
				Result := True
			end
		ensure
			no_new_line: Result implies not attached a_value or else not a_value.has ('%N')
		end

	is_valid_name (a_field_name: READABLE_STRING_8): BOOLEAN
			-- Is `a_field_name' is valid according to NetLogger spec?
			-- Basically it should consist of one or more letters and have
			-- no spaces.
		local
			i: INTEGER
			count: INTEGER
			c: CHARACTER
			state: INTEGER
		do
			Result := a_field_name /= Void and then not a_field_name.is_empty
			if Result then
				from
					i := 1
					count := a_field_name.count
					state := FN_Start
				until
					not Result or else
					i > count
				loop
					c := a_field_name.item (i)
					inspect c
					when 'A'..'Z','a'..'z' then
						state := FN_Next
					when '0'..'9', '-' then
						Result := state /= FN_Start
						state := FN_Next
					when '.' then
						Result := state = FN_Next
						state := FN_Dot
					else
						Result := False
					end
					i := i + 1
				end
				if Result then
					Result := state = FN_Next
				end
			end
		end


feature {NONE} -- Implementation

	FN_Start,
	FN_Next,
	FN_Dot: INTEGER = UNIQUE


end
