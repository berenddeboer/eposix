indexing

	description: "Class that covers Single Unix Spec sys/stat.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	SAPI_STAT


inherit

	PAPI_STAT


feature -- functions

	posix_lstat (a_path: POINTER; a_stat: POINTER): INTEGER is
			-- Gets information about a path or symbolic link
		require
			valid_stat_buffer: a_stat /= default_pointer

		external "C blocking"



		ensure
			-- Result = -1 implies errno.is_not_ok
		end


feature -- test file type bits

	posix_s_islnk (m: INTEGER): BOOLEAN is
		external "C"
		end


feature -- additional C stat member interface

	posix_st_blkcnt (a_stat: POINTER): INTEGER is
		external "C"
		end

	posix_st_blksize (a_stat: POINTER): INTEGER is
		external "C"
		end


end
