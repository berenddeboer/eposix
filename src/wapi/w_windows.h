/*

C layer to Windows windows.h

*/


#ifndef _W_WINDOWS_H_
#define _W_WINDOWS_H_

#include <Windows.h>
#include <time.h>
/* We need WinNT.h to get access to SEMAPHORE_ALL_ACCESS */
#ifdef _WINNT_
#include <WinNT.h>
#endif
#include <LMCons.h>
#include "../supportc/eiffel.h"


/* error handling */

EIF_INTEGER posix_getlasterror();
EIF_POINTER posix_geterrormessage(EIF_INTEGER error_number);


/* find functions */

EIF_POINTER posix_findfirstfile(EIF_POINTER filename, EIF_POINTER find_file_data);
EIF_BOOLEAN posix_findnextfile(EIF_POINTER handle, EIF_POINTER find_file_data);
EIF_BOOLEAN posix_findclose(EIF_POINTER handle);


/* directories */

EIF_INTEGER posix_gettemppath (EIF_INTEGER len, EIF_POINTER buf);


/* basic handles stuff */

EIF_BOOLEAN posix_closehandle (EIF_INTEGER hObject);
EIF_BOOLEAN posix_duplicatehandle (EIF_INTEGER hSourceProcessHandle, EIF_INTEGER hSourceHandle, EIF_INTEGER hTargetProcessHandle, EIF_POINTER lpTargetHandle, EIF_INTEGER dwDesiredAccess, EIF_BOOLEAN bInheritHandle, EIF_INTEGER dwOptions);
EIF_INTEGER posix_waitforsingleobject(EIF_INTEGER hHandle, EIF_INTEGER dwMilliseconds);


/* file descriptors handles */

EIF_INTEGER posix_createfile(EIF_POINTER lpFileName, EIF_INTEGER dwDesiredAccess, EIF_INTEGER dwShareMode, EIF_POINTER lpSecurityAttributes, EIF_INTEGER dwCreationDistribution, EIF_INTEGER dwFlagsAndAttributes, EIF_INTEGER hTemplateFile);
EIF_BOOLEAN posix_getfileinformationbyhandle(EIF_INTEGER hFile, EIF_POINTER lpFileInformation);
EIF_INTEGER posix_getfiletype(EIF_INTEGER hFile);
EIF_INTEGER posix_getstdhandle (EIF_INTEGER nStdHandle);
EIF_BOOLEAN posix_readfile(EIF_INTEGER hFile, EIF_POINTER lpBuffer, EIF_INTEGER nNumberOfBytesToRead, EIF_POINTER lpNumberOfBytesRead, EIF_POINTER lpOverlapped);
EIF_INTEGER posix_setfilepointer (EIF_INTEGER hFile, EIF_INTEGER lDistanceToMove, EIF_POINTER lpDistanceToMoveHigh, EIF_INTEGER dwMoveMethod);
EIF_BOOLEAN posix_setstdhandle (EIF_INTEGER nStdHandle, EIF_INTEGER hHandle);
EIF_BOOLEAN posix_writefile(EIF_INTEGER hFile, EIF_POINTER lpBuffer, EIF_INTEGER nNumberOfBytesToWrite, EIF_POINTER lpNumberOfBytesWritten, EIF_POINTER lpOverlapped);


/* pipes */

EIF_BOOLEAN posix_createpipe(EIF_INTEGER hReadPipe, EIF_INTEGER hWritePipe, EIF_POINTER lpPipeAttributes, EIF_INTEGER nSize);
EIF_BOOLEAN posix_getnamedpipehandlestate(EIF_INTEGER hNamedPipe, EIF_POINTER lpState, EIF_POINTER lpCurInstances, EIF_POINTER lpMaxCollectionCount, EIF_POINTER lpCollectionDataTimeout, EIF_POINTER lpUserName, EIF_INTEGER nMaxUserNameSize);
EIF_BOOLEAN posix_peeknamedpipe (EIF_INTEGER hNamedPipe, EIF_POINTER lpBuffer, EIF_INTEGER nBufferSize, EIF_POINTER lpBytesRead, EIF_POINTER lpTotalBytesAvail, EIF_POINTER lpBytesLeftThisMessage);
EIF_BOOLEAN posix_setnamedpipehandlestate (EIF_INTEGER hNamedPipe, EIF_POINTER lpMode, EIF_POINTER lpMaxCollectionCount, EIF_POINTER lpCollectionDataTimeout);


