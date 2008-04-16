/*

Access to Posix utime.h header

*/


#ifndef _P_UTIME_H_
#define _P_UTIME_H_

#include "p_defs.h"
/* FreeBSD likes sys/types.h here */
#include <sys/types.h>
#include <utime.h>
#include "../supportc/eiffel.h"


EIF_INTEGER posix_utime(EIF_POINTER path, EIF_INTEGER actime, EIF_INTEGER modtime);


#endif /* _P_UTIME_H_ */
