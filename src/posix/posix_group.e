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
		export
			{NONE} all
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end


create

	make_from_name,
	make_from_gid


feature -- Initialization

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


feature -- Commands

	refresh is
			-- Refresh cache with latest info from user database.
		do
			group := posix_getgrnam (sh.string_to_pointer (name))
			sh.unfreeze_all
			if group = default_pointer then
				raise_posix_error
			end
		end


feature -- Status

	is_member (a_name: STRING): BOOLEAN is
			-- Is user `a_name' a member of this group?
			-- Only checks secondary membership, so will return false if
			-- this group is the user's primary group
		local
			members: ARRAY [STRING]
			i: INTEGER
		do
			members := ah.pointer_to_string_array (posix_gr_mem (group))
			from
				i := members.lower
			until
				Result or else
				i > members.upper
			loop
				Result := STRING_.same_string (members.item (i), a_name)
				i := i + 1
			end
		end


feature -- Access

	name: STRING
			-- Group name

	gid: INTEGER is
			-- ID number
		do
			Result := posix_gr_gid (group)
		end


feature {NONE} -- Implementation

	group: POINTER


invariant

	valid_group: group /= default_pointer

end
