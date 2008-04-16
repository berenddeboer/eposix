/*

Access to Single Unix Specification netdb.h

*/

#ifndef _S_NETDB_H_
#define _S_NETDB_H_

#include "s_defs.h"
#include <netdb.h>
#include "../supportc/eiffel.h"


/* hosts */

EIF_POINTER posix_gethostbyaddr(EIF_POINTER addr, EIF_INTEGER len, EIF_INTEGER type);
EIF_POINTER posix_gethostbyname(EIF_POINTER hostname);
EIF_POINTER posix_getservbyname(EIF_POINTER name, EIF_POINTER proto);
EIF_POINTER posix_getservbyport(EIF_INTEGER port, EIF_POINTER proto);


/* struct hostent */

EIF_INTEGER posix_hostent_size();

EIF_POINTER posix_hostent_h_name(struct hostent *p);
EIF_POINTER posix_hostent_h_aliases(struct hostent *p);
EIF_INTEGER posix_hostent_h_addrtype(struct hostent *p);
EIF_INTEGER posix_hostent_h_length(struct hostent *p);
EIF_POINTER posix_hostent_h_addr_list(struct hostent *p);


/* struct servent */

EIF_INTEGER posix_servent_size();

EIF_POINTER posix_servent_s_name(struct servent *p);
EIF_POINTER posix_servent_s_aliases(struct servent *p);
EIF_INTEGER posix_servent_s_port(struct servent *p);
EIF_POINTER posix_servent_s_proto(struct servent *p);


/* h_error */

EIF_INTEGER posix_h_errno();


/* h_errno constants */

EIF_INTEGER const_try_again();
EIF_INTEGER const_no_recovery();
EIF_INTEGER const_no_data();


#endif /* _S_NETDB_H_ */
