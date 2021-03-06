note

	description: "Class that covers POSIX user routines."

	usage: "Models a single existing user."

	exceptions: "You get an exception if you create a user that does not exist."

	author: "Berend de Boer"


class

	POSIX_USER

inherit

	POSIX_BASE

	PAPI_PWD


create

	make_from_name,
	make_from_uid


feature -- creation

	make_from_name (a_name: STRING)
		require
			valid_name: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
			refresh
		end

	make_from_uid (a_uid: INTEGER)
		require
			valid_uid: a_uid >= 0
		do
			passwd := posix_getpwuid (a_uid)
			if passwd = default_pointer then
				raise_posix_error
				name := a_uid.out
			else
				name := sh.pointer_to_string (posix_pw_name (passwd))
			end
		end


feature -- Base commands

	refresh
			-- Refresh cache with latest info from user database.
		do
			passwd := posix_getpwnam (sh.string_to_pointer (name))
			if passwd = default_pointer then
				raise_posix_error
			end
			sh.unfreeze_all
		end


feature -- Access

	name: STRING
			-- login name

	uid: INTEGER
			-- ID number
		do
			Result := posix_pw_uid (passwd)
		end

	gid: INTEGER
			-- group ID number
		do
			Result := posix_pw_gid (passwd)
		end

	home_directory: STRING
			-- initial working directory
		do
			Result := sh.pointer_to_string (posix_pw_dir (passwd))
		end

	shell: STRING
			-- initial user program
		do
			Result := sh.pointer_to_string (posix_pw_shell (passwd))
		end


feature {NONE} -- Implementation

	passwd: POINTER


invariant

	valid_passwd: passwd /= default_pointer

end
