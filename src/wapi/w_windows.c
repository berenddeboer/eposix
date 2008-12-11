#include "w_windows.h"

/* win32 support */

/* following function idea thanks to the Apache team */

/* Number of 100 nano=seconds between the beginning of the Windows epoch
 * (Jan. 1, 1601) and the Unix epoch (Jan. 1, 1970)
 */
#define POSIX_DELTA_EPOCH   116444736000000000

time_t FileTimeToUnixTime(FILETIME input)
{
  LONGLONG t;
  if ((input.dwHighDateTime == 0) && (input.dwLowDateTime == 0))
    { t = 0; }
  else
  {
    /* Convert FILETIME one 64 bit number so we can work with it. */
    t = input.dwHighDateTime;
    t = t << 32;
    t |= input.dwLowDateTime;
    t -= POSIX_DELTA_EPOCH;  /* Convert from Windows epoch to Unix epoch */
    t /= 10000000;    /* Convert from 100 nano-sec periods to seconds. */
  }
  return t;
}


/* error handling */

EIF_INTEGER posix_getlasterror()
{
  return GetLastError();
}

EIF_POINTER posix_geterrormessage(EIF_INTEGER error_number)
{
  LPVOID lpvMessageBuffer;

  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM,
                NULL, error_number,
                MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                (LPTSTR)&lpvMessageBuffer, 0, NULL);
  return (lpvMessageBuffer);
}


/* find functions */

EIF_POINTER posix_findfirstfile(EIF_POINTER filename, EIF_POINTER find_file_data)
{
  return ( FindFirstFile(filename, (void *) find_file_data));
}

EIF_BOOLEAN posix_findnextfile(EIF_POINTER handle, EIF_POINTER find_file_data)
{
  return ( FindNextFile (handle, (void *) find_file_data));
}

EIF_BOOLEAN posix_findclose(EIF_POINTER handle)
{
  return (FindClose (handle));
}


/* directories */

EIF_INTEGER posix_gettemppath (EIF_INTEGER len, EIF_POINTER buf)
{
  return GetTempPath (len, buf);
}


/* basic handle stuff */

EIF_BOOLEAN posix_closehandle (EIF_INTEGER hObject)
{
  return CloseHandle( (HANDLE) hObject);
}

EIF_BOOLEAN posix_duplicatehandle (EIF_INTEGER hSourceProcessHandle, EIF_INTEGER hSourceHandle, EIF_INTEGER hTargetProcessHandle, EIF_POINTER lpTargetHandle, EIF_INTEGER dwDesiredAccess, EIF_BOOLEAN bInheritHandle, EIF_INTEGER dwOptions)
{
  return DuplicateHandle( (HANDLE) hSourceProcessHandle, (HANDLE) hSourceHandle, (HANDLE) hTargetProcessHandle, (void *) lpTargetHandle, dwDesiredAccess, bInheritHandle, dwOptions);
}

EIF_INTEGER posix_waitforsingleobject(EIF_INTEGER hHandle, EIF_INTEGER dwMilliseconds)
{
  return WaitForSingleObject((HANDLE) hHandle, dwMilliseconds);
}


/* file descriptors handles */

EIF_INTEGER posix_createfile(EIF_POINTER lpFileName, EIF_INTEGER dwDesiredAccess, EIF_INTEGER dwShareMode, EIF_POINTER lpSecurityAttributes, EIF_INTEGER dwCreationDistribution, EIF_INTEGER dwFlagsAndAttributes, EIF_INTEGER hTemplateFile)
{
  return (EIF_INTEGER) CreateFile(lpFileName, dwDesiredAccess, dwShareMode, (void *) lpSecurityAttributes, dwCreationDistribution, dwFlagsAndAttributes, (HANDLE) hTemplateFile);
}

EIF_BOOLEAN posix_getfileinformationbyhandle(EIF_INTEGER hFile, EIF_POINTER lpFileInformation)
{
  return GetFileInformationByHandle((HANDLE) hFile, (void *) lpFileInformation);
}

EIF_INTEGER posix_getfiletype(EIF_INTEGER hFile)
{
  return GetFileType((HANDLE) hFile);
}

EIF_INTEGER posix_getstdhandle (EIF_INTEGER nStdHandle)
{
  return (EIF_INTEGER) GetStdHandle (nStdHandle);
}

EIF_BOOLEAN posix_readfile(EIF_INTEGER hFile, EIF_POINTER lpBuffer, EIF_INTEGER nNumberOfBytesToRead, EIF_POINTER lpNumberOfBytesRead, EIF_POINTER lpOverlapped)
{
  return ReadFile((HANDLE) hFile, (LPVOID) lpBuffer, (DWORD) nNumberOfBytesToRead, (LPDWORD) lpNumberOfBytesRead, (LPOVERLAPPED) lpOverlapped);
}

