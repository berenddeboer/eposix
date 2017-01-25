note

	description: "Abstract class for POSIX_SYSTEM routines that are also available under Windows."
	usage: "Inherit from EPX_SYSTEM."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

deferred class

	ABSTRACT_SYSTEM

inherit

	STDC_SYSTEM


feature -- Queries who's answer might depend on compile-time (Windows) or run-time (POSIX)

	max_argument_size: INTEGER
			-- The length of arguments for the exec() function
		deferred
		ensure
			result_not_negative: Result >= 0
		end

	max_open_files: INTEGER
			-- The maximum number of files that one process can have
			-- open at one time.
		deferred
		ensure
			result_not_negative: Result >= 0
		end

	max_open_streams: INTEGER
			-- The maximum number of streams that one process can have
			-- open at one time.
		deferred
		ensure
			result_not_negative: Result >= 0
		end

	max_time_zone_name: INTEGER
			-- The maximum number of bytes in a timezone name.
		deferred
		ensure
			result_not_negative: Result >= 0
		end


feature -- uname queries

	machine: STRING
			-- Name of the hardware type the system is running on.
		deferred
		end

	node_name: STRING
			-- Name of this node on the network.
		deferred
		end

	release: STRING
			-- Current release level of this implementation.
		deferred
		end

	system_name: STRING
			-- Name of the implementation of the operating system.
		deferred
		end

	version: STRING
			-- Current version level of this release.
		deferred
		end


end
