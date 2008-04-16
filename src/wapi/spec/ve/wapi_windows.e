indexing

	description: "Class that covers Windows windows.h."

	notes: "Only tested if function exists in Windows 2000. Might use functions%
	%that do not exist on Windows 9x, but this will be rectified when notified."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	WAPI_WINDOWS


feature -- Error constants

	ERROR_SUCCESS: INTEGER is 0

	ERROR_INVALID_FUNCTION: INTEGER is 1

	ERROR_BROKEN_PIPE: INTEGER is 109

	ERROR_INSUFFICIENT_BUFFER: INTEGER is 122

	ERROR_INVALID_HANDLE: INTEGER is 6

	ERROR_INVALID_PARAMETER: INTEGER is 87

	ERROR_MORE_DATA: INTEGER is 234

	ERROR_NO_DATA: INTEGER is 232

	ERROR_NOT_SUPPORTED: INTEGER is 50


feature -- Error handling

	posix_getlasterror: INTEGER is
			-- returns the calling thread's last-error code value.
		external "C"
		end

	posix_geterrormessage (error_number: INTEGER): POINTER is
			-- Error message for `error_number'
		external "C"
		end


feature -- Find file API

	posix_findfirstfile (a_filename, a_find_file_data: POINTER): POINTER is
		require
			filename_not_nil: a_filename /= default_pointer
			find_file_data_not_nil: a_find_file_data /= default_pointer



		external "C"

		end

	posix_findnextfile (a_handle, a_find_file_data: POINTER): BOOLEAN is
		require
			handle_not_nil: a_handle /= default_pointer
			find_file_data_not_nil: a_find_file_data /= default_pointer



		external "C"

		end

	posix_findclose (a_handle: POINTER): BOOLEAN is
		require
			handle_not_nil: a_handle /= default_pointer
		external "C"
		end


feature -- Directories

	posix_gettemppath (len: INTEGER; buf: POINTER): INTEGER is
			-- This function retrieves the path of the directory designated
			-- for temporary files.
		external "C"
		end


feature -- Handle related functions

	posix_closehandle (hObject: INTEGER): BOOLEAN is
			-- Closes an open object handle.



		external "C"

		end

	posix_duplicatehandle (
								  hSourceProcessHandle, hSourceHandle, hTargetProcessHandle: INTEGER;
								  lpTargetHandle: POINTER; dwDesiredAccess: INTEGER;
								  bInheritHandle: BOOLEAN; dwOptions: INTEGER): BOOLEAN is
			--  Duplicates an object handle.
		external "C"
		end

	posix_waitforsingleobject (hHandle: INTEGER; dwMilliseconds: INTEGER): INTEGER is
			-- Returns when one of the following occurs:
			-- * The specified object is in the signaled state.
			-- * The time-out interval elapses.
			-- The return value is WAIT_FAILED if some error has
			-- occured. Else it is WAIT_ABANDONED, WAIT_OBJECT_0 or
			-- WAIT_TIMEOUT.



		external "C"

		end


feature -- Windows file descriptors, really handles

	posix_createfile (lpFileName: POINTER; dwDesiredAccess, dwShareMode: INTEGER; lpSecurityAttributes: POINTER;  dwCreationDistribution, dwFlagsAndAttributes, hTemplateFile: INTEGER): INTEGER is
			-- Creates or opens an object and returns a handle that can
			-- be used to access the object



		external "C"

		end

	posix_getfileinformationbyhandle (hFile: INTEGER; lpFileInformation: POINTER): BOOLEAN is
			-- Retrieves information about a specified file.



		external "C"

		end

	posix_getfiletype (hFile: INTEGER): INTEGER is
			-- Returns the type of the specified file.
		external "C"
		end

	posix_getstdhandle (nStdHandle: INTEGER): INTEGER is
			-- Returns a handle for the standard input, standard output,
			-- or standard error device.
		external "C"
		end

	posix_readfile (hFile: INTEGER; lpBuffer: POINTER NumberOfBytesToRead: INTEGER; lpNumberOfBytesRead: POINTER; lpOverlapped: POINTER): BOOLEAN is
			-- Reads data from a file, starting at the position indicated
			-- by the file pointer.
		require
			number_of_bytes_parameter_ok: lpOverlapped = default_pointer implies lpNumberOfBytesRead /= default_pointer



		external "C"

		end

	posix_setfilepointer (hFile: INTEGER; lDistanceToMove: INTEGER; lpDistanceToMoveHigh: POINTER; dwMoveMethod: INTEGER): INTEGER is
			-- Moves the file pointer of an open file.
			-- We rely on SEEK_END and FILE_END etc. to be the same...
		external "C"
		end

	posix_setstdhandle (nStdHandle, hHandle: INTEGER): BOOLEAN is
			-- Set the handle for the standard input, standard output, or
			-- standard error device.
		external "C"
		end

	posix_writefile (hFile: INTEGER; lpBuffer: POINTER NumberOfBytesToWrite: INTEGER; lpNumberOfBytesWritten: POINTER; lpOverlapped: POINTER): BOOLEAN is
			-- Reads data from a file, starting at the position indicated
			-- by the file pointer.



		external "C"

		end


feature -- Shared memory

	posix_createfilemapping (hFile: INTEGER; lpAttributes: POINTER; flProtect, dwMaximumSizeHigh, dwMaximumSizeLow: INTEGER; lpName: POINTER): INTEGER is
			-- Creates or opens a named or unnamed file mapping object
			-- for the specified file.
		require
			have_size: hFile = INVALID_HANDLE_VALUE implies dwMaximumSizeHigh /= 0 or else dwMaximumSizeLow /= 0



		external "C"

		end

	posix_openfilemapping (dwDesiredAccess: INTEGER; bInheritHandle: BOOLEAN; lpName: POINTER): INTEGER is
			-- Open a named file mapping object.



		external "C"

		end

	posix_mapviewoffile (hFileMappingObject, dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap: INTEGER): POINTER is
			-- Map a view of a file into the address space of the calling process.
		external "C"
		end

	posix_mapviewoffileex (hFileMappingObject, dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap: INTEGER; lpBaseAddress: POINTER): POINTER is
			-- Map a view of a file into the address space of the calling process.
		external "C"
		end

	posix_unmapviewoffile (lpBaseAddress: POINTER): BOOLEAN is
			-- Unmap a mapped view of a file from the calling process's
			-- address space.
		external "C"
		end


feature -- Semaphores

	posix_createsemaphore (lpSemaphoreAttributes: POINTER; lInitialCount, lMaximumCount: INTEGER; lpName: POINTER): INTEGER is
			-- Create or open a named or unnamed semaphore object.
		require
			lInitialCount_not_negative: lInitialCount >= 0
			lMaximumCount_positive: lMaximumCount > 0



		external "C"

		end

	posix_opensemaphore (dwDesiredAccess: INTEGER; bInheritHandle: BOOLEAN; lpName: POINTER): INTEGER is
			-- Open an existing named semaphore object.
		require
			name_not_nil: lpName /= default_pointer



		external "C"

		end

	posix_releasesemaphore (hSemaphore, lReleaseCount: INTEGER; lpPreviousCount: POINTER): BOOLEAN is
			-- Increase the count of the specified semaphore object by
			-- `lReleaseCount'
		require
			hSemaphore_is_handle: hSemaphore /= 0
			lReleaseCount_positive: lReleaseCount > 0
		external "C"
		end


