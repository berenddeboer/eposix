indexing

	description:

		"Functions that deal with color present in IRC strings"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	EPX_IRC_COLOR


feature -- Removal

	without_color (s: STRING): STRING is
			-- `s' but with mirc color encoding removed;
			-- See http://www.mirc.co.uk/help/color.txt for more info.
			-- Color can only be interpreted correctly when the encoder
			-- has taken care that misinterpretations are impossible. See
			-- http://www.ircle.com/colorfaq.shtml for how the mirc color
			-- protocol is severly broken.
		local
			i: INTEGER
			stop: INTEGER
		do
			if s /= Void then
				Result := s.twin
				from
					i := 1
				until
					i > Result.count
				loop
					inspect Result.item (i)
					when control_b, control_o then
						Result.remove (i)
					when control_c then
						-- Try to match ^C N[,M]
						stop := i + 1
						if
							stop <= Result.count and then
							Result.item (stop) >= '0' and then
							Result.item (stop) <= '9'
						then
							stop := stop + 1
							if
								stop <= Result.count and then
								Result.item (stop) >= '0' and then
								Result.item (stop) <= '9'
							then
								stop := stop + 1
							end
							if
								stop + 1 <= Result.count and then
								Result.item (stop) = ',' and then
								Result.item (stop + 1) >= '0' and then
								Result.item (stop + 1) <= '9'
							then
								stop := stop + 2
								if
									stop <= Result.count and then
									Result.item (stop) >= '0' and then
									Result.item (stop) <= '9'
								then
									stop := stop + 1
								end
							end
							Result.remove_substring (i, stop - 1)
						else
							Result.remove (i)
						end
					else
						i := i + 1
					end
				end
			end
		ensure
			void_if_void: (s = Void) = (Result = Void)
		end


feature -- Color characters

	control_b: CHARACTER is '%/2/'
	control_c: CHARACTER is '%/3/'
	control_o: CHARACTER is '%/15/'

end
