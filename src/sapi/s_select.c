#include "s_select.h"


/* synchronous I/O multiplexing */

EIF_INTEGER posix_select(EIF_INTEGER nfds, EIF_POINTER readfds, EIF_POINTER writefds, EIF_POINTER errorfds, EIF_POINTER timeout)
{
  return (select (nfds, (fd_set *) readfds, (fd_set *) writefds, (fd_set *) errorfds,  (struct timeval *) timeout));
}


/* file descriptor set operations */

void posix_fd_clr(EIF_INTEGER fd, EIF_POINTER fdset)
{
  FD_CLR (fd, (fd_set *) fdset);
}

EIF_BOOLEAN posix_fd_isset(EIF_INTEGER fd, EIF_POINTER fdset)
{
  if (FD_ISSET (fd, (fd_set *) fdset)) {
	return EIF_TRUE;
  }
  else {
    return EIF_FALSE;
  }
}

void posix_fd_set(EIF_INTEGER fd, EIF_POINTER fdset)
{
  FD_SET (fd, (fd_set *) fdset);
}

void posix_fd_zero(EIF_POINTER fdset)
{
  FD_ZERO ((fd_set *) fdset);
}


/* struct fd_set size */

EIF_INTEGER posix_fd_set_size ()
{
  return (sizeof (fd_set));
}


/* constants */

EIF_INTEGER const_fd_setsize()
{
  return FD_SETSIZE;
}