EIF_INTEGER posix_setfilepointer (EIF_INTEGER hFile, EIF_INTEGER lDistanceToMove, EIF_POINTER lpDistanceToMoveHigh, EIF_INTEGER dwMoveMethod)
{
  return SetFilePointer((HANDLE) hFile, lDistanceToMove, (void *) lpDistanceToMoveHigh, dwMoveMethod);
}

EIF_BOOLEAN posix_setstdhandle (EIF_INTEGER nStdHandle, EIF_INTEGER hHandle)
{
  return SetStdHandle(nStdHandle, (HANDLE) hHandle);
}

EIF_BOOLEAN posix_writefile(EIF_INTEGER hFile, EIF_POINTER lpBuffer, EIF_INTEGER nNumberOfBytesToWrite, EIF_POINTER lpNumberOfBytesWritten, EIF_POINTER lpOverlapped)
{
  return WriteFile((HANDLE) hFile, (LPCVOID) lpBuffer, (DWORD) nNumberOfBytesToWrite, (LPDWORD) lpNumberOfBytesWritten, (LPOVERLAPPED) lpOverlapped);

}


/* pipes */

EIF_BOOLEAN posix_createpipe(EIF_INTEGER hReadPipe, EIF_INTEGER hWritePipe, EIF_POINTER lpPipeAttributes, EIF_INTEGER nSize)
{
  return CreatePipe((void *) hReadPipe, (void *) hWritePipe, (void *) lpPipeAttributes, nSize);
}

EIF_BOOLEAN posix_getnamedpipehandlestate (EIF_INTEGER hNamedPipe, EIF_POINTER lpState, EIF_POINTER lpCurInstances, EIF_POINTER lpMaxCollectionCount, EIF_POINTER lpCollectionDataTimeout, EIF_POINTER lpUserName, EIF_INTEGER nMaxUserNameSize)
{
  return GetNamedPipeHandleState((HANDLE) hNamedPipe, (LPDWORD) lpState, (LPDWORD) lpCurInstances, (LPDWORD) lpMaxCollectionCount, (LPDWORD) lpCollectionDataTimeout, (LPTSTR) lpUserName, (DWORD) nMaxUserNameSize);
}

EIF_BOOLEAN posix_peeknamedpipe (EIF_INTEGER hNamedPipe, EIF_POINTER lpBuffer, EIF_INTEGER nBufferSize, EIF_POINTER lpBytesRead, EIF_POINTER lpTotalBytesAvail, EIF_POINTER lpBytesLeftThisMessage)
{
  return PeekNamedPipe ((HANDLE) hNamedPipe, (LPVOID) lpBuffer, (DWORD) nBufferSize, (LPDWORD) lpBytesRead, (LPDWORD) lpTotalBytesAvail, (LPDWORD) lpBytesLeftThisMessage);
}

EIF_BOOLEAN posix_setnamedpipehandlestate (EIF_INTEGER hNamedPipe, EIF_POINTER lpMode, EIF_POINTER lpMaxCollectionCount, EIF_POINTER lpCollectionDataTimeout)
{
  return SetNamedPipeHandleState((HANDLE) hNamedPipe, (LPDWORD) lpMode, (LPDWORD) lpMaxCollectionCount, (LPDWORD) lpCollectionDataTimeout);
}


/* shared memory */

EIF_INTEGER posix_createfilemapping (EIF_INTEGER hFile, EIF_POINTER lpAttributes, EIF_INTEGER flProtect, EIF_INTEGER dwMaximumSizeHigh, EIF_INTEGER dwMaximumSizeLow, EIF_POINTER lpName)
{
  return ((EIF_INTEGER) CreateFileMapping ((HANDLE) hFile, (LPSECURITY_ATTRIBUTES) lpAttributes, flProtect, dwMaximumSizeHigh, dwMaximumSizeLow, lpName));
}

EIF_INTEGER posix_openfilemapping (EIF_INTEGER dwDesiredAccess, EIF_BOOLEAN bInheritHandle, EIF_POINTER lpName)
{
  return ((EIF_INTEGER) OpenFileMapping (dwDesiredAccess, bInheritHandle, lpName));

}

EIF_POINTER posix_mapviewoffile(EIF_INTEGER hFileMappingObject, EIF_INTEGER dwDesiredAccess, EIF_INTEGER dwFileOffsetHigh, EIF_INTEGER dwFileOffsetLow, EIF_INTEGER dwNumberOfBytesToMap)
{
  return MapViewOfFile((HANDLE) hFileMappingObject, dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap);
}

