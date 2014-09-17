note

	description: "Class that covers Single Unix Spec stat structure."

	author: "Berend de Boer"


deferred class

	SUS_STATUS


inherit

	POSIX_STATUS

	SUS_BASE

	SAPI_STAT


feature -- stat members

	block_count: INTEGER
			-- number of blocks allocated for this object.
		do
			Result := posix_st_blkcnt (stat.ptr)
		end

	block_size: INTEGER
			-- a filesystem-specific preferred I/O block size for this
			-- object.  In some filesystem types, this may vary from file
			-- to file.
		do
			Result := posix_st_blksize (stat.ptr)
		end

	is_symbolic_link: BOOLEAN
			-- Is this a symbolic link?
		do
			Result := posix_s_islnk (posix_st_mode (stat.ptr))
		end

end
