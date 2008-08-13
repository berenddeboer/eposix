/*

Various C support functions for ePOSIX.

*/

#ifndef _C_SUPPORT_H_
#define _C_SUPPORT_H_

#include <eiffel.h>


/* bit operations */
/*
Eiffel's INTEGER type doesn't allow the very usefull or, and and xor stuff.
And you can't make an INTEGER into a BIT, the class that has these
features, at least not portable. More than enough work for ELKS200X.
*/

EIF_INTEGER posix_and (EIF_INTEGER op1, EIF_INTEGER op2);
EIF_INTEGER posix_not (EIF_INTEGER op);
EIF_INTEGER posix_or (EIF_INTEGER op1, EIF_INTEGER op2);


/* endianess */

EIF_INTEGER posix_first_byte (EIF_INTEGER i);
EIF_INTEGER posix_swap16 (EIF_INTEGER i);
EIF_INTEGER posix_swap32 (EIF_INTEGER i);
EIF_INTEGER_64 posix_swap64 (EIF_INTEGER_64 i);


/* read/write arbitrary bytes */

EIF_CHARACTER posix_peek_character(EIF_POINTER ptr, EIF_INTEGER index);
EIF_INTEGER posix_peek_int16_native(EIF_POINTER ptr, EIF_INTEGER index);
EIF_INTEGER posix_peek_int32_native(EIF_POINTER ptr, EIF_INTEGER index);
EIF_INTEGER posix_peek_uint8(EIF_POINTER ptr, EIF_INTEGER index);
EIF_INTEGER posix_peek_uint16_native(EIF_POINTER ptr, EIF_INTEGER index);

void posix_poke_character(EIF_POINTER ptr, EIF_INTEGER index, EIF_CHARACTER c);
void posix_poke_int16_native(EIF_POINTER ptr, EIF_INTEGER index, EIF_INTEGER value);
void posix_poke_int32_native(EIF_POINTER ptr, EIF_INTEGER index, EIF_INTEGER value);
void posix_poke_uint8(EIF_POINTER ptr, EIF_INTEGER index, EIF_INTEGER value);


/* pointer operations */

EIF_POINTER posix_pointer_add (EIF_POINTER p, EIF_INTEGER offset);
EIF_POINTER posix_pointer_advance (EIF_POINTER p);
EIF_POINTER posix_pointer_contents (EIF_POINTER p);


/* pointer conversion */

EIF_INTEGER posix_pointer_to_integer (EIF_POINTER p);


/* which platform?? */

EIF_BOOLEAN is_windows();


#endif /* _C_SUPPORT_H_ */
