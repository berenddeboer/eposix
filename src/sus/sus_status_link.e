note

	description: "Class that gets Single Unix Spec stat structure through%
	%lstat call."

	author: "Berend de Boer"

class

	SUS_STATUS_LINK


inherit

	SUS_STATUS_PATH
		redefine
			abstract_stat
		end


create {SUS_FILE_SYSTEM}

	make,
	make_may_fail


feature {NONE} -- abstract API

	abstract_stat (a_path: POINTER; a_stat: POINTER): INTEGER
			-- Gets information about a file
		do
			Result := posix_lstat (a_path, a_stat)
		end


end
