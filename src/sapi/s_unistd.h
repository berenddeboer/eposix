/*

Access to Single Unix Specification additions to unistd.h

*/

#ifndef _S_UNISTD_H_
#define _S_UNISTD_H_

#include "s_defs.h"
#include <unistd.h>
#include "../supportc/eiffel.h"

/* filesystem related */

EIF_INTEGER posix_symlink (EIF_POINTER oldpath, EIF_POINTER newpath);


/* network related */

EIF_INTEGER posix_gethostname(EIF_POINTER name, EIF_INTEGER namelen);


#endif /* _S_UNISTD_H_ */
