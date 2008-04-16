/*

Access to POSIX limits.h

*/

#ifndef _P_LIMITS_H_
#define _P_LIMITS_H_

#include "p_defs.h"
#include <limits.h>
#include <stdio.h>
#include <unistd.h>
#include "../supportc/eiffel.h"


/* constants */

EIF_INTEGER const_max_input();
EIF_INTEGER const_name_max();
EIF_INTEGER const_path_max();
EIF_INTEGER const_pipe_buf();
EIF_INTEGER const_ssize_max();
EIF_INTEGER const_stream_max();


#endif /* _P_LIMITS_H_ */
