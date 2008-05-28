indexing

	description: "Class that gets POSIX stat structure through stat call."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	POSIX_STATUS_PATH


inherit

	POSIX_STATUS

	ABSTRACT_STATUS_PATH
		export
			{POSIX_PERMISSIONS_PATH} path
		redefine
			refresh_may_fail
		end

	PAPI_STAT


create {EPX_FILE_SYSTEM}

	make,
	make_may_fail


feature -- stat members

	permissions: POSIX_PERMISSIONS is
			-- Path permissions
		do
			if my_permissions = Void then
				create {POSIX_PERMISSIONS_PATH} my_permissions.make (Current)
			end
			Result := my_permissions
		end


feature -- state change commands

	refresh_may_fail is
			-- Refresh the cached status information.
		do
			precursor
			if found and then my_permissions /= Void then
				my_permissions.update_from_status
			end
		end


feature {NONE} -- Implementation

	my_permissions: POSIX_PERMISSIONS


feature {NONE} -- abstract API

	abstract_stat (a_path: POINTER; a_stat: POINTER): INTEGER is
			-- Gets information about a path
		do
			Result := posix_stat (a_path, a_stat)
		end

end