EIF_POINTER posix_mapviewoffileex(EIF_INTEGER hFileMappingObject, EIF_INTEGER dwDesiredAccess, EIF_INTEGER dwFileOffsetHigh, EIF_INTEGER dwFileOffsetLow, EIF_INTEGER dwNumberOfBytesToMap, EIF_POINTER lpBaseAddress)
{
  return MapViewOfFileEx((HANDLE) hFileMappingObject, dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap, lpBaseAddress);
}

EIF_BOOLEAN posix_unmapviewoffile (EIF_POINTER lpBaseAddress)
{
  return UnmapViewOfFile(lpBaseAddress);
}


/* semaphores */

EIF_INTEGER posix_createsemaphore(EIF_POINTER lpSemaphoreAttributes, EIF_INTEGER lInitialCount, EIF_INTEGER lMaximumCount, EIF_POINTER lpName)
{
  return (EIF_INTEGER) CreateSemaphore(lpSemaphoreAttributes, lInitialCount, lMaximumCount, lpName);
}

EIF_INTEGER posix_opensemaphore (EIF_INTEGER dwDesiredAccess, EIF_BOOLEAN bInheritHandle, EIF_POINTER lpName)
{
  return (EIF_INTEGER) OpenSemaphore(dwDesiredAccess, bInheritHandle, lpName);
}

EIF_BOOLEAN posix_releasesemaphore (EIF_INTEGER hSemaphore, EIF_INTEGER lReleaseCount, EIF_POINTER lpPreviousCount)
{
  return ReleaseSemaphore((HANDLE) hSemaphore, lReleaseCount, lpPreviousCount);
}


/* process */

EIF_BOOLEAN posix_createprocess(EIF_POINTER lpApplicationName, EIF_POINTER lpCommandLine, EIF_POINTER lpProcessAttributes, EIF_POINTER lpThreadAttributes, EIF_BOOLEAN bInheritHandles, EIF_INTEGER dwCreationFlags, EIF_POINTER lpEnvironment, EIF_POINTER lpCurrentDirectory, EIF_POINTER lpStartupInfo, EIF_POINTER lpProcessInformation)
{
  return CreateProcess(lpApplicationName, lpCommandLine, (void *) lpProcessAttributes, (void *) lpThreadAttributes, bInheritHandles, dwCreationFlags, lpEnvironment, lpCurrentDirectory, (void *) lpStartupInfo, (void *) lpProcessInformation);
}

EIF_INTEGER posix_getcurrentprocess()
{
  return (EIF_INTEGER) GetCurrentProcess();
}

EIF_INTEGER posix_getcurrentprocessid()
{
  return GetCurrentProcessId();
}

EIF_BOOLEAN posix_getexitcodeprocess(EIF_INTEGER hProcess, EIF_POINTER lpExitCode)
{
  return GetExitCodeProcess ( (HANDLE) hProcess, (void *) lpExitCode);
}

EIF_BOOLEAN posix_terminateprocess(EIF_INTEGER hProcess, EIF_INTEGER uExitCode)
{
  return TerminateProcess((void *)hProcess, uExitCode);
}


/* environment variables */

EIF_BOOLEAN posix_freeenvironmentstrings(EIF_POINTER lpszEnvironmentBlock)
{
  return FreeEnvironmentStrings((LPTSTR) lpszEnvironmentBlock);
}

EIF_POINTER posix_getenvironmentstrings()
{
  return GetEnvironmentStrings();
}

EIF_INTEGER posix_getenvironmentvariable(EIF_POINTER lpName, EIF_POINTER lpBuffer, EIF_INTEGER nSize)
{
  return GetEnvironmentVariable((LPCTSTR) lpName, (LPTSTR) lpBuffer, (DWORD) nSize);
}

EIF_BOOLEAN posix_setenvironmentvariable(EIF_POINTER lpName, EIF_POINTER lpValue)
{
  return SetEnvironmentVariable((LPCTSTR) lpName, (LPCTSTR) lpValue);
}


/* NT event logging */

EIF_INTEGER posix_registereventsource(EIF_POINTER lpUNCServerName, EIF_POINTER lpSourceName)
{
  return ((EIF_INTEGER) RegisterEventSource(lpUNCServerName, lpSourceName));
}

EIF_BOOLEAN posix_reportevent(EIF_INTEGER hEventLog, EIF_INTEGER wType, EIF_INTEGER wCategory, EIF_INTEGER dwEventID, EIF_POINTER lpUserSid, EIF_INTEGER wNumStrings, EIF_INTEGER dwDataSize, EIF_POINTER lpStrings, EIF_POINTER lpRawData)
{
  return ReportEventA((HANDLE) hEventLog, (WORD) wType, (WORD) wCategory, (DWORD) dwEventID, (PSID) lpUserSid, (WORD) wNumStrings, (DWORD) dwDataSize, (LPCTSTR *) lpStrings, (LPVOID) lpRawData);
}