feature -- Process

	posix_createprocess (lpApplicationName: POINTER;
								lpCommandLine: POINTER;
								lpProcessAttributes: POINTER;
								lpThreadAttributes: POINTER;
								bInheritHandles: BOOLEAN;
								dwCreationFlags: INTEGER;
								lpEnvironment: POINTER;
								lpCurrentDirectory: POINTER;
								lpStartupInfo: POINTER;
								lpProcessInformation: POINTER): BOOLEAN is
			-- Creates a new process and its primary thread. The new process
			-- executes the specified executable file.
		require
			have_lpStartupInfo: lpStartupInfo /= default_pointer
			have_lpProcessInformation: lpProcessInformation /= default_pointer



		external "C"

		end

	posix_getcurrentprocess: INTEGER is
			-- Returns a pseudohandle for the current process.
		external "C"
		end

	posix_getcurrentprocessid: INTEGER is
			-- The GetCurrentProcessId function returns the process
			-- identifier of the calling process.
		external "C"
		end

	posix_getexitcodeprocess (hProcess: INTEGER; lpExitCode: POINTER): BOOLEAN is
			-- Retrieves the termination status of the specified process.
		external "C"
		end

	posix_terminateprocess (hProcess: INTEGER; uExitCode: INTEGER): BOOLEAN is
			-- Terminates the specified process and all of its threads.
		external "C"
		end


