/* Make sure proper POSIX DEFINEs are available */

/* 500 is the only level supported by QNX */

#if defined(__QNXNTO__) || defined(sun)
#define _XOPEN_SOURCE 500
#else
#define _XOPEN_SOURCE 600
#endif

#if HAVE_CONFIG_H
#include <config.h>
#endif
