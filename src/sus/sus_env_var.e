note

	description: "Class that covers Single Unix Specification environment%
	%variable routines."

	usage: "Models one (possibly existing) variable."

	author: "Berend de Boer"


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

	set_value (a_new_value: STRING)
			-- Change environment value. Repeatedly creating a new
			-- SUS_ENV_VAR and calling `set_value' will lead to a memory
			-- leak.
		require
			new_value_not_void: a_new_value /= Void
		local
			namevalue: STRING
			e: like environment_string
		do
			-- We have to create memory to hold the value, because the
			-- argument to `putenv' becomes part of the environment, and
			-- is not copied.
			namevalue := name + "=" + a_new_value
			if attached environment_string as es then
				-- In case we already have allocate memory, deallocate
				-- that memory first. Minimises memory leaks.
				if not es.is_owner then
					es.become_owner
				end
				es.deallocate
			end
			create e.allocate_and_clear (namevalue.count + 1)
			environment_string := e
			e.put_string (namevalue, 0, namevalue.count - 1)
			safe_call (posix_putenv (e.ptr))
			e.unown
		end

feature {NONE} -- Implementation

	environment_string: detachable STDC_BUFFER
			-- After `set_value' is called, this contains a pointer to the
			-- new string;
			-- It's part of the environment, so changing this is equal to
			-- changing the environment, so be careful.

end