/* shared memory */

EIF_INTEGER posix_createfilemapping (EIF_INTEGER hFile, EIF_POINTER lpAttributes, EIF_INTEGER flProtect, EIF_INTEGER dwMaximumSizeHigh, EIF_INTEGER dwMaximumSizeLow, EIF_POINTER lpName);
EIF_INTEGER posix_openfilemapping (EIF_INTEGER dwDesiredAccess, EIF_BOOLEAN bInheritHandle, EIF_POINTER lpName);
EIF_POINTER posix_mapviewoffile(EIF_INTEGER hFileMappingObject, EIF_INTEGER dwDesiredAccess, EIF_INTEGER dwFileOffsetHigh, EIF_INTEGER dwFileOffsetLow, EIF_INTEGER dwNumberOfBytesToMap);
EIF_POINTER posix_mapviewoffileex(EIF_INTEGER hFileMappingObject, EIF_INTEGER dwDesiredAccess, EIF_INTEGER dwFileOffsetHigh, EIF_INTEGER dwFileOffsetLow, EIF_INTEGER dwNumberOfBytesToMap, EIF_POINTER lpBaseAddress);
EIF_BOOLEAN posix_unmapviewoffile (EIF_POINTER lpBaseAddress);


/* semaphores */

EIF_INTEGER posix_createsemaphore(EIF_POINTER lpSemaphoreAttributes, EIF_INTEGER lInitialCount, EIF_INTEGER lMaximumCount, EIF_POINTER lpName);
EIF_INTEGER posix_opensemaphore (EIF_INTEGER dwDesiredAccess, EIF_BOOLEAN bInheritHandle, EIF_POINTER lpName);
EIF_BOOLEAN posix_releasesemaphore (EIF_INTEGER hSemaphore, EIF_INTEGER lReleaseCount, EIF_POINTER lpPreviousCount);


/* process */

EIF_BOOLEAN posix_createprocess(EIF_POINTER lpApplicationName, EIF_POINTER lpCommandLine, EIF_POINTER lpProcessAttributes, EIF_POINTER lpThreadAttributes, EIF_BOOLEAN bInheritHandles, EIF_INTEGER dwCreationFlags, EIF_POINTER lpEnvironment, EIF_POINTER lpCurrentDirectory, EIF_POINTER lpStartupInfo, EIF_POINTER lpProcessInformation);
EIF_INTEGER posix_getcurrentprocess();
EIF_INTEGER posix_getcurrentprocessid();
EIF_BOOLEAN posix_getexitcodeprocess(EIF_INTEGER hProcess, EIF_POINTER lpExitCode);
EIF_BOOLEAN posix_terminateprocess(EIF_INTEGER hProcess, EIF_INTEGER uExitCode);

/* environment variables */

EIF_BOOLEAN posix_freeenvironmentstrings(EIF_POINTER lpszEnvironmentBlock);
EIF_POINTER posix_getenvironmentstrings();
EIF_INTEGER posix_getenvironmentvariable(EIF_POINTER lpName, EIF_POINTER lpBuffer, EIF_INTEGER nSize);
EIF_BOOLEAN posix_setenvironmentvariable(EIF_POINTER lpName, EIF_POINTER lpValue);


/* NT event logging */

EIF_INTEGER posix_registereventsource(EIF_POINTER lpUNCServerName, EIF_POINTER lpSourceName);
EIF_BOOLEAN posix_reportevent(EIF_INTEGER hEventLog, EIF_INTEGER wType, EIF_INTEGER wCategory, EIF_INTEGER dwEventID, EIF_POINTER lpUserSid, EIF_INTEGER wNumStrings, EIF_INTEGER dwDataSize, EIF_POINTER lpStrings, EIF_POINTER lpRawData);
EIF_BOOLEAN posix_deregistereventsource(EIF_INTEGER hEventLog);


/* console functions */

EIF_BOOLEAN posix_getnumberofconsoleinputevents(EIF_INTEGER hConsoleInput, EIF_POINTER lpcNumberOfEvents);
EIF_BOOLEAN posix_peekconsoleinput(EIF_INTEGER hConsoleInput, EIF_POINTER lpBuffer, EIF_INTEGER nLength, EIF_POINTER lpNumberOfEventsRead);


/* security */

