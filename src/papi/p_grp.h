/*

C layer to POSIX group routines

*/


#ifndef _P_GRP_H_
#define _P_GRP_H_

#include "p_defs.h"
#include <grp.h>
#include "../supportc/eiffel.h"


EIF_POINTER posix_getgrnam(EIF_POINTER name);
EIF_POINTER posix_getgrgid(EIF_INTEGER gid);

EIF_POINTER posix_gr_name(struct group * g);
EIF_INTEGER posix_gr_gid(struct group * g);
EIF_POINTER posix_gr_mem(struct group * g);

#endif /* _P_GRP_H_ */
