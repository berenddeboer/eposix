note

	description: "UNIX sockets, base class."

	author: "Berend de Boer"


class

	SUS_UNIX_SOCKET


inherit

	SUS_SOCKET

	SAPI_UN
		export
			{NONE} all;
			{ANY} is_valid_path_name
		end


create

	attach_to_socket


feature {NONE} -- Implementation

	file_system: SUS_FILE_SYSTEM
			-- Access to file system.
		once
			create Result
		ensure
			file_system_not_void: Result /= Void
		end

end