EIF_BOOLEAN posix_deregistereventsource(EIF_INTEGER hEventLog)
{
  return DeregisterEventSource((HANDLE) hEventLog);
}


/* console functions */

EIF_BOOLEAN posix_getnumberofconsoleinputevents(EIF_INTEGER hConsoleInput, EIF_POINTER lpcNumberOfEvents)
{
  return GetNumberOfConsoleInputEvents((HANDLE) hConsoleInput, (LPDWORD) lpcNumberOfEvents);
}

EIF_BOOLEAN posix_peekconsoleinput(EIF_INTEGER hConsoleInput, EIF_POINTER lpBuffer, EIF_INTEGER nLength, EIF_POINTER lpNumberOfEventsRead)
{
  return PeekConsoleInput((HANDLE) hConsoleInput, (PINPUT_RECORD) lpBuffer, (DWORD) nLength, (LPDWORD) lpNumberOfEventsRead);
}


/* security */

EIF_BOOLEAN posix_getusername (EIF_POINTER lpBuffer, EIF_POINTER nSize)
{
  return GetUserName((LPTSTR) lpBuffer, (LPDWORD) nSize);
}

EIF_BOOLEAN posix_initializesecuritydescriptor (EIF_POINTER pSecurityDescriptor,EIF_INTEGER dwRevision)
{
  return InitializeSecurityDescriptor((PSECURITY_DESCRIPTOR) pSecurityDescriptor, (DWORD) dwRevision);
}

EIF_BOOLEAN posix_setsecuritydescriptordacl (EIF_POINTER pSecurityDescriptor, EIF_BOOLEAN bDaclPresent, EIF_POINTER pDacl, EIF_BOOLEAN bDaclDefaulted)
{
  return SetSecurityDescriptorDacl((PSECURITY_DESCRIPTOR) pSecurityDescriptor, bDaclPresent, (PACL) pDacl, bDaclDefaulted);
}


/* High resolution timing */

EIF_BOOLEAN posix_queryperformancefrequency (EIF_POINTER lpFrequency)
{
  return QueryPerformanceFrequency ((LARGE_INTEGER *) lpFrequency);
}

EIF_BOOLEAN posix_queryperformancecounter (EIF_POINTER lpPerformanceCount)
{
  return QueryPerformanceCounter ((LARGE_INTEGER *) lpPerformanceCount);
}


/* various */

void posix_sleep(EIF_INTEGER dwMilliseconds)
{
  Sleep(dwMilliseconds);
}

EIF_BOOLEAN posix_getversionex(EIF_POINTER lpVersionInformation)
{
  return GetVersionEx((LPOSVERSIONINFO) lpVersionInformation);
}

/* struct WIN32_FIND_DATA  */

EIF_INTEGER posix_win32_find_data_size()
{
  return (sizeof (WIN32_FIND_DATA));
}

EIF_POINTER posix_win32_find_data_filename (PWIN32_FIND_DATAA find_data)
{
  return (find_data->cFileName);
}

EIF_INTEGER posix_win32_find_data_ftcreationtime (PWIN32_FIND_DATAA find_data)
{
  return FileTimeToUnixTime(find_data->ftCreationTime);
}

EIF_INTEGER posix_win32_find_data_ftlastaccesstime (PWIN32_FIND_DATAA find_data)
{
  return FileTimeToUnixTime(find_data->ftLastAccessTime);
}

EIF_INTEGER posix_win32_find_data_ftlastwritetime (PWIN32_FIND_DATAA find_data)
{
  return FileTimeToUnixTime(find_data->ftLastWriteTime);
}



/* struct SECURITY_ATTRIBUTES */

EIF_INTEGER posix_security_attributes_size()
{
   return (sizeof (struct _SECURITY_ATTRIBUTES));
}

EIF_INTEGER posix_security_attributes_nlength(struct _SECURITY_ATTRIBUTES *p)
{
  return p->nLength;
}

EIF_POINTER posix_security_attributes_lpsecuritydescriptor(struct _SECURITY_ATTRIBUTES *p)
{
  return p->lpSecurityDescriptor;
}

EIF_BOOLEAN posix_security_attributes_binherithandle(struct _SECURITY_ATTRIBUTES *p)
{
  return p->bInheritHandle;
}


void posix_set_security_attributes_nlength(struct _SECURITY_ATTRIBUTES *p, EIF_INTEGER nLength)
{
  p->nLength = nLength;
}

void posix_set_security_attributes_lpsecuritydescriptor(struct _SECURITY_ATTRIBUTES *p, EIF_POINTER lpSecurityDescriptor)
{
  p->lpSecurityDescriptor = lpSecurityDescriptor;
}

void posix_set_security_attributes_binherithandle(struct _SECURITY_ATTRIBUTES *p, EIF_BOOLEAN bInheritHandle)
{
  p->bInheritHandle = bInheritHandle;
}


