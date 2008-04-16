indexing

	description: "Class that covers (ahem) the POSIX user database (passwd)."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	POSIX_USER_DATABASE

inherit

	POSIX_BASE

	PAPI_PWD


feature -- Access

	is_existing_uid (uid: INTEGER): BOOLEAN is
			-- Returns True if this uid exists in /etc/passwd
			-- (or through NIS or whatever mechanisms that might be in use)
		local
			p: POINTER
		do
			p := posix_getpwuid (uid)
			Result := p /= default_pointer
		end

	is_existing_login (login: STRING): BOOLEAN is
			-- Returns True if this login exists in /etc/passwd
			-- (or through NIS or whatever mechanisms that might be in use)
		local
			p: POINTER
		do
			p := posix_getpwnam (sh.string_to_pointer (login))
			Result := p /= default_pointer
			sh.unfreeze_all
		end

end
