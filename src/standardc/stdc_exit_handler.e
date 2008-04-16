indexing

	description: "Class for handling Standard C on exit calls."

	usage: "Inherit and implement execute."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #2 $"


deferred class

	STDC_EXIT_HANDLER


inherit

	STDC_EXIT_SWITCH_ACCESSOR


feature {STDC_EXIT_SWITCH} -- main function

	execute is
			-- Callback when program exitst normally.
			-- To be implemented in descendents.
		deferred
		end


end
