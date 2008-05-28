indexing

	description: "Field Message-Id"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_MIME_FIELD_MESSAGE_ID


inherit

	EPX_MIME_STRUCTURED_FIELD
		rename
			value as address_specification
		end

	EPX_FACTORY
		export
			{NONE} all
		end

	CAPI_TIME
		export
			{NONE} all
		end

	KL_SHARED_PLATFORM
		export
			{NONE} all
		end


create

	make,
	make_unique


feature -- Initialization

	make (a_address_specification: STRING) is
			-- Set Message-Id to `a_address_specification'.
		require
			address_specification_not_empty:
				a_address_specification /= Void and then
				not a_address_specification.is_empty
		do
			address_specification := a_address_specification
		end

	make_unique is
			-- Attempt to create a unique Message-Id.
		do
			-- The unix time and host name guarantee we can create one
			-- unique Message-Id per second if we're the only running program.
			-- We add message id so we're sure we can create one message
			-- per second regardless how many of us are running.
			-- We add a continually incrementing `counter' to that so we
			-- should be able to create up to `max_counter_value'
			-- unique Message-Ids per second.
			if counter.item = max_counter_value then
				counter.set_item (1)
			else
				counter.set_item (counter.item + 1)
			end
			address_specification := "<" + posix_time.out + "." + current_process.pid.out + "." + counter.out + "@" + system_info.node_name + ">"
		ensure
			proper_format:
				address_specification.item (1) = '<' and then
				address_specification.has ('@') and then
				address_specification.item (address_specification.count) = '>'
		end


feature -- Access

	name: STRING is "Message-Id"

	address_specification: STRING
			-- Unique Message-Id


feature {NONE} -- Implementation

	counter: INTEGER_REF is
			-- Continually incrementing counter which helps to create a
			-- unique Message-Id.
		once
			create Result
		ensure
			counter_not_void: Result /= Void
		end

	max_counter_value: INTEGER is
			-- Maximum value for `counter' before it should wrap around
		do
			Result := Platform.Maximum_integer
		end


invariant

	address_specification_not_empty: not address_specification.is_empty

end
