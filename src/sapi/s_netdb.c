#include "s_netdb.h"


/* hosts */

EIF_POINTER posix_gethostbyaddr(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER type)
{
  return (EIF_POINTER) gethostbyaddr(addr, len, type);
}

EIF_POINTER posix_gethostbyname (EIF_POINTER hostname)
{
  return (EIF_POINTER) gethostbyname(hostname);
}

EIF_POINTER posix_getservbyname(EIF_POINTER name, EIF_POINTER proto)
{
  return (EIF_POINTER) getservbyname(name, proto);
}

EIF_POINTER posix_getservbyport (EIF_INTEGER port, EIF_POINTER proto)
{
#ifdef HAVE_GETSERVBYPORT
  return (EIF_POINTER) getservbyport(port, proto);
#else
  return ((EIF_POINTER) 0);
#endif
}


/* struct hostent */

EIF_INTEGER posix_hostent_size()
{
   return (sizeof (struct hostent));
}

EIF_POINTER posix_hostent_h_name(struct hostent *p)
{
  return p->h_name;
}


EIF_POINTER posix_hostent_h_aliases(struct hostent *p)
{
  return (EIF_POINTER) (p->h_aliases);
}

EIF_INTEGER posix_hostent_h_addrtype(struct hostent *p)
{
  return p->h_addrtype;
}

EIF_INTEGER posix_hostent_h_length(struct hostent *p)
{
  return p->h_length;
}

EIF_POINTER posix_hostent_h_addr_list(struct hostent *p)
{
  return (EIF_POINTER) (p->h_addr_list);
}


/* struct servent */

EIF_INTEGER posix_servent_size()
{
   return (sizeof (struct servent));
}

EIF_POINTER posix_servent_s_name(struct servent *p)
{
  return p->s_name;
}

EIF_POINTER posix_servent_s_aliases(struct servent *p)
{
  return (EIF_POINTER) (p->s_aliases);
}

EIF_INTEGER posix_servent_s_port(struct servent *p)
{
  return p->s_port;
}

EIF_POINTER posix_servent_s_proto(struct servent *p)
{
  return p->s_proto;
}


/* h_error */

EIF_INTEGER posix_h_errno()
{
  return h_errno;
}


/* h_errno constants */

EIF_INTEGER const_try_again()
{
  return TRY_AGAIN;
}

EIF_INTEGER const_no_recovery()
{
  return NO_RECOVERY;
}

EIF_INTEGER const_no_data()
{
  return NO_DATA;
}
