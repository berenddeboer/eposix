indexing

	description: "Class that makes the singleton STDC_EXIT_SWITCH available."

	usage: "Inherit from this class to access the singleton."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	STDC_EXIT_SWITCH_ACCESSOR


feature -- the singleton

	exit_switch: STDC_EXIT_SWITCH is
			-- singleton entry point for all eposix exit handlers
		once
			create Result.make
		ensure
			has_switch: Result /= Void
		end


feature {NONE} -- private test

	exit_switch_is_real_singleton: BOOLEAN is
			-- Do multiple calls to `singleton' return the same result?
		do
			Result := exit_switch = exit_switch
		end


invariant

	accessing_real_singleton: exit_switch_is_real_singleton

end