/* struct SECURITY_DESCRIPTOR */

EIF_INTEGER posix_security_descriptor_size()
{
   return (sizeof (struct _SECURITY_DESCRIPTOR));
}


/* struct STARTUPINFOA */

EIF_INTEGER posix_startupinfo_size()
{
   return (sizeof (struct _STARTUPINFOA));
}

EIF_INTEGER posix_startupinfo_cb(struct _STARTUPINFOA *p)
{
  return p->cb;
}

EIF_POINTER posix_startupinfo_lpreserved(struct _STARTUPINFOA *p)
{
  return p->lpReserved;
}

EIF_POINTER posix_startupinfo_lpdesktop(struct _STARTUPINFOA *p)
{
  return p->lpDesktop;
}

EIF_POINTER posix_startupinfo_lptitle(struct _STARTUPINFOA *p)
{
  return p->lpTitle;
}

EIF_INTEGER posix_startupinfo_dwx(struct _STARTUPINFOA *p)
{
  return p->dwX;
}

EIF_INTEGER posix_startupinfo_dwy(struct _STARTUPINFOA *p)
{
  return p->dwY;
}

EIF_INTEGER posix_startupinfo_dwxsize(struct _STARTUPINFOA *p)
{
  return p->dwXSize;
}

EIF_INTEGER posix_startupinfo_dwysize(struct _STARTUPINFOA *p)
{
  return p->dwYSize;
}

EIF_INTEGER posix_startupinfo_dwxcountchars(struct _STARTUPINFOA *p)
{
  return p->dwXCountChars;
}

EIF_INTEGER posix_startupinfo_dwycountchars(struct _STARTUPINFOA *p)
{
  return p->dwYCountChars;
}

EIF_INTEGER posix_startupinfo_dwfillattribute(struct _STARTUPINFOA *p)
{
  return p->dwFillAttribute;
}

EIF_INTEGER posix_startupinfo_dwflags(struct _STARTUPINFOA *p)
{
  return p->dwFlags;
}

EIF_INTEGER posix_startupinfo_wshowwindow(struct _STARTUPINFOA *p)
{
  return p->wShowWindow;
}

EIF_INTEGER posix_startupinfo_cbreserved2(struct _STARTUPINFOA *p)
{
  return p->cbReserved2;
}

EIF_POINTER posix_startupinfo_lpreserved2(struct _STARTUPINFOA *p)
{
  return p->lpReserved2;
}

EIF_INTEGER posix_startupinfo_hstdinput(struct _STARTUPINFOA *p)
{
  return (EIF_INTEGER) p->hStdInput;
}

EIF_INTEGER posix_startupinfo_hstdoutput(struct _STARTUPINFOA *p)
{
  return (EIF_INTEGER) p->hStdOutput;
}

EIF_INTEGER posix_startupinfo_hstderror(struct _STARTUPINFOA *p)
{
  return (EIF_INTEGER) p->hStdError;
}


void posix_set_startupinfo_cb(struct _STARTUPINFOA *p, EIF_INTEGER cb)
{
  p->cb = cb;
}

void posix_set_startupinfo_lpreserved(struct _STARTUPINFOA *p, EIF_POINTER lpReserved)
{
  p->lpReserved = lpReserved;
}

void posix_set_startupinfo_lpdesktop(struct _STARTUPINFOA *p, EIF_POINTER lpDesktop)
{
  p->lpDesktop = lpDesktop;
}

void posix_set_startupinfo_lptitle(struct _STARTUPINFOA *p, EIF_POINTER lpTitle)
{
  p->lpTitle = lpTitle;
}

void posix_set_startupinfo_dwx(struct _STARTUPINFOA *p, EIF_INTEGER dwX)
{
  p->dwX = dwX;
}

void posix_set_startupinfo_dwy(struct _STARTUPINFOA *p, EIF_INTEGER dwY)
{
  p->dwY = dwY;
}

void posix_set_startupinfo_dwxsize(struct _STARTUPINFOA *p, EIF_INTEGER dwXSize)
{
  p->dwXSize = dwXSize;
}

void posix_set_startupinfo_dwysize(struct _STARTUPINFOA *p, EIF_INTEGER dwYSize)
{
  p->dwYSize = dwYSize;
}

void posix_set_startupinfo_dwxcountchars(struct _STARTUPINFOA *p, EIF_INTEGER dwXCountChars)
{
  p->dwXCountChars = dwXCountChars;
}

void posix_set_startupinfo_dwycountchars(struct _STARTUPINFOA *p, EIF_INTEGER dwYCountChars)
{
  p->dwYCountChars = dwYCountChars;
}

void posix_set_startupinfo_dwfillattribute(struct _STARTUPINFOA *p, EIF_INTEGER dwFillAttribute)
{
  p->dwFillAttribute = dwFillAttribute;
}

