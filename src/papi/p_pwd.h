/*

C layer to POSIX pwd.h header

*/


#ifndef _P_PWD_H_
#define _P_PWD_H_

#include "p_defs.h"
#include <pwd.h>
#include "../supportc/eiffel.h"


EIF_POINTER posix_getpwnam(EIF_POINTER name);
EIF_POINTER posix_getpwuid(EIF_INTEGER uid);

EIF_POINTER posix_pw_name(struct passwd * p);
EIF_INTEGER posix_pw_uid(struct passwd * p);
EIF_INTEGER posix_pw_gid(struct passwd * p);
EIF_POINTER posix_pw_dir(struct passwd * p);
EIF_POINTER posix_pw_shell(struct passwd * p);

#endif /* _P_PWD_H_ */