feature -- Environment variables

	posix_freeenvironmentstrings(lpszEnvironmentBlock: POINTER): BOOLEAN is
			-- Free a block of environment strings obtained by
			-- `posix_getenvironmentstrings'.
		require
			lpszEnvironmentBlock_not_nil: lpszEnvironmentBlock /= default_pointer
		external "C"
		end

	posix_getenvironmentstrings: POINTER is
			-- The environment variables for the current process
		external "C"
		end

	posix_getenvironmentvariable(lpName, lpBuffer: POINTER; nSize: INTEGER): INTEGER is
			-- The contents of the specified variable from the
			-- environment block of the calling process
		require
			lpName_not_nil: lpName /= default_pointer
			lpBuffer_not_nil: lpBuffer /= default_pointer
			size_positive: nSize > 0
		external "C"
		end

	posix_setenvironmentvariable(lpName, lpValue: POINTER): BOOLEAN is
			-- Sets the contents of the specified environment variable
			-- for the current process.
			-- The operating system creates the environment variable if
			-- it does not exist and `lpValue' is not NULL.
			-- If `lpValue' is NULL, the variable is deleted from the
			-- current process's environment.
		require
			lpName_not_nil: lpName /= default_pointer
		external "C"
		end


feature -- NT event logging

	posix_registereventsource (lpUNCServerName, lpSourceName: POINTER): INTEGER is
			-- Retrieve a registered handle to an event log. Returns 0 if fails.
			-- `lpSourceName' must be a subkey of a logfile entry under
			-- the EventLog key in the registry.
		require
			have_source_name: lpSourceName /= default_pointer



		external "C"

		end

	posix_reportevent (hEventLog, wType, wCategory, dwEventID: INTEGER; lpUserSid: POINTER; wNumStrings, dwDataSize: INTEGER; lpStrings, lpRawData: POINTER): BOOLEAN is
			-- Write an entry at the end of the specified event log.
		require
			valid_handle: hEventLog /= 0
			valid_event_type: wType >= 0
			valid_category: wCategory >= 0
			lpStrings_is_there_when_needed: wNumStrings > 0 implies lpStrings /= default_pointer
			lpRawData_is_there_when_needed: dwDataSize /= 0 implies lpRawData /= default_pointer



		external "C"

		end

	posix_deregistereventsource (hEventLog: INTEGER): BOOLEAN is
			-- Closes a write handle to the specified event log.
		require
			valid_handle: hEventLog /= 0
		external "C"
		end


feature -- Windows console functions

	posix_getnumberofconsoleinputevents (hConsoleInput: INTEGER; lpcNumberOfEvents: POINTER): BOOLEAN is
			-- Retrieves the number of unread input records in the
			-- console's input buffer.
		external "C"
		end

	posix_peekconsoleinput (hConsoleInput: INTEGER; lpBuffer: POINTER; nLength: INTEGER; lpNumberOfEventsRead: POINTER): BOOLEAN is
			-- Read data from the specified console input buffer without
			-- removing it from the buffer.
		external "C"
		end


