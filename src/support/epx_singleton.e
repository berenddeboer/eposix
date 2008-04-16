indexing

	description: "Singleton base class."
	thanks: "Thanks to Design Patterns and Contracts."

	author: "Berend de Boer"
	date: "$Date: 2003/03/20 $"
	revision: "$Revision: #3 $"

deferred class

	EPX_SINGLETON


feature {NONE} -- Is singleton check

	singleton: EPX_SINGLETON is
			-- Redefine this method and make it frozen once. It should
			-- return current.
		deferred
		ensure
			returns_current: Result = Current
		end

	frozen the_singleton: EPX_SINGLETON is
		obsolete "Use singleton instead."
		do
			Result := singleton
		end

invariant

	remain_single: Current = singleton

end
