indexing

	description: "Class that makes the singleton STDC_SIGNAL_SWITCH available."

	usage: "Inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	STDC_SIGNAL_SWITCH_ACCESSOR


feature -- Access

	signal_switch: STDC_SIGNAL_SWITCH is
			-- singleton entry point for all catched signals
		once
			create Result.make
		ensure
			has_switch: Result /= Void
		end


feature {NONE} -- Implementation

	signal_switch_is_real_singleton: BOOLEAN is
			-- Do multiple calls to `singleton' return the same result?
		do
			Result := signal_switch = signal_switch
		end


invariant

		--accessing_real_singleton: signal_switch_is_real_singleton
	-- Gives crash with ISE Eiffel

end
