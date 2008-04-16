indexing

	description: "Class that covers Windows current system info related routines."

	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

class

	WINDOWS_SYSTEM

inherit

	EPX_SYSTEM

	WAPI_WINDOWS


feature -- Version info

	major_version: INTEGER is
			-- Windows minor version number, i.e. 5 for Windows
			-- 2000/XP/Windows 2003.
		do
			Result := posix_osversioninfoa_dwmajorversion (version_info.ptr)
		end

	minor_version: INTEGER is
			-- Windows minor version number, i.e. 51 for Windows 3.51.
		do
			Result := posix_osversioninfoa_dwminorversion (version_info.ptr)
		end

	service_pack: STRING is
			-- Service pack if service pack installed. String is like
			-- "Service Pack 2".
		once
			Result := version
		end


feature -- Status

	is_windows_2000: BOOLEAN is
			-- Are we running on Windows 2000?
		do
			Result := major_version = 5 and minor_version = 0
		end

	is_windows_2003: BOOLEAN is
			-- Are we running on Windows Server 2003?
		do
			Result := major_version = 5 and minor_version = 2
		end

	is_windows_xp: BOOLEAN is
			-- Are we running on Windows XP?
		do
			Result := major_version = 5 and minor_version = 1
		end


feature -- High-resolution performance counter

	performance_counter: INTEGER_64 is
			-- The current value of the high-resolution performance
			-- counter
		do
			safe_win_call (posix_queryperformancecounter ($temp))
			Result := temp
		end

	performance_frequency: INTEGER_64 is
			-- The frequency of the high-resolution performance counter,
			-- if one exists
		do
			safe_win_call (posix_queryperformancefrequency ($temp))
			Result := temp
		end


feature {NONE} -- Implementation

	temp: INTEGER_64


end
