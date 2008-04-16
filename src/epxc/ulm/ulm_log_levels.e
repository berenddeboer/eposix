indexing

	description: "Class that lists the ULM log levels."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

  ULM_LOG_LEVELS

feature -- Log levels, values for the LVL field

	Emergency,
			-- Panic condition, broadcast to all users.
	Alert,
			-- Condition that should be corrected immediately.
	Error,
			-- System error, this level and the previous ones are reserved for
			-- system conditions.
	Warning,
			-- A program error, program has detected an incorrect behaviour
			-- of its own, for example an assertion failure
	Authentication,
			-- An authentication happened.
	Security,
			-- A standard protection was raised against what could be an
			-- intrusion. A connection denial based on the remote network
			-- address falls into this category.
	Usage,
			-- Normal, standard, authorized day-to-day usage information.
			-- If an application has to report delayed information about
			-- what is used, it should be reported as debugging
			-- information first (for crashproof logging), then summaried
			-- into an only usage message.
	System_usage,
			-- Tangible usage, but not treaceable to any user. Automated
			-- processus or system batch jobs fall into this category.
			-- Because of class with SmallEiffel's GENERAL, it is not
			-- just called System.
	Important,
			-- Information which could become criticial, but is not yet. A
			-- configuration change may be important information.
	Debugging: INTEGER is UNIQUE
			-- Not interesting in the normal course of life, they add no
			-- information when everything is in order.


feature -- Log levels description

	log_level_text: ARRAY [STRING] is
		once
			create Result.make (Emergency, Debugging)
			Result.put ("Emergency", Emergency)
			Result.put ("Alert", Alert)
			Result.put ("Error", Error)
			Result.put ("Warning", Warning)
			Result.put ("Authentication", Authentication)
			Result.put ("Security", Security)
			Result.put ("Usage", Usage)
			Result.put ("System", System_usage)
			Result.put ("Important", Important)
			Result.put ("Debug", Debugging)
		end

feature -- Queries

	is_valid_log_level (level: INTEGER): BOOLEAN is
			-- Returns True if `level' is a recognized log level.
		do
			Result := level >= Emergency and level <= Debugging
		end

invariant

	log_level_text_lower_index_ok: log_level_text.lower = Emergency
	log_level_text_upper_index_ok: log_level_text.upper = Debugging

end
