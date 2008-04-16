/*

Access to Posix sys/utsname.h header

*/

#ifndef _P_UTSNAME_H_
#define _P_UTSNAME_H_


#include "p_defs.h"
#include <sys/utsname.h>
#include "../supportc/eiffel.h"


EIF_INTEGER posix_uname(struct utsname *name);

EIF_POINTER posix_uname_machine(struct utsname *name);
EIF_POINTER posix_uname_nodename(struct utsname *name);
EIF_POINTER posix_uname_release(struct utsname *name);
EIF_POINTER posix_uname_sysname(struct utsname *name);
EIF_POINTER posix_uname_version(struct utsname *name);
EIF_INTEGER posix_utsname_size();


#endif /* _P_UTSNAME_H_ */
