note

	description: "Class that gives another class the portable_path feature."

	usage: "Use facility inheritance. Simply use portable_path.make_expand%
	%to give portable path a new expanded path. portable_path is preallocated%
	%so this should save some creation/garbage collection overhead.%
	%Unfortunately this means we have routines with side effects..."

	author: "Berend de Boer"


class

	PORTABLE_PATH


feature -- Access

	portable_path: STDC_PATH
			-- Scratch path
		once
			create Result.make (256)
		end


feature -- Change

	set_portable_path (a_path: READABLE_STRING_GENERAL)
			-- Set `portable_path' to `a_path'.
		do
			portable_path.make_from_string (a_path.out)
		end

end
