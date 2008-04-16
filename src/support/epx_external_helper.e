indexing

	description: "A way to program platform independent Eiffel code."

	usage: "inherit from this class."

	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_EXTERNAL_HELPER


feature {NONE} -- helper functions

	ah: ABSTRACT_ARRAY_HELPER is
			-- Features for mapping arrays to pointers
		once
			create {EPX_ARRAY_HELPER} Result
		ensure
			ah_not_void: Result /= Void
		end

	sh: ABSTRACT_STRING_HELPER is
			-- Feature for mapping pointers to strings and vice versa
		once
			create {EPX_STRING_HELPER} Result
		ensure
			sh_not_void: Result /= Void
		end

	ioh: ABSTRACT_IO_HELPER is
			-- Features to do as fast i/o as possible
		once
			create {EPX_IO_HELPER} Result
		ensure
			ioh_not_void: Result /= Void
		end

end
