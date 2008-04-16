/*

C layer to POSIX user routines

*/

#include "p_pwd.h"


EIF_POINTER posix_getpwnam(EIF_POINTER name)
{
  return getpwnam(name);
}


EIF_POINTER posix_getpwuid(EIF_INTEGER uid)
{
  return getpwuid(uid);
}


EIF_POINTER posix_pw_name(struct passwd * p)
{
  return(p->pw_name);
}

EIF_INTEGER posix_pw_uid(struct passwd * p)
{
  return(p->pw_uid);
}

EIF_INTEGER posix_pw_gid(struct passwd * p)
{
  return(p->pw_gid);
}

EIF_POINTER posix_pw_dir(struct passwd * p)
{
  return(p->pw_dir);
}

EIF_POINTER posix_pw_shell(struct passwd * p)
{
  return(p->pw_shell);
}
