indexing

	description: "Class that covers POSIX group routines."

	usage: "Models a single existing group."

	exceptions: "You get an exception if you create or refresh a group %
	%that does not exist."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	POSIX_GROUP

inherit

	POSIX_BASE

	PAPI_GRP


creation

	make_from_name,
	make_from_gid


feature -- creation

	make_from_name (a_name: STRING) is
		do
			name := a_name
			refresh
		end

	make_from_gid (a_gid: INTEGER) is
		do
			group := posix_getgrgid (a_gid)
			if group = default_pointer then
				raise_posix_error
			end
			name := sh.pointer_to_string (posix_gr_name (group))
		end


feature -- refresh cache

	refresh is
			-- refresh cache with latest info from user database
		do
			group := posix_getgrnam (sh.string_to_pointer (name))
			sh.unfreeze_all
			if group = default_pointer then
				raise_posix_error
			end
		end


feature -- queries

	name: STRING
			-- group name

	gid: INTEGER is
			-- ID number
		do
			Result := posix_gr_gid (group)
		end


feature {NONE} -- state

	group: POINTER


invariant

	valid_group: group /= default_pointer

end -- class POSIX_GROUP
