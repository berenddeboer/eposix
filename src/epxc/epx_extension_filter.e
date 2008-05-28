indexing

	description: "Filters files based on extension."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $";
	revision: "$Revision: #4 $"


class

	EPX_EXTENSION_FILTER

inherit

	ABSTRACT_PATH_FILTER
		redefine
			validate_directory,
			require_status
		end


create

	make


feature -- Initialization

	make (a_extension: STRING) is
			-- `a_extension' includes the '.', so should be something
			-- like ".e".
		require
			extension_not_empty: a_extension /= Void and then not a_extension.is_empty
		do
			extension := a_extension
		end


feature -- Access

	extension: STRING
			-- Any filename endings to check for like ".e".


feature -- Validation

	validate_directory: BOOLEAN is
			-- When encountering a directory, pass it to `is_valid' for
			-- validation or recurse immediately into that directory
			-- without ever passing the directory to `is_valid'?
		do
			Result := False
		end

	is_valid (status: ABSTRACT_STATUS; path_name: STRING): BOOLEAN is
		local
			i, j: INTEGER
		do
			if status.is_regular_file then
				i := path_name.count - extension.count + 1
				if i > 0 then
					from
						j := 1
						Result := True
					invariant
						i >= 1 and i <= path_name.count + 1
					variant
						(extension.count - j) + 1
					until
						not Result or else j > extension.count
					loop
						Result := path_name.item (i) = extension.item (j)
						i := i + 1
						j := j + 1
					end
				end
			end
		end

	require_status: BOOLEAN is
			-- Should `is_valid' be suppied with status?
			-- Getting a status is expensive, and is best be avoided.
		do
			Result := True
		end


invariant

	extension_not_empty: extension /= Void and then not extension.is_empty

end
