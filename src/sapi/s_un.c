#include "s_un.h"


#ifdef HAVE_SYS_UN_H

/* struct sockaddr_un */

EIF_INTEGER posix_sockaddr_un_size()
{
   return (sizeof (struct sockaddr_un));
}

EIF_INTEGER posix_sockaddr_un_sun_family(struct sockaddr_un *p)
{
  return p->sun_family;
}

EIF_POINTER posix_sockaddr_un_sun_path(struct sockaddr_un *p)
{
  return (EIF_POINTER) & (p->sun_path);
}


void posix_set_sockaddr_un_sun_family(struct sockaddr_un *p, EIF_INTEGER sun_family)
{
  p->sun_family = sun_family;
}

void posix_set_sockaddr_un_sun_path(struct sockaddr_un *p, EIF_POINTER sun_path)
{
  strncpy((char *) &(p->sun_path), sun_path, 99);
  p->sun_path[99] = 0;
}


#endif