void posix_set_startupinfo_dwflags(struct _STARTUPINFOA *p, EIF_INTEGER dwFlags)
{
  p->dwFlags = dwFlags;
}

void posix_set_startupinfo_wshowwindow(struct _STARTUPINFOA *p, EIF_INTEGER wShowWindow)
{
  p->wShowWindow = wShowWindow;
}

void posix_set_startupinfo_cbreserved2(struct _STARTUPINFOA *p, EIF_INTEGER cbReserved2)
{
  p->cbReserved2 = cbReserved2;
}

void posix_set_startupinfo_lpreserved2(struct _STARTUPINFOA *p, EIF_POINTER lpReserved2)
{
  p->lpReserved2 = lpReserved2;
}

void posix_set_startupinfo_hstdinput(struct _STARTUPINFOA *p, EIF_INTEGER hStdInput)
{
  p->hStdInput = (HANDLE) hStdInput;
}

void posix_set_startupinfo_hstdoutput(struct _STARTUPINFOA *p, EIF_INTEGER hStdOutput)
{
  p->hStdOutput = (HANDLE) hStdOutput;
}

void posix_set_startupinfo_hstderror(struct _STARTUPINFOA *p, EIF_INTEGER hStdError)
{
  p->hStdError = (HANDLE) hStdError;
}


/* struct _PROCESS_INFORMATION */

EIF_INTEGER posix_process_information_size()
{
   return (sizeof (struct _PROCESS_INFORMATION));
}

EIF_INTEGER posix_process_information_hprocess(struct _PROCESS_INFORMATION *p)
{
  return (EIF_INTEGER) p->hProcess;
}

EIF_INTEGER posix_process_information_hthread(struct _PROCESS_INFORMATION *p)
{
  return (EIF_INTEGER) p->hThread;
}

EIF_INTEGER posix_process_information_dwprocessid(struct _PROCESS_INFORMATION *p)
{
  return p->dwProcessId;
}

EIF_INTEGER posix_process_information_dwthreadid(struct _PROCESS_INFORMATION *p)
{
  return p->dwThreadId;
}


/* struct BY_HANDLE_FILE_INFORMATION */

EIF_INTEGER posix_by_handle_file_information_size()
{
   return (sizeof (struct _BY_HANDLE_FILE_INFORMATION));
}

EIF_INTEGER posix_by_handle_file_information_dwfileattributes(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return p->dwFileAttributes;
}

EIF_INTEGER posix_by_handle_file_information_ftcreationtime(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return FileTimeToUnixTime(p->ftCreationTime);
}

EIF_INTEGER posix_by_handle_file_information_ftlastaccesstime(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return FileTimeToUnixTime(p->ftLastAccessTime);
}

EIF_INTEGER posix_by_handle_file_information_ftlastwritetime(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return FileTimeToUnixTime(p->ftLastWriteTime);
}

EIF_INTEGER posix_by_handle_file_information_dwvolumeserialnumber(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return p->dwVolumeSerialNumber;
}

EIF_INTEGER posix_by_handle_file_information_nfilesizehigh(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return p->nFileSizeHigh;
}

EIF_INTEGER posix_by_handle_file_information_nfilesizelow(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return p->nFileSizeLow;
}

EIF_INTEGER posix_by_handle_file_information_nnumberoflinks(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return p->nNumberOfLinks;
}

EIF_INTEGER posix_by_handle_file_information_nfileindexhigh(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return p->nFileIndexHigh;
}

EIF_INTEGER posix_by_handle_file_information_nfileindexlow(struct _BY_HANDLE_FILE_INFORMATION *p)
{
  return p->nFileIndexLow;
}

/* struct _OSVERSIONINFOA */

EIF_INTEGER posix_osversioninfoa_size()
{
   return (sizeof (struct _OSVERSIONINFOA));
}

EIF_INTEGER posix_osversioninfoa_dwosversioninfosize(struct _OSVERSIONINFOA *p)
{
  return p->dwOSVersionInfoSize;
}

EIF_INTEGER posix_osversioninfoa_dwmajorversion(struct _OSVERSIONINFOA *p)
{
  return p->dwMajorVersion;
}

EIF_INTEGER posix_osversioninfoa_dwminorversion(struct _OSVERSIONINFOA *p)
{
  return p->dwMinorVersion;
}

EIF_INTEGER posix_osversioninfoa_dwbuildnumber(struct _OSVERSIONINFOA *p)
{
  return p->dwBuildNumber;
}

EIF_INTEGER posix_osversioninfoa_dwplatformid(struct _OSVERSIONINFOA *p)
{
  return p->dwPlatformId;
}

EIF_POINTER posix_osversioninfoa_szcsdversion(struct _OSVERSIONINFOA *p)
{
  return (EIF_POINTER) p->szCSDVersion;
}


