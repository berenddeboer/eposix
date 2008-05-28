indexing

	description: "Class that covers Single Unix Specification environment%
	%variable routines."

	usage: "Models one (possibly existing) variable."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	SUS_ENV_VAR


inherit

	POSIX_ENV_VAR

	SAPI_STDLIB
		export
			{NONE} all
		end


create

	make


feature -- Commands

	set_value (a_new_value: STRING) is
			-- Change environment value. Repeatedly creating a new
			-- SUS_ENV_VAR and calling `set_value' will lead to a memory
			-- leak.
		local
			namevalue: STRING
		do
			-- We have to create memory to hold the value, because the
			-- argument to `putenv' becomes part of the environment, and
			-- is not copied.
			namevalue := name + "=" + a_new_value
			if environment_string /= Void then
				-- In case we already have allocate memory, deallocate
				-- that memory first. Minimises memory leaks.
				if not environment_string.is_owner then
					environment_string.become_owner
				end
				environment_string.deallocate
			end
			create environment_string.allocate_and_clear (namevalue.count + 1)
			environment_string.put_string (namevalue, 0, namevalue.count - 1)
			safe_call (posix_putenv (environment_string.ptr))
			environment_string.unown
		end

feature {NONE} -- Implementation

	environment_string: STDC_BUFFER
			-- After `set_value' is called, this contains a pointer to the
			-- new string;
			-- It's part of the environment, so changing this is equal to
			-- changing the environment, so be careful.

end
