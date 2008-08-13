/*

Eiffel C glue to Windows IPHlpApi.h.

*/


#ifndef _W_IPHLPAPI_H_
#define _W_IPHLPAPI_H_

#include <stdio.h>
#include <windows.h>
#include <IPHlpApi.h>
#include "../supportc/eiffel.h"


/* functions */

EIF_INTEGER posix_gettcptable(EIF_POINTER pTcpTable, EIF_POINTER pwdSize, EIF_BOOLEAN bOrder);


/* struct _MIB_TCPTABLE */

EIF_INTEGER posix_mib_tcptable_size();

EIF_INTEGER posix_mib_tcptable_dwnumentries(struct _MIB_TCPTABLE *p);
EIF_POINTER posix_mib_tcptable_table_item(struct _MIB_TCPTABLE *p, EIF_INTEGER index);


/* struct _MIB_TCPROW */

EIF_INTEGER posix_mib_tcprow_size();

EIF_INTEGER posix_mib_tcprow_dwstate(struct _MIB_TCPROW *p);
EIF_INTEGER posix_mib_tcprow_dwlocaladdr(struct _MIB_TCPROW *p);
EIF_INTEGER posix_mib_tcprow_dwlocalport(struct _MIB_TCPROW *p);
EIF_INTEGER posix_mib_tcprow_dwremoteaddr(struct _MIB_TCPROW *p);
EIF_INTEGER posix_mib_tcprow_dwremoteport(struct _MIB_TCPROW *p);


#endif /* _W_IPHLPAPI_H_ */