void posix_set_osversioninfoa_dwosversioninfosize(struct _OSVERSIONINFOA *p, EIF_INTEGER dwOSVersionInfoSize)
{
  p->dwOSVersionInfoSize = dwOSVersionInfoSize;
}


/* struct INPUT_RECORD */

EIF_INTEGER posix_input_record_size()
{
  return (sizeof (INPUT_RECORD));
}

EIF_INTEGER posix_input_record_eventtype(INPUT_RECORD *p)
{
  return p->EventType;
}


/* constants */

EIF_INTEGER const_duplicate_same_access()
{
  return DUPLICATE_SAME_ACCESS;
}

EIF_INTEGER const_infinite()
{
  return INFINITE;
}

EIF_INTEGER const_invalid_handle_value()
{
  return (EIF_INTEGER) (INVALID_HANDLE_VALUE);
}

EIF_POINTER const_invalid_ptr_handle_value()
{
  return (INVALID_HANDLE_VALUE);
}

EIF_INTEGER const_max_path()
{
  return (MAX_PATH);
}

EIF_INTEGER const_sw_hide()
{
  return (SW_HIDE);
}

EIF_INTEGER const_unlen()
{
  return (UNLEN);
}


/* constants for dwCreationFlags of CreateProcess */

EIF_INTEGER const_create_default_error_mode()
{
  return CREATE_DEFAULT_ERROR_MODE;
}

EIF_INTEGER const_create_new_console()
{
  return CREATE_NEW_CONSOLE;
}

EIF_INTEGER const_create_new_process_group()
{
  return CREATE_NEW_PROCESS_GROUP;
}

EIF_INTEGER const_create_suspended()
{
  return CREATE_SUSPENDED;
}

EIF_INTEGER const_detached_process()
{
  return DETACHED_PROCESS;
}


/* STARTUPINFO.dwFlags */

EIF_INTEGER const_startf_useshowwindow()
{
  return STARTF_USESHOWWINDOW	;
}

EIF_INTEGER const_startf_useposition()
{
  return STARTF_USEPOSITION	;
}

EIF_INTEGER const_startf_usesize()
{
  return STARTF_USESIZE	;
}

EIF_INTEGER const_startf_usecountchars()
{
  return STARTF_USECOUNTCHARS	;
}

EIF_INTEGER const_startf_usefillattribute()
{
  return STARTF_USEFILLATTRIBUTE	;
}

EIF_INTEGER const_startf_forceonfeedback()
{
  return STARTF_FORCEONFEEDBACK	;
}

EIF_INTEGER const_startf_forceofffeedback()
{
  return STARTF_FORCEOFFFEEDBACK	;
}

EIF_INTEGER const_startf_usestdhandles()
{
  return STARTF_USESTDHANDLES;
}


/* GetStdHandle parameter */

EIF_INTEGER const_std_input_handle()
{
  return STD_INPUT_HANDLE;
}

EIF_INTEGER const_std_output_handle()
{
  return STD_OUTPUT_HANDLE;
}

EIF_INTEGER const_std_error_handle()
{
  return STD_ERROR_HANDLE;
}


/* constants for dwDesiredAccess of CreateFile */

EIF_INTEGER const_generic_read	()
{
  return GENERIC_READ	;
}

EIF_INTEGER const_generic_write	()
{
  return GENERIC_WRITE	;
}


/* constants for dwShareMode of CreateFile */

EIF_INTEGER const_file_share_delete	()
{
  return FILE_SHARE_DELETE	;
}

EIF_INTEGER const_file_share_read	()
{
  return FILE_SHARE_READ	;
}

EIF_INTEGER const_file_share_write	()
{
  return FILE_SHARE_WRITE	;
}


/* constants for dwCreationDistribution of CreateFile */

EIF_INTEGER const_create_new	()
{
  return CREATE_NEW	;
}

EIF_INTEGER const_create_always	()
{
  return CREATE_ALWAYS	;
}

EIF_INTEGER const_open_existing	()
{
  return OPEN_EXISTING	;
}

EIF_INTEGER const_open_always	()
{
  return OPEN_ALWAYS	;
}

EIF_INTEGER const_truncate_existing	()
{
  return TRUNCATE_EXISTING	;
}


/* constants for dwFlagsAndAttributes of CreateFile */

EIF_INTEGER const_file_attribute_archive	()
{
  return FILE_ATTRIBUTE_ARCHIVE	;
}

EIF_INTEGER const_file_attribute_compressed	()
{
  return FILE_ATTRIBUTE_COMPRESSED	;
}

EIF_INTEGER const_file_attribute_directory()
{
  return FILE_ATTRIBUTE_DIRECTORY;
}

