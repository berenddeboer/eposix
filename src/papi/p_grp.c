/*

C layer to POSIX group routines

*/

#include "p_grp.h"


EIF_POINTER posix_getgrnam(EIF_POINTER name)
{
  return getgrnam(name);
}


EIF_POINTER posix_getgrgid(EIF_INTEGER gid)
{
  return getgrgid(gid);
}


EIF_POINTER posix_gr_name(struct group * g)
{
  return(g->gr_name);
}


EIF_INTEGER posix_gr_gid(struct group * g)
{
  return(g->gr_gid);
}


EIF_POINTER posix_gr_mem(struct group * g)
{
  return(g->gr_mem);
}

