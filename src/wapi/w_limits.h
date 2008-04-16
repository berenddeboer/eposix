/*

Access to Windows <limits.h>

Had to define _POSIX_, so not sure if these are the real Windows limits.

*/

#ifndef _W_LIMITS_H_
#define _W_LIMITS_H_

#define _POSIX_ 1

#include <limits.h>
#include <eiffel.h>

#if HAVE_CONFIG_H
#include <config.h>
#endif


/* constants */

EIF_INTEGER const_arg_max();
EIF_INTEGER const_open_max();
EIF_INTEGER const_stream_max();
EIF_INTEGER const_tzname_max();


#endif /* _W_LIMITS_H_ */