EIF_BOOLEAN posix_getusername (EIF_POINTER lpBuffer, EIF_POINTER nSize);
EIF_BOOLEAN posix_initializesecuritydescriptor (EIF_POINTER pSecurityDescriptor,EIF_INTEGER dwRevision);
EIF_BOOLEAN posix_setsecuritydescriptordacl (EIF_POINTER pSecurityDescriptor, EIF_BOOLEAN bDaclPresent, EIF_POINTER pDacl, EIF_BOOLEAN bDaclDefaulted);


/* High resolution timing */

EIF_BOOLEAN posix_queryperformancefrequency (EIF_POINTER lpFrequency);
EIF_BOOLEAN posix_queryperformancecounter (EIF_POINTER lpPerformanceCount);


/* various */

void posix_sleep(EIF_INTEGER dwMilliseconds);
EIF_BOOLEAN posix_getversionex(EIF_POINTER lpVersionInformation);


/* struct WIN32_FIND_DATA  */

EIF_INTEGER posix_win32_find_data_size();
EIF_POINTER posix_win32_find_data_filename (PWIN32_FIND_DATAA find_data);
EIF_INTEGER posix_win32_find_data_ftcreationtime (PWIN32_FIND_DATAA find_data);
EIF_INTEGER posix_win32_find_data_ftlastaccesstime (PWIN32_FIND_DATAA find_data);
EIF_INTEGER posix_win32_find_data_ftlastwritetime (PWIN32_FIND_DATAA find_data);


/* struct SECURITY_ATTRIBUTES */

EIF_INTEGER posix_security_attributes_size();

EIF_INTEGER posix_security_attributes_nlength(struct _SECURITY_ATTRIBUTES *p);
EIF_POINTER posix_security_attributes_lpsecuritydescriptor(struct _SECURITY_ATTRIBUTES *p);
EIF_BOOLEAN posix_security_attributes_binherithandle(struct _SECURITY_ATTRIBUTES *p);

void posix_set_security_attributes_nlength(struct _SECURITY_ATTRIBUTES *p, EIF_INTEGER nLength);
void posix_set_security_attributes_lpsecuritydescriptor(struct _SECURITY_ATTRIBUTES *p, EIF_POINTER lpSecurityDescriptor);
void posix_set_security_attributes_binherithandle(struct _SECURITY_ATTRIBUTES *p, EIF_BOOLEAN bInheritHandle);


/* struct SECURITY_DESCRIPTOR */

EIF_INTEGER posix_security_descriptor_size();


/* struct _STARTUPINFOA */

EIF_INTEGER posix_startupinfo_size();

