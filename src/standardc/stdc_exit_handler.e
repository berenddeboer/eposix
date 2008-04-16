indexing

	description: "Class for handling Standard C on exit calls."

	usage: "Inherit and implement execute."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


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
