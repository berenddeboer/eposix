indexing

	description: "Class that covers (ahem) the POSIX group database (/etc/group)."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	POSIX_GROUP_DATABASE


inherit

	POSIX_BASE

	PAPI_GRP
		export
			{NONE} all
		end

feature -- Queries

	is_existing_gid (gid: INTEGER): BOOLEAN is
			-- Does this gid exist in /etc/passwd?
			-- (or through NIS or whatever mechanisms that might be in use)
		local
			p: POINTER
		do
			p := posix_getgrgid (gid)
			Result := p /= default_pointer
		end

	is_existing_group (group: STRING): BOOLEAN is
			-- Does this name exists in /etc/group?
			-- (or through NIS or whatever mechanisms that might be in use)
		local
			p: POINTER
		do
			p := posix_getgrnam (sh.string_to_pointer (group))
			Result := p /= default_pointer
		end


end
