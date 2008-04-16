indexing

	description: "Class that gives another class the portable_path feature."

	usage: "Use facility inheritance. Simply use portable_path.make_expand%
	%to give portable path a new expanded path. portable_path is preallocated%
	%so this should save some creation/garbage collection overhead.%
	%Unfortunately this means we have routines with side effects..."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $";
	revision: "$Revision: #6 $"

class

	PORTABLE_PATH


feature {NONE} -- creation

	make_path is
		do
			if portable_path = Void then
				create portable_path.make (256)
			end
		end


feature -- Access

	portable_path: STDC_PATH
			-- Scratch path


feature -- Change

	set_portable_path (a_path: STRING) is
			-- Set `portable_path' to `a_path'.
		do
			if portable_path = Void then
				create portable_path.make_from_string (a_path)
			else
				portable_path.make_from_string (a_path)
			end
		end

end