EIF_INTEGER posix_startupinfo_cb(struct _STARTUPINFOA *p);
EIF_POINTER posix_startupinfo_lpreserved(struct _STARTUPINFOA *p);
EIF_POINTER posix_startupinfo_lpdesktop(struct _STARTUPINFOA *p);
EIF_POINTER posix_startupinfo_lptitle(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_dwx(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_dwy(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_dwxsize(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_dwysize(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_dwxcountchars(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_dwycountchars(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_dwfillattribute(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_dwflags(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_wshowwindow(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_cbreserved2(struct _STARTUPINFOA *p);
EIF_POINTER posix_startupinfo_lpreserved2(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_hstdinput(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_hstdoutput(struct _STARTUPINFOA *p);
EIF_INTEGER posix_startupinfo_hstderror(struct _STARTUPINFOA *p);

void posix_set_startupinfo_cb(struct _STARTUPINFOA *p, EIF_INTEGER cb);
void posix_set_startupinfo_lpreserved(struct _STARTUPINFOA *p, EIF_POINTER lpReserved);
void posix_set_startupinfo_lpdesktop(struct _STARTUPINFOA *p, EIF_POINTER lpDesktop);
void posix_set_startupinfo_lptitle(struct _STARTUPINFOA *p, EIF_POINTER lpTitle);
void posix_set_startupinfo_dwx(struct _STARTUPINFOA *p, EIF_INTEGER dwX);
void posix_set_startupinfo_dwy(struct _STARTUPINFOA *p, EIF_INTEGER dwY);
void posix_set_startupinfo_dwxsize(struct _STARTUPINFOA *p, EIF_INTEGER dwXSize);
void posix_set_startupinfo_dwysize(struct _STARTUPINFOA *p, EIF_INTEGER dwYSize);
void posix_set_startupinfo_dwxcountchars(struct _STARTUPINFOA *p, EIF_INTEGER dwXCountChars);
void posix_set_startupinfo_dwycountchars(struct _STARTUPINFOA *p, EIF_INTEGER dwYCountChars);
void posix_set_startupinfo_dwfillattribute(struct _STARTUPINFOA *p, EIF_INTEGER dwFillAttribute);
void posix_set_startupinfo_dwflags(struct _STARTUPINFOA *p, EIF_INTEGER dwFlags);
void posix_set_startupinfo_wshowwindow(struct _STARTUPINFOA *p, EIF_INTEGER wShowWindow);
void posix_set_startupinfo_cbreserved2(struct _STARTUPINFOA *p, EIF_INTEGER cbReserved2);
void posix_set_startupinfo_lpreserved2(struct _STARTUPINFOA *p, EIF_POINTER lpReserved2);
void posix_set_startupinfo_hstdinput(struct _STARTUPINFOA *p, EIF_INTEGER hStdInput);
void posix_set_startupinfo_hstdoutput(struct _STARTUPINFOA *p, EIF_INTEGER hStdOutput);
void posix_set_startupinfo_hstderror(struct _STARTUPINFOA *p, EIF_INTEGER hStdError);


/* struct PROCESS_INFORMATION */

EIF_INTEGER posix_process_information_size();

EIF_INTEGER posix_process_information_hprocess(struct _PROCESS_INFORMATION *p);
EIF_INTEGER posix_process_information_hthread(struct _PROCESS_INFORMATION *p);
EIF_INTEGER posix_process_information_dwprocessid(struct _PROCESS_INFORMATION *p);
EIF_INTEGER posix_process_information_dwthreadid(struct _PROCESS_INFORMATION *p);


/* struct BY_HANDLE_FILE_INFORMATION */

EIF_INTEGER posix_by_handle_file_information_size();

EIF_INTEGER posix_by_handle_file_information_dwfileattributes(struct _BY_HANDLE_FILE_INFORMATION *p);
EIF_INTEGER posix_by_handle_file_information_ftcreationtime(struct _BY_HANDLE_FILE_INFORMATION *p);
EIF_INTEGER posix_by_handle_file_information_ftlastaccesstime(struct _BY_HANDLE_FILE_INFORMATION *p);
EIF_INTEGER posix_by_handle_file_information_ftlastwritetime(struct _BY_HANDLE_FILE_INFORMATION *p);
EIF_INTEGER posix_by_handle_file_information_dwvolumeserialnumber(struct _BY_HANDLE_FILE_INFORMATION *p);
EIF_INTEGER posix_by_handle_file_information_nfilesizehigh(struct _BY_HANDLE_FILE_INFORMATION *p);
EIF_INTEGER posix_by_handle_file_information_nfilesizelow(struct _BY_HANDLE_FILE_INFORMATION *p);
EIF_INTEGER posix_by_handle_file_information_nnumberoflinks(struct _BY_HANDLE_FILE_INFORMATION *p);
EIF_INTEGER posix_by_handle_file_information_nfileindexhigh(struct _BY_HANDLE_FILE_INFORMATION *p);
EIF_INTEGER posix_by_handle_file_information_nfileindexlow(struct _BY_HANDLE_FILE_INFORMATION *p);


/* struct _OSVERSIONINFOA */

EIF_INTEGER posix_osversioninfoa_size();

EIF_INTEGER posix_osversioninfoa_dwosversioninfosize(struct _OSVERSIONINFOA *p);
EIF_INTEGER posix_osversioninfoa_dwmajorversion(struct _OSVERSIONINFOA *p);
EIF_INTEGER posix_osversioninfoa_dwminorversion(struct _OSVERSIONINFOA *p);
EIF_INTEGER posix_osversioninfoa_dwbuildnumber(struct _OSVERSIONINFOA *p);
EIF_INTEGER posix_osversioninfoa_dwplatformid(struct _OSVERSIONINFOA *p);
EIF_POINTER posix_osversioninfoa_szcsdversion(struct _OSVERSIONINFOA *p);

void posix_set_osversioninfoa_dwosversioninfosize(struct _OSVERSIONINFOA *p, EIF_INTEGER dwOSVersionInfoSize);


/* struct INPUT_RECORD */

EIF_INTEGER posix_input_record_size();

EIF_INTEGER posix_input_record_eventtype(INPUT_RECORD *p);


/* constants */

EIF_INTEGER const_duplicate_same_access();
EIF_INTEGER const_infinite();
EIF_INTEGER const_invalid_handle_value();
EIF_POINTER const_invalid_ptr_handle_value();
EIF_INTEGER const_max_path();
EIF_INTEGER const_sw_hide();
EIF_INTEGER const_unlen();


/* constants for dwCreationFlags of CreateProcess */

EIF_INTEGER const_create_default_error_mode();
EIF_INTEGER const_create_new_console();
EIF_INTEGER const_create_new_process_group();
EIF_INTEGER const_create_suspended();
EIF_INTEGER const_detached_process();


/* STARTUPINFO.dwFlags */

EIF_INTEGER const_startf_useshowwindow	();
EIF_INTEGER const_startf_useposition	();
EIF_INTEGER const_startf_usesize	();
EIF_INTEGER const_startf_usecountchars	();
EIF_INTEGER const_startf_usefillattribute	();
EIF_INTEGER const_startf_forceonfeedback	();
EIF_INTEGER const_startf_forceofffeedback	();
EIF_INTEGER const_startf_usestdhandles();


/* GetStdHandle parameter */

EIF_INTEGER const_std_input_handle();
EIF_INTEGER const_std_output_handle();
EIF_INTEGER const_std_error_handle();


/* constants for dwDesiredAccess of CreateFile */

EIF_INTEGER const_generic_read	();
EIF_INTEGER const_generic_write	();


/* constants for dwShareMode of CreateFile */

EIF_INTEGER const_file_share_delete	();
EIF_INTEGER const_file_share_read	();
EIF_INTEGER const_file_share_write	();


/* constants for dwCreationDistribution of CreateFile */

EIF_INTEGER const_create_new	();
EIF_INTEGER const_create_always	();
EIF_INTEGER const_open_existing	();
EIF_INTEGER const_open_always	();
EIF_INTEGER const_truncate_existing	();


/* constants for dwFlagsAndAttributes of CreateFile */

EIF_INTEGER const_file_attribute_archive	();
EIF_INTEGER const_file_attribute_compressed	();
EIF_INTEGER const_file_attribute_directory();
EIF_INTEGER const_file_attribute_hidden	();
EIF_INTEGER const_file_attribute_normal	();
EIF_INTEGER const_file_attribute_offline	();
EIF_INTEGER const_file_attribute_readonly	();
EIF_INTEGER const_file_attribute_system	();
EIF_INTEGER const_file_attribute_temporary	();
EIF_INTEGER const_file_flag_write_through();
EIF_INTEGER const_file_flag_overlapped();
EIF_INTEGER const_file_flag_no_buffering();
EIF_INTEGER const_file_flag_random_access();
EIF_INTEGER const_file_flag_sequential_scan();
EIF_INTEGER const_file_flag_delete_on_close();
EIF_INTEGER const_file_flag_backup_semantics();
EIF_INTEGER const_file_flag_posix_semantics();


/* GetFileType constants */

EIF_INTEGER const_file_type_unknown();
EIF_INTEGER const_file_type_disk();
EIF_INTEGER const_file_type_char();
EIF_INTEGER const_file_type_pipe();


/* event type constants */

EIF_INTEGER const_eventlog_success();
EIF_INTEGER const_eventlog_error_type();
EIF_INTEGER const_eventlog_warning_type();
EIF_INTEGER const_eventlog_information_type();
EIF_INTEGER const_eventlog_audit_success();
EIF_INTEGER const_eventlog_audit_failure();


/* Protection desired for file view */

EIF_INTEGER const_page_readonly();
EIF_INTEGER const_page_readwrite();
EIF_INTEGER const_page_writecopy();


/* Type of access to the file mapping object */

EIF_INTEGER const_file_map_write();
EIF_INTEGER const_file_map_read();
EIF_INTEGER const_file_map_all_access();
EIF_INTEGER const_file_map_copy();


/* values for OSVERSIONINFOA.dwPlatformId */

EIF_INTEGER const_ver_platform_win32s();
EIF_INTEGER const_ver_platform_win32_windows();
EIF_INTEGER const_ver_platform_win32_nt();


/* pipe state */

EIF_INTEGER const_pipe_nowait();
EIF_INTEGER const_pipe_wait();


/* semaphore access rights */

EIF_INTEGER const_semaphore_all_access();


/* security descriptor */

EIF_INTEGER const_security_descriptor_revision();


#endif /* _W_WINDOWS_H_ */
