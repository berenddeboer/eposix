note

	description: "Class that gets Posix stat structure through fstat call."

	author: "Berend de Boer"


class

	POSIX_STATUS_FILDES


inherit

	POSIX_STATUS

	ABSTRACT_STATUS_FILDES
		redefine
			refresh
		end


create {EPX_FILE_DESCRIPTOR}

	make


feature -- stat members

	permissions: POSIX_PERMISSIONS
			-- file permissions
		do
			if attached my_permissions as p then
				Result := p
			else
				create {POSIX_PERMISSIONS_FILDES} Result.make (Current)
				my_permissions := Result
			end
		end


feature -- state change commands

	refresh
			-- Refresh the cached status information
		do
			precursor
			if attached my_permissions then
				my_permissions.update_from_status
			end
		end


feature {NONE} -- state

	my_permissions: detachable POSIX_PERMISSIONS


feature {NONE} -- abstract API

	abstract_fstat (fildes: INTEGER; a_stat: POINTER): INTEGER
			-- Gets information about a file
		do
			Result := posix_fstat (fildes, a_stat)
		end


end -- class POSIX_STATUS_FILDES