EIF_INTEGER const_file_attribute_hidden	()
{
  return FILE_ATTRIBUTE_HIDDEN	;
}

EIF_INTEGER const_file_attribute_normal	()
{
  return FILE_ATTRIBUTE_NORMAL	;
}

EIF_INTEGER const_file_attribute_offline	()
{
  return FILE_ATTRIBUTE_OFFLINE	;
}

EIF_INTEGER const_file_attribute_readonly	()
{
  return FILE_ATTRIBUTE_READONLY	;
}

EIF_INTEGER const_file_attribute_system	()
{
  return FILE_ATTRIBUTE_SYSTEM	;
}

EIF_INTEGER const_file_attribute_temporary	()
{
  return FILE_ATTRIBUTE_TEMPORARY	;
}

EIF_INTEGER const_file_flag_write_through()
{
  return FILE_FLAG_WRITE_THROUGH;
}

EIF_INTEGER const_file_flag_overlapped()
{
  return FILE_FLAG_OVERLAPPED;
}

EIF_INTEGER const_file_flag_no_buffering()
{
  return FILE_FLAG_NO_BUFFERING;
}

EIF_INTEGER const_file_flag_random_access()
{
  return FILE_FLAG_RANDOM_ACCESS;
}

EIF_INTEGER const_file_flag_sequential_scan()
{
  return FILE_FLAG_SEQUENTIAL_SCAN;
}

EIF_INTEGER const_file_flag_delete_on_close()
{
  return FILE_FLAG_DELETE_ON_CLOSE;
}

EIF_INTEGER const_file_flag_backup_semantics()
{
  return FILE_FLAG_BACKUP_SEMANTICS;
}

EIF_INTEGER const_file_flag_posix_semantics()
{
  return FILE_FLAG_POSIX_SEMANTICS;
}


/* GetFileType constants */

EIF_INTEGER const_file_type_unknown()
{
  return FILE_TYPE_UNKNOWN;
}

EIF_INTEGER const_file_type_disk()
{
  return FILE_TYPE_DISK;
}

EIF_INTEGER const_file_type_char()
{
  return FILE_TYPE_CHAR;
}

EIF_INTEGER const_file_type_pipe()
{
  return FILE_TYPE_PIPE;
}



/* event type constants */

EIF_INTEGER const_eventlog_success()
{
#ifdef EVENTLOG_SUCCESS
  return EVENTLOG_SUCCESS;
#else
  return 0x0000;
#endif
}

EIF_INTEGER const_eventlog_error_type()
{
  return EVENTLOG_ERROR_TYPE;
}

EIF_INTEGER const_eventlog_warning_type()
{
  return EVENTLOG_WARNING_TYPE;
}

EIF_INTEGER const_eventlog_information_type()
{
  return EVENTLOG_INFORMATION_TYPE;
}

EIF_INTEGER const_eventlog_audit_success()
{
  return EVENTLOG_AUDIT_SUCCESS;
}

EIF_INTEGER const_eventlog_audit_failure()
{
  return EVENTLOG_AUDIT_FAILURE;
}


/* Protection desired for file view */

EIF_INTEGER const_page_readonly()
{
  return PAGE_READONLY;
}

EIF_INTEGER const_page_readwrite()
{
  return PAGE_READWRITE;
}

EIF_INTEGER const_page_writecopy()
{
  return PAGE_WRITECOPY;
}


/* Type of access to the file mapping object */

EIF_INTEGER const_file_map_write()
{
  return FILE_MAP_WRITE;
}

EIF_INTEGER const_file_map_read()
{
  return FILE_MAP_READ;
}

EIF_INTEGER const_file_map_all_access()
{
  return FILE_MAP_ALL_ACCESS;
}

EIF_INTEGER const_file_map_copy()
{
  return FILE_MAP_COPY;
}


/* values for OSVERSIONINFOA.dwPlatformId */

EIF_INTEGER const_ver_platform_win32s()
{
  return VER_PLATFORM_WIN32s;
}

EIF_INTEGER const_ver_platform_win32_windows()
{
  return VER_PLATFORM_WIN32_WINDOWS;
}

EIF_INTEGER const_ver_platform_win32_nt()
{
  return VER_PLATFORM_WIN32_NT;
}


/* pipe state */

EIF_INTEGER const_pipe_nowait()
{
  return PIPE_NOWAIT;
}

EIF_INTEGER const_pipe_wait()
{
  return PIPE_WAIT;
}


/* semaphore access rights */

EIF_INTEGER const_semaphore_all_access()
{
#ifdef SEMAPHORE_ALL_ACCESS
  return SEMAPHORE_ALL_ACCESS;
#else
  return 3;
#endif
}


/* security descriptor */

EIF_INTEGER const_security_descriptor_revision()
{
  return SECURITY_DESCRIPTOR_REVISION;
}
