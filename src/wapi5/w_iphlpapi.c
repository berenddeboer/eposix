#include "w_iphlpapi.h"


/* functions */

EIF_INTEGER posix_gettcptable(EIF_POINTER pTcpTable, EIF_POINTER pwdSize, EIF_BOOLEAN bOrder) {
  return GetTcpTable (pTcpTable, pwdSize, bOrder);
}


/* struct _MIB_TCPTABLE */

EIF_INTEGER posix_mib_tcptable_size()
{
   return (sizeof (struct _MIB_TCPTABLE));
}

EIF_INTEGER posix_mib_tcptable_dwnumentries(struct _MIB_TCPTABLE *p)
{
  return p->dwNumEntries;
}

EIF_POINTER posix_mib_tcptable_table_item(struct _MIB_TCPTABLE *p, EIF_INTEGER index)
{
  return (EIF_POINTER) &(p->table [index]);
}


/* struct _MIB_TCPROW */

EIF_INTEGER posix_mib_tcprow_size()
{
   return (sizeof (struct _MIB_TCPROW));
}

EIF_INTEGER posix_mib_tcprow_dwstate(struct _MIB_TCPROW *p)
{
  return p->dwState;
}

EIF_INTEGER posix_mib_tcprow_dwlocaladdr(struct _MIB_TCPROW *p)
{
  return p->dwLocalAddr;
}

EIF_INTEGER posix_mib_tcprow_dwlocalport(struct _MIB_TCPROW *p)
{
  return p->dwLocalPort;
}

EIF_INTEGER posix_mib_tcprow_dwremoteaddr(struct _MIB_TCPROW *p)
{
  return p->dwRemoteAddr;
}

EIF_INTEGER posix_mib_tcprow_dwremoteport(struct _MIB_TCPROW *p)
{
  return p->dwRemotePort;
}
