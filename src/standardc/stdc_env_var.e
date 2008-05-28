indexing

	description: "Class that covers Standard C environment variable routines."

	usage: "Models one (possibly existing) variable."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	STDC_ENV_VAR

inherit

	STDC_BASE

	CAPI_STDLIB

create

	make


feature -- Initialization

	make (a_name: STRING) is
		require
			valid_name: a_name /= Void and then not a_name.is_empty
			-- `a_name' doesn't have to be an existing variable
		do
			name := a_name
		end


feature -- Access

	exist: BOOLEAN is
			-- Is this environment variable defined?
		local
			cvalue: POINTER
		do
			cvalue := posix_getenv (sh.string_to_pointer (name))
			Result := cvalue /= default_pointer
			sh.unfreeze_all
		end

	name: STRING
			-- Name of environment variable.

	value: STRING is
			-- Current value of environment variable.
		local
			cvalue: POINTER
		do
			cvalue := posix_getenv (sh.string_to_pointer (name))
			Result := sh.pointer_to_string (cvalue)
			sh.unfreeze_all
		ensure
			-- contents of environment variable `name' if it exists
			-- or else the empty string
			not_void: Result /= Void
		end


end