feature -- Security functions

	posix_getusername (lpBuffer: POINTER; nSize: POINTER): BOOLEAN is
			-- Retrieves the name of the user associated with the current
			-- thread.
		require
			buffer_not_nil: lpBuffer /= default_pointer
			nSize_not_nil: nSize /= default_pointer
			--nSize_large_enough: *nSize > 1
			--nSize_not_too_large: *nSize <= 32676
		external "C"
		end

	posix_initializesecuritydescriptor (pSecurityDescriptor: POINTER; dwRevision: INTEGER): BOOLEAN is
			-- Initializes a security descriptor to have no SACL, no
			-- DACL, no owner, no primary group, and all control flags
			-- set to FALSE (NULL). Thus, except for its revision level,
			-- it is empty.
		require
			pSecurityDescriptor_not_nil: pSecurityDescriptor /= default_pointer
		external "C"
		end

	posix_setsecuritydescriptordacl (pSecurityDescriptor: POINTER; bDaclPresent: BOOLEAN; pDacl: POINTER; bDaclDefaulted: BOOLEAN): BOOLEAN is
			-- Set information in a DACL. If a DACL is already present
			-- in `pSecurityDescriptor', the DACL is replaced.
		require
			pSecurityDescriptor_not_nil: pSecurityDescriptor /= default_pointer
		external "C"
		end


feature -- High resolution timing

	posix_queryperformancefrequency (lpFrequency: POINTER): BOOLEAN is
			-- Retrieve the frequency of the high-resolution performance
			-- counter, if one exists.
			-- If the installed hardware supports a high-resolution
			-- performance counter, the return value is nonzero.
		require
			lpFrequency_not_nil: lpFrequency /= default_pointer
		external "C"
		end

	posix_queryperformancecounter (lpPerformanceCount: POINTER): BOOLEAN is
			-- Retrieve the current value of the high-resolution
			-- performance counter.
		require
			lpPerformanceCount_not_nil: lpPerformanceCount /= default_pointer
		external "C"
		end


feature -- Various

	posix_sleep (dwMilliseconds: INTEGER) is
			-- Suspends the execution of the current thread for a
			-- specified interval.
		require
			dwMilliseconds_not_negative: dwMilliseconds >= 0



		external "C"

		end

	posix_getversionex (lpVersionInformation: POINTER): BOOLEAN is
			-- Obtain extended information about the version of the
			-- operating system that is currently running.
		external "C"
		end


feature -- Struct WIN32_FIND_DATA

	posix_win32_find_data_size: INTEGER is
		external "C"
		end

	posix_win32_find_data_filename (a_find_data: POINTER): POINTER is
		require
			find_data_not_nil: a_find_data /= default_pointer
		external "C"
		end

	posix_win32_find_data_ftcreationtime (a_find_data: POINTER): INTEGER is
			-- Unix time of creation.
		require
			find_data_not_nil: a_find_data /= default_pointer
		external "C"
		end

	posix_win32_find_data_ftlastaccesstime (a_find_data: POINTER): INTEGER is
			-- Unix time of last access.
		require
			find_data_not_nil: a_find_data /= default_pointer
		external "C"
		end

	posix_win32_find_data_ftlastwritetime (a_find_data: POINTER): INTEGER is
			-- Unix time of last modification.
		require
			find_data_not_nil: a_find_data /= default_pointer
		external "C"
		end


feature -- C binding for members of SECURITY_ATTRIBUTES

	posix_security_attributes_size: INTEGER is
		external "C"
		end

	posix_security_attributes_nlength (a_SECURITY_ATTRIBUTES: POINTER): INTEGER is
		external "C"
		end

	posix_security_attributes_lpsecuritydescriptor (a_SECURITY_ATTRIBUTES: POINTER): POINTER is
		external "C"
		end

	posix_security_attributes_binherithandle (a_SECURITY_ATTRIBUTES: POINTER): BOOLEAN is
		external "C"
		end

	posix_set_security_attributes_nlength (a_SECURITY_ATTRIBUTES: POINTER; nLength: INTEGER) is
		external "C"
		end

	posix_set_security_attributes_lpsecuritydescriptor (a_SECURITY_ATTRIBUTES: POINTER; lpSecurityDescriptor: POINTER) is
		external "C"
		end

	posix_set_security_attributes_binherithandle (a_SECURITY_ATTRIBUTES: POINTER; bInheritHandle: BOOLEAN) is
		external "C"
		end


feature -- C binding for members of SECURITY_DESCRIPTOR

	posix_security_descriptor_size: INTEGER is
		external "C"
		end


feature -- C binding for members of STARTUPINFO

	posix_startupinfo_size: INTEGER is
		external "C"
		end

	posix_startupinfo_cb (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_lpreserved (a_STARTUPINFO: POINTER): POINTER is
		external "C"
		end

	posix_startupinfo_lpdesktop (a_STARTUPINFO: POINTER): POINTER is
		external "C"
		end

	posix_startupinfo_lptitle (a_STARTUPINFO: POINTER): POINTER is
		external "C"
		end

	posix_startupinfo_dwx (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_dwy (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_dwxsize (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_dwysize (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_dwxcountchars (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_dwycountchars (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_dwfillattribute (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_dwflags (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_wshowwindow (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_cbreserved2 (a_STARTUPINFO: POINTER): INTEGER is
		external "C"
		end

	posix_startupinfo_lpreserved2 (a_STARTUPINFO: POINTER): POINTER is
		external "C"
		end

	posix_startupinfo_hstdinput (a_STARTUPINFO: POINTER): BOOLEAN is
		external "C"
		end

	posix_startupinfo_hstdoutput (a_STARTUPINFO: POINTER): BOOLEAN is
		external "C"
		end

	posix_startupinfo_hstderror (a_STARTUPINFO: POINTER): BOOLEAN is
		external "C"
		end

	posix_set_startupinfo_cb (a_STARTUPINFO: POINTER; cb: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_lpreserved (a_STARTUPINFO: POINTER; lpReserved: POINTER) is
		external "C"
		end

	posix_set_startupinfo_lpdesktop (a_STARTUPINFO: POINTER; lpDesktop: POINTER) is
		external "C"
		end

	posix_set_startupinfo_lptitle (a_STARTUPINFO: POINTER; lpTitle: POINTER) is
		external "C"
		end

	posix_set_startupinfo_dwx (a_STARTUPINFO: POINTER; dwX: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_dwy (a_STARTUPINFO: POINTER; dwY: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_dwxsize (a_STARTUPINFO: POINTER; dwXSize: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_dwysize (a_STARTUPINFO: POINTER; dwYSize: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_dwxcountchars (a_STARTUPINFO: POINTER; dwXCountChars: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_dwycountchars (a_STARTUPINFO: POINTER; dwYCountChars: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_dwfillattribute (a_STARTUPINFO: POINTER; dwFillAttribute: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_dwflags (a_STARTUPINFO: POINTER; dwFlags: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_wshowwindow (a_STARTUPINFO: POINTER; wShowWindow: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_cbreserved2 (a_STARTUPINFO: POINTER; cbReserved2: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_lpreserved2 (a_STARTUPINFO: POINTER; lpReserved2: POINTER) is
		external "C"
		end

	posix_set_startupinfo_hstdinput (a_STARTUPINFO: POINTER; hStdInput: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_hstdoutput (a_STARTUPINFO: POINTER; hStdOutput: INTEGER) is
		external "C"
		end

	posix_set_startupinfo_hstderror (a_STARTUPINFO: POINTER; hStdError: INTEGER) is
		external "C"
		end


feature -- C binding for members of PROCESS_INFORMATION

	posix_process_information_size: INTEGER is
		external "C"
		end

	posix_process_information_hprocess (a_PROCESS_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_process_information_hthread (a_PROCESS_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_process_information_dwprocessid (a_PROCESS_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_process_information_dwthreadid (a_PROCESS_INFORMATION: POINTER): INTEGER is
		external "C"
		end


feature -- Constants

	DUPLICATE_SAME_ACCESS: INTEGER is
		external "C"
		alias "const_duplicate_same_access"
		end

	INFINITE: INTEGER is
		external "C"
		alias "const_infinite"
		end

	INVALID_HANDLE_VALUE: INTEGER is -1
			-- Value returned by various functions that create or return
			-- handles and want to signify an error

	INVALID_PTR_HANDLE_VALUE: POINTER is
		external "C"
		alias "const_invalid_ptr_handle_value"
		end

	MAX_PATH: INTEGER is
		external "C"
		alias "const_max_path"
		end

	SW_HIDE: INTEGER is
		external "C"
		alias "const_sw_hide"
		end


feature -- C binding for members of _OSVERSIONINFOA

	posix_osversioninfoa_size: INTEGER is
		external "C"
		ensure
			valid_size: Result > 0
		end

	posix_osversioninfoa_dwosversioninfosize (a_osversioninfoa: POINTER): INTEGER is
		require
			have_struct_pointer: a_osversioninfoa /= default_pointer
		external "C"
		end

	posix_osversioninfoa_dwmajorversion (a_osversioninfoa: POINTER): INTEGER is
			-- Major version number of the operating system. As you would
			-- expect Windows 2000, Windows XP and Windows 2003 all are
			-- version 5 for example. Probably a new trend that will
			-- continue up to Windows 9999.
		require
			have_struct_pointer: a_osversioninfoa /= default_pointer
		external "C"
		end

	posix_osversioninfoa_dwminorversion (a_osversioninfoa: POINTER): INTEGER is
			-- Minor version number of the operating system. Windows 2000
			-- is minor version 0, Windows XP is minor version 1, and
			-- Windows Server 2003 is minor version 2.
		require
			have_struct_pointer: a_osversioninfoa /= default_pointer
		external "C"
		end

	posix_osversioninfoa_dwbuildnumber (a_osversioninfoa: POINTER): INTEGER is
			-- Build number of the operating system.
		require
			have_struct_pointer: a_osversioninfoa /= default_pointer
		external "C"
		end

	posix_osversioninfoa_dwplatformid (a_osversioninfoa: POINTER): INTEGER is
			-- Operating system platform. Windows 32s, Windows 9x or
			-- Windows NT.
		require
			have_struct_pointer: a_osversioninfoa /= default_pointer
		external "C"
		end

	posix_osversioninfoa_szcsdversion (a_osversioninfoa: POINTER): POINTER is
			-- Pointer to a null-terminated string, such as "Service Pack
			-- 3", that indicates the latest Service Pack installed on
			-- the system. If no Service Pack has been installed, the
			-- string is empty.
		require
			have_struct_pointer: a_osversioninfoa /= default_pointer
		external "C"
		end

	posix_set_osversioninfoa_dwosversioninfosize (a_osversioninfoa: POINTER; dwOSVersionInfoSize: INTEGER) is
		require
			have_struct_pointer: a_osversioninfoa /= default_pointer
		external "C"
		end


feature -- Struct INPUT_RECORD

	posix_input_record_size: INTEGER is
		external "C"
		end

	posix_input_record_eventtype(input_record: POINTER): INTEGER is
		external "C"
		end


feature -- constants for dwCreationFlags of CreateProcess

	CREATE_DEFAULT_ERROR_MODE: INTEGER is
		external "C"
		alias "const_create_default_error_mode"
		end

	CREATE_NEW_CONSOLE: INTEGER is
		external "C"
		alias "const_create_new_console"
		end

	CREATE_NEW_PROCESS_GROUP: INTEGER is
		external "C"
		alias "const_create_new_process_group"
		end

	CREATE_SUSPENDED: INTEGER is
		external "C"
		alias "const_create_suspended"
		end

	DETACHED_PROCESS: INTEGER is
		external "C"
		alias "const_detached_process"
		end


feature -- C binding WaitForSingleObject return values

	WAIT_FAILED: INTEGER is -1
			-- WaitForSingleObject failed; GetLastError has the error code.

	WAIT_ABANDONED: INTEGER is 128
			-- The specified object is a mutex object that was not
			-- released by the thread that owned the mutex object before
			-- the owning thread terminated; ownership of the mutex
			-- object is granted to the calling thread, and the mutex is
			-- set to nonsignaled.

	WAIT_OBJECT_0: INTEGER is 0
			-- The state of the specified object is signaled

	WAIT_TIMEOUT: INTEGER is 258
			-- The time-out interval elapsed, and the object's state is
			-- nonsignaled


feature -- C binding STARTUPINFO create window constants

	STARTF_USESHOWWINDOW: INTEGER is
		external "C"
		alias "const_startf_useshowwindow"
		end

	STARTF_USEPOSITION: INTEGER is
		external "C"
		alias "const_startf_useposition"
		end

	STARTF_USESIZE: INTEGER is
		external "C"
		alias "const_startf_usesize"
		end

	STARTF_USECOUNTCHARS: INTEGER is
		external "C"
		alias "const_startf_usecountchars"
		end

	STARTF_USEFILLATTRIBUTE: INTEGER is
		external "C"
		alias "const_startf_usefillattribute"
		end

	STARTF_FORCEONFEEDBACK: INTEGER is
		external "C"
		alias "const_startf_forceonfeedback"
		end

	STARTF_FORCEOFFFEEDBACK: INTEGER is
		external "C"
		alias "const_startf_forceofffeedback"
		end

	STARTF_USESTDHANDLES: INTEGER is
		external "C"
		alias "const_startf_usestdhandles"
		end


feature -- C binding for GetStdHandle parameter

	STD_INPUT_HANDLE: INTEGER is
		external "C"
		alias "const_std_input_handle"
		end

	STD_OUTPUT_HANDLE: INTEGER is
		external "C"
		alias "const_std_output_handle"
		end

	STD_ERROR_HANDLE: INTEGER is
		external "C"
		alias "const_std_error_handle"
		end


feature -- C binding constants for dwDesiredAccess of CreateFile

	GENERIC_READ: INTEGER is
		external "C"
		alias "const_generic_read"
		end

	GENERIC_WRITE: INTEGER is
		external "C"
		alias "const_generic_write"
		end


feature -- C binding constants for dwShareMode of CreateFile

	FILE_SHARE_DELETE: INTEGER is
		external "C"
		alias "const_file_share_delete"
		end

	FILE_SHARE_READ: INTEGER is
		external "C"
		alias "const_file_share_read"
		end

	FILE_SHARE_WRITE: INTEGER is
		external "C"
		alias "const_file_share_write"
		end


feature -- C binding constants for dwCreationDistribution of CreateFile

	CREATE_NEW: INTEGER is
		external "C"
		alias "const_create_new"
		end

	CREATE_ALWAYS: INTEGER is
		external "C"
		alias "const_create_always"
		end

	OPEN_EXISTING: INTEGER is
		external "C"
		alias "const_open_existing"
		end

	OPEN_ALWAYS: INTEGER is
		external "C"
		alias "const_open_always"
		end

	TRUNCATE_EXISTING: INTEGER is
		external "C"
		alias "const_truncate_existing"
		end


feature -- C binding constants for dwFlagsAndAttributes of CreateFile

	FILE_ATTRIBUTE_ARCHIVE: INTEGER is
		external "C"
		alias "const_file_attribute_archive"
		end

	FILE_ATTRIBUTE_COMPRESSED: INTEGER is
		external "C"
		alias "const_file_attribute_compressed"
		end

	FILE_ATTRIBUTE_DIRECTORY: INTEGER is
		external "C"
		alias "const_file_attribute_directory"
		end

	FILE_ATTRIBUTE_HIDDEN	: INTEGER is
		external "C"
		alias "const_file_attribute_hidden"
		end

	FILE_ATTRIBUTE_NORMAL	: INTEGER is
		external "C"
		alias "const_file_attribute_normal"
		end

	FILE_ATTRIBUTE_OFFLINE	: INTEGER is
		external "C"
		alias "const_file_attribute_offline"
		end

	FILE_ATTRIBUTE_READONLY	: INTEGER is
		external "C"
		alias "const_file_attribute_readonly"
		end

	FILE_ATTRIBUTE_SYSTEM	: INTEGER is
		external "C"
		alias "const_file_attribute_system"
		end

	FILE_ATTRIBUTE_TEMPORARY	: INTEGER is
		external "C"
		alias "const_file_attribute_temporary"
		end

	FILE_FLAG_WRITE_THROUGH: INTEGER is
		external "C"
		alias "const_file_flag_write_through"
		end

	FILE_FLAG_OVERLAPPED: INTEGER is
		external "C"
		alias "const_file_flag_overlapped"
		end

	FILE_FLAG_NO_BUFFERING: INTEGER is
		external "C"
		alias "const_file_flag_no_buffering"
		end

	FILE_FLAG_RANDOM_ACCESS: INTEGER is
		external "C"
		alias "const_file_flag_random_access"
		end

	FILE_FLAG_SEQUENTIAL_SCAN: INTEGER is
		external "C"
		alias "const_file_flag_sequential_scan"
		end

	FILE_FLAG_DELETE_ON_CLOSE: INTEGER is
		external "C"
		alias "const_file_flag_delete_on_close"
		end

	FILE_FLAG_BACKUP_SEMANTICS: INTEGER is
		external "C"
		alias "const_file_flag_backup_semantics"
		end

	FILE_FLAG_POSIX_SEMANTICS: INTEGER is
		external "C"
		alias "const_file_flag_posix_semantics"
		end


feature -- C binding for members of BY_HANDLE_FILE_INFORMATION

	posix_by_handle_file_information_size: INTEGER is
		external "C"
		end

	posix_by_handle_file_information_dwfileattributes (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_by_handle_file_information_ftcreationtime (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_by_handle_file_information_ftlastaccesstime (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_by_handle_file_information_ftlastwritetime (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_by_handle_file_information_dwvolumeserialnumber (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_by_handle_file_information_nfilesizehigh (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_by_handle_file_information_nfilesizelow (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_by_handle_file_information_nnumberoflinks (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_by_handle_file_information_nfileindexhigh (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end

	posix_by_handle_file_information_nfileindexlow (a_BY_HANDLE_FILE_INFORMATION: POINTER): INTEGER is
		external "C"
		end


feature -- Windows pipe functions

	posix_createpipe (hReadPipe, hWritePipe, lpPipeAttributes: POINTER; nSize: INTEGER): BOOLEAN is
			-- Create an anonymous pipe, and returns handles to the read and
			-- write ends of the pipe.
		external "C"
		ensure
			-- If the function succeeds, the return value is nonzero.
		end

	posix_getnamedpipehandlestate (hNamedPipe: INTEGER; lpState, lpCurInstances, lpMaxCollectionCount, lpCollectionDataTimeout, lpUserName: POINTER; nMaxUserNameSize: INTEGER): BOOLEAN is
			-- Retrieve information about `hNamedPipe'.
		external "C"
		end

	posix_peeknamedpipe (hNamedPipe: INTEGER; lpBuffer: POINTER; nBufferSize: INTEGER; lpBytesRead, lpTotalBytesAvail, lpBytesLeftThisMessage: POINTER): BOOLEAN is
			-- Copy data from a named or anonymous pipe into a buffer
			-- without removing it from the pipe.
		external "C"
		end

	posix_setnamedpipehandlestate (hNamedPipe: INTEGER; lpMode, lpMaxCollectionCount, lpCollectionDataTimeout: POINTER): BOOLEAN is
			-- Set the read mode and the blocking mode of `hNamedPipe'.
		external "C"
		end


feature -- C binding for GetFileType constants

	FILE_TYPE_UNKNOWN: INTEGER is
		external "C"
		alias "const_file_type_unknown"
		end

	FILE_TYPE_DISK: INTEGER is
		external "C"
		alias "const_file_type_disk"
		end

	FILE_TYPE_CHAR: INTEGER is
		external "C"
		alias "const_file_type_char"
		end

	FILE_TYPE_PIPE: INTEGER is
		external "C"
		alias "const_file_type_pipe"
		end


feature -- C binding for the event types constants

	EVENTLOG_SUCCESS: INTEGER is
		external "C"
		alias "const_eventlog_success"
		end

	EVENTLOG_ERROR_TYPE: INTEGER is
		external "C"
		alias "const_eventlog_error_type"
		end

	EVENTLOG_WARNING_TYPE: INTEGER is
		external "C"
		alias "const_eventlog_warning_type"
		end

	EVENTLOG_INFORMATION_TYPE: INTEGER is
		external "C"
		alias "const_eventlog_information_type"
		end

	EVENTLOG_AUDIT_SUCCESS: INTEGER is
		external "C"
		alias "const_eventlog_audit_success"
		end

	EVENTLOG_AUDIT_FAILURE: INTEGER is
		external "C"
		alias "const_eventlog_audit_failure"
		end


feature -- C binding for file view protection constants

	PAGE_READONLY: INTEGER is
			-- Gives readonly access to the committed region of pages.
		external "C"
		alias "const_page_readonly"
		end

	PAGE_READWRITE: INTEGER is
			-- Gives read/write access to the committed region of pages.
		external "C"
		alias "const_page_readwrite"
		end

	PAGE_WRITECOPY: INTEGER is
			-- Gives copy-on-write access to the committed region of pages.
		external "C"
		alias "const_page_writecopy"
		end


feature -- Type of access to the file mapping object

	FILE_MAP_WRITE: INTEGER is
			-- Read-and-write access.
		external "C"
		alias "const_file_map_write"
		end

	FILE_MAP_READ: INTEGER is
			-- Read-only access.
		external "C"
		alias "const_file_map_read"
		end

	FILE_MAP_ALL_ACCESS: INTEGER is
			-- Same as `FILE_MAP_WRITE'.
		external "C"
		alias "const_file_map_all_access"
		end

	FILE_MAP_COPY: INTEGER is
			-- Copy on write access.
		external "C"
		alias "const_file_map_copy"
		end


feature -- C binding for constants

	VER_PLATFORM_WIN32s: INTEGER is
		external "C"
		alias "const_ver_platform_win32s"
		end

	VER_PLATFORM_WIN32_WINDOWS: INTEGER is
		external "C"
		alias "const_ver_platform_win32_windows"
		end

	VER_PLATFORM_WIN32_NT: INTEGER is
		external "C"
		alias "const_ver_platform_win32_nt"
		end


feature -- INPUT_RECORD.EventType constants

	KEY_EVENT: INTEGER is 1

	FOCUS_EVENT: INTEGER is 16


end
