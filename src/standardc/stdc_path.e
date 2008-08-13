indexing

	description: "Class that covers a path on the file system.%
	%Also makes possible to use either a / or \ as directory separator%
	%(Unix or Windows convention).%
	%Optionally, it can do environment variable expansion for names as%
	%$(TMP), ${TMP}, $TMP or %%TMP%% (read single percent sign here!).%
	%Also recognizes ~ and replaces by $HOME except if ~ is followed by a%
	%digit, so it should work more or less on Windows when it should, and%
	%do nothing when it shouldn't."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #11 $"

class

	STDC_PATH


inherit

	STDC_PATH_BASE


create

	copy, -- needed for SE, might not work for other compilers
	make,
	make_from_string,
	make_expand


feature -- Initialization

	make_from_string (a_path: STRING) is
			-- The new path contains the correct directory separator
			-- independent of what is used in `s'
		require
			a_path_not_void: a_path /= Void
		do
			org_make_from_string (a_path)
			correct_directory_separator
			-- support Windooze, which doesn't like a trailing slash
			remove_trailing_slash
		end

	make_expand (s: STRING) is
			-- The new path is the expanded contents of `s'.
		require
			s_void: s /= Void
		do
			org_make_from_string (normalize_path (s))
			-- support Windooze, which doesn't like a trailing slash
			remove_trailing_slash
		end


