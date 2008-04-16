indexing

	description: "Class that makes the singleton STDC_SECURITY available."

	usage: "Inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #3 $"


class

	STDC_SECURITY_ACCESSOR


feature -- The singleton, available to any because it's used in preconditions

	security: STDC_SECURITY is
			-- Singleton entry point for security.
		once
			create Result
		ensure
			has_security: Result /= Void
		end


feature {NONE} -- Private test

	security_is_real_singleton: BOOLEAN is
			-- Do multiple calls to `singleton' return the same result?
		do
			Result := security = security
		end


invariant

	accessing_real_singleton: security_is_real_singleton

end
