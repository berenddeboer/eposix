#include "p_utsname.h"

EIF_INTEGER posix_uname(struct utsname *name)
{
  return uname(name);
}


EIF_POINTER posix_uname_machine(struct utsname *name)
{
  return(name->machine);
}


EIF_POINTER posix_uname_nodename(struct utsname *name)
{
  return(name->nodename);
}


EIF_POINTER posix_uname_release(struct utsname *name)
{
  return(name->release);
}


EIF_POINTER posix_uname_sysname(struct utsname *name)
{
  return(name->sysname);
}


EIF_POINTER posix_uname_version(struct utsname *name)
{
  return(name->version);
}


EIF_INTEGER posix_utsname_size()
{
  return (sizeof(struct utsname));  
}
