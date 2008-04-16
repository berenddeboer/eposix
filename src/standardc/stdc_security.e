indexing

	description:
		"Describes various security aspects used by the Standard C classes."

	usage: "Inherit from STDC_SECURITY_ACCESSOR."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

class

	STDC_SECURITY


inherit

	EPX_SINGLETON

	STDC_BASE


feature -- Modes

	make_allow_all is
			-- Just allow everything.
		do
			assert_once_memory_allocated
		end

	make_allow_sandbox is
			-- Allow very little, use for setuid root programs.
		do
			assert_once_memory_allocated
		end


feature -- The security aspects

	cpu: STDC_SECURITY_CPU is
		once
			create Result.make
		end

	error_handling: STDC_SECURITY_ERROR_HANDLING is
		once
			create Result.make
		end

	files: STDC_SECURITY_FILES is
		once
			create Result.make
		end

	memory: STDC_SECURITY_MEMORY is
		once
			create Result.make
		end


feature -- Various

	assert_once_memory_allocated is
			-- Make sure that certain once functions in STDC_BASE are
			-- called. These once functions are called when an error
			-- occurs, at that time there might not be memory left to
			-- create them.
		local
			e: ANY
		do
			e := errno
		end


feature {NONE} -- Implementation

	frozen singleton: EPX_SINGLETON is
		once
			Result := Current
		end


end
