indexing

	description: "Class that covers the Posix file permission."
	usage: "You can set the permissions, call apply to make them permanent."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	POSIX_PERMISSIONS_PATH

inherit

	POSIX_PERMISSIONS
		redefine
			status
		end

	PAPI_STAT

	PAPI_UNISTD


create

	make


feature {POSIX_FILE_SYSTEM} -- creation

	make (a_status: POSIX_STATUS_PATH) is
		do
			status := a_status
			update_from_status
		end


feature {NONE}


	apply_mode is
			-- make mode change permanent
		local
			cpath: POINTER
		do
			cpath := sh.string_to_pointer (status.path)
			safe_call (posix_chmod (cpath, mode))
			sh.unfreeze_all
		end

	apply_owner_and_group is
			-- make owner and group change permanent
		local
			cpath: POINTER
		do
			cpath := sh.string_to_pointer (status.path)
			safe_call (posix_chown (cpath, owner_id, group_id))
			sh.unfreeze_all
		end


feature {NONE}

	status: POSIX_STATUS_PATH
			-- used to be able to refresh itself


end -- class POSIX_PERMISSIONS_PATH