feature -- Status

	is_absolute: BOOLEAN is
			-- Does the path start with a '/' or drive letter?
		do
			if is_windows then
				Result :=
					count >= 3 and then
					((item (1) >= 'a' and then item (1) <= 'z') or else
					 (item (1) >= 'A' and then item (1) <= 'Z')) and then
					(item (2) = ':') and then
					(item (3) = '\')
			else
				Result :=
					count > 0 and then
					(item (1) = '/' or else
					 item (1) = '\')
			end
		ensure
			absolute_if_directory_separator:
				not is_empty implies (item (1) = directory_separator implies Result)
		end

	is_portable_character (c: CHARACTER): BOOLEAN is
			-- Is c a POSIX portable character?
			--  i.e. can it safely be used in file names.
		do
			Result :=
				(c >= 'a' and c <= 'z') or else
				(c = '.') or else
				(c = '_') or else
				(c >= '0' and c <= '9') or else
				(c >= 'A' and c <= 'Z') or else
				(c = '-')
		end

	is_portable: BOOLEAN is
			-- Return True if this path is portable
		local
			i: INTEGER
		do
			from
				i := 1
				Result := True
			until
				not Result or i > count
			loop
				Result := is_portable_character (item (i))
					or else item (i) = directory_separator
				i := i + 1
			end
		end

	is_resolved: BOOLEAN is
			-- Does the path contain no relative components, i.e. a ".."
			-- somewhere?
		do
			Result :=
				not has_substring (once_dotdot) and then
				(count < 2 or else item (1) /= '.' or else item (2) /= '/') and then
				(count < 2 or else item (count) /= '/' or else item (count - 1) /= '.')
		end


feature -- Access

	directory,
	basename,
	suffix: STRING
			-- Individual components of path, only valid after `parse'
			-- has been called;
			-- Not automagically updated when path is changed, you have
			-- to call `parse' again.

	directory_separator: CHARACTER is
			-- The platform specific directory separator
			-- Or at least an attempt to return one.
		once
			if is_windows then
				Result := '\'
			else
				Result := '/'
			end
		end


feature -- Compare to string

	is_equal_to_string (s: STRING): BOOLEAN is
		require
			s_not_void: s /= Void
		do
			Result := STRING_.same_string (s, out)
		end


feature -- Change

	parse (suffix_list: ARRAY [STRING]) is
			-- Set `directory', `basename', and `suffix'.
			-- The suffix should be in `suffix_list' if it needs to be stripped.
			-- Suffix comparison is case-insensitive.
		local
			slash_position,
			suffix_position: INTEGER
			i: INTEGER
			found: BOOLEAN
			current_suffix: STRING
		do
			-- Find directory
			from
				slash_position := count
				found := False
			until
				found or slash_position = 0
			loop
				found := item (slash_position) = directory_separator
				slash_position := slash_position - 1
			end
			if  found then
				slash_position := slash_position + 1
				create directory.make_from_string (substring (1, slash_position - 1))
			else
				slash_position := 0
				directory := ""
			end

			-- suffix matches?
			found := suffix_list /= Void
			if found then
				from
					i := suffix_list.lower
					found := False
				until
					found or i > suffix_list.upper
				loop
					suffix := suffix_list.item (i)
					suffix_position := count - suffix.count + 1
					if suffix_position >= 1 then
						current_suffix := substring (suffix_position, count)
						found := STRING_.same_case_insensitive (current_suffix, suffix)
					end
					if not found then
						i := i + 1
					end
				end
			end
			if found then
				suffix := suffix.twin
			else
				suffix_position := count + 1
				suffix := ""
			end

			-- basename
			create basename.make_from_string (substring (slash_position + 1, suffix_position - 1))
		ensure
			directory_set: directory /= Void
			directory_does_not_end_in_slash:
				not directory.is_empty implies
					directory.item (directory.count) /= directory_separator
			suffix_set: suffix /= Void
			only_suffix_when_needed: suffix_list = Void implies suffix.is_empty
		end

	remove_trailing_slash is
			-- Remove last slash. Useful when path is a directory.
		local
			has_trailing_slash: BOOLEAN
		do
			has_trailing_slash := count > 0 and then item (count) = directory_separator
			if has_trailing_slash then
				remove (count)
			end
		ensure
			no_trailing_slash:
				count = 0 or else
				item (count) /= directory_separator
		end

	set_basename (new_basename: STRING) is
			-- Set `basename' from path.
		require
			new_basename_not_empty: new_basename /= Void and then not new_basename.is_empty
		do
			basename := new_basename
			rebuild_path
		ensure
			basename_set: STRING_.same_string (basename, new_basename)
		end

	set_directory (new_directory: STRING) is
			-- Build new path from `new_directory', `basename' and `suffix'
		require
			basename_not_empty: basename /= Void and then not basename.is_empty
		do
			if new_directory = Void then
				create directory.make_empty
			else
				directory := new_directory
			end
			rebuild_path
		ensure
			directory_set: new_directory /= Void implies STRING_.same_string (directory, new_directory)
		end

	set_suffix (new_suffix: STRING) is
			-- Build new path from current `directory', `basename' and
			-- `new_suffix'
		require
			basename_not_empty: basename /= Void and then not basename.is_empty
		do
			suffix := new_suffix
			rebuild_path
		ensure
			suffix_set: new_suffix /= Void implies STRING_.same_string (suffix, new_suffix)
			count_not_less_than_suffix: count >= new_suffix.count
			path_ends_with_suffix: STRING_.same_string (substring (count - new_suffix.count + 1, count), new_suffix)
		end


feature {NONE} -- Implementation

	correct_directory_separator is
			-- turn a '/' into a '\' or vice versa depending on the
			-- current platform
		local
			i: INTEGER
			c: CHARACTER
		do
			from
				i := 1
			until
				i > count
			loop
				c := item (i)
				inspect c
				when '/', '\' then
					put (directory_separator, i)
				else -- ok
				end
				i := i + 1
			end
		end

	normalize_path (s: STRING): STRING is
			-- Expand environment variables in `s'.
		require
			s_not_void: s /= Void
		local
			i, j: INTEGER
			start_name, stop_name: INTEGER
			c: CHARACTER
			env_name: STRING
		do
			-- Result := sh.make_with_capacity (s.count * 2)
			create Result.make (s.count * 2)
			from
				i := 1
			until
				i > s.count
			loop
				c := s.item (i)
				inspect c
				when '~' then
					if (i = 1) and then (s.count > 1) and then
						not is_digit (s.item (i+1)) then
						Result.append_string (home_directory)
					else
						Result.append_character (c)
					end
				when '\' then
					Result.append_character (directory_separator)
				when '/' then
					Result.append_character (directory_separator)
				when '$' then
					if (i < s.count) then
						inspect s.item (i+1)
						when '{' then
							start_name := i+2
							j := s.index_of ('}', start_name)
							stop_name := j-1
							i := j
						when '(' then
							start_name := i+2
							j := s.index_of (')', start_name)
							stop_name := j-1
							i := j
						when '$' then
							-- on Windows you can have temp names like tmp1.$$$
							Result.append_character (c)
						else
							start_name := i+1
							from
								j := start_name
							until
								j > s.count or else not is_env_character (s.item(j))
							loop
								j := j + 1
							end
							stop_name := j-1
							i := j-1
						end
						if start_name <= stop_name - 1 then
							env_name := s.substring (start_name, stop_name)
							Result.append_string (env_value (env_name))
						end
					else
						-- if last character is a $, do not consider it a
						-- special character
						Result.append_character (c)
					end
				when '%%' then
					start_name := i+1
					j := s.index_of ('%%', start_name)
					stop_name := j-1
					i := j
					env_name := s.substring (start_name, stop_name)
					Result.append_string (env_value (env_name))
				else
					Result.append_character (c)
				end
				i := i + 1
			end
		end

	env_value (env_name: STRING): STRING is
			-- Value of environment variable `env_name'
		local
			e: STDC_ENV_VAR
		do
			create e.make (env_name)
			Result := e.value
		end

	home_directory: STRING is
			-- Home directory, according to environment variable "HOME".
		local
			env_home: STDC_ENV_VAR
		do
			create env_home.make ("HOME")
			Result := env_home.value
		ensure
			home_directory_not_void: Result /= Void
		end

	is_digit (c: CHARACTER): BOOLEAN is
			-- return True if c is a digit, it seems with Eiffel you can
			-- write every shitty routine yourself it you want compatibility
		do
			Result := (c >= '0') and (c <= '9')
		end

	is_env_character (c: CHARACTER): BOOLEAN is
			-- return True if c can be used in an environment variable
			-- used by our expansion routine.
		do
			Result :=
				(c >= 'A' and c <= 'Z') or else
				(c >= 'a' and c <= 'z') or else
				(c >= '0' and c <= '9') or else
				(c = '_')
		end

	rebuild_path is
			-- Rebuild path from components `directory', `basename' and
			-- `suffix'.
		require
			basename_not_empty: basename /= Void and then not basename.is_empty
		do
			wipe_out
			if directory /= Void and then not directory.is_empty then
				append_string (directory)
				if directory.item (directory.count) /= directory_separator then
					append_character (directory_separator)
				end
			end
			append_string (basename)
			if suffix /= Void then
				append_string (suffix)
			end
		ensure
			not_empty: not is_empty
		end


feature {NONE} -- Implementation

	is_windows: BOOLEAN is
			-- Are we running on the Windows platform?
		external "C"
		end


feature {NONE} -- Once strings

	once_dotdot: STRING is "/../"


end
