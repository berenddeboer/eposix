indexing

	description:

		"LDIF input buffer that can handle folded lines."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_LDIF_BUFFER


inherit

	EPX_STREAM_BUFFER
		redefine
			fill
		end


create

	make


feature -- Element change

	fill is
			-- Fill and concatenate folded lines.
		local
			i: INTEGER
			is_folding: BOOLEAN
		do
			precursor
			if filled then
				from
					i := position
				variant
					(count + 2) - i
				until
					i >= count
				loop
					is_folding :=
						content.item (i) = '%N' and then
						content.item (i + 1) = ' '
					if is_folding then
						-- Take care to move the two EOB characters at the
						-- end as well
						if i > 1 and then content.item (i - 1) = '%R' then
							-- end-of-line is \r\n, so remove "%R%N "
							content.move_left (i + 2, i - 1, (count - i) + 1)
							count := count - 3
						else
							content.move_left (i + 2, i, (count - i) + 1)
							count := count - 2
						end
					end
					i := i + 1
				end
			end
		end

end
