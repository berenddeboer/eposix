/*

C layer to Windows windows.h

*/


#ifndef _W_WINDOWS5_H_
#define _W_WINDOWS5_H_

#define _WIN32_WINNT 0x0500

#include <Windows.h>


/* jobs */

EIF_INTEGER posix_createjobobject(EIF_POINTER lpJobAttributes, EIF_POINTER lpName);


#endif /* _W_WINDOWS5_H_ */
