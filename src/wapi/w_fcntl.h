/*

C layer to Windows fcntl.h

*/


#ifndef _W_FCNTL_H_
#define _W_FCNTL_H_

#include <sys/stat.h>
#include <fcntl.h>
#include "../supportc/eiffel.h"


/* constants */

EIF_INTEGER const_o_append();
EIF_INTEGER const_o_binary();
EIF_INTEGER const_o_creat();
EIF_INTEGER const_o_excl();
EIF_INTEGER const_o_random();
EIF_INTEGER const_o_rdonly();
EIF_INTEGER const_o_rdwr();
EIF_INTEGER const_o_short_lived();
EIF_INTEGER const_o_temporary();
EIF_INTEGER const_o_sequential();
EIF_INTEGER const_o_text();
EIF_INTEGER const_o_trunc();
EIF_INTEGER const_o_wronly();


#endif /* _W_FCNTL_H_ */
