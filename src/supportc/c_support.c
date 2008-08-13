/*

General utility functions.

*/


#include "c_support.h"


/* bit operations */

EIF_INTEGER posix_and (EIF_INTEGER op1, EIF_INTEGER op2)
{
  return (op1 & op2);
}


EIF_INTEGER posix_not (EIF_INTEGER op)
{
  return (~ op);
}


EIF_INTEGER posix_or (EIF_INTEGER op1, EIF_INTEGER op2)
{
  return (op1 | op2);
}


/* determine endianess */

EIF_INTEGER posix_first_byte (EIF_INTEGER i)
{
  return (((unsigned char *) (&i))[0]);
}

EIF_INTEGER posix_swap16 (EIF_INTEGER i)
{
  int a,b; /* a is MSB byte, b is LSB byte */
  a = (i & 0xff00) >> 8;
  b = (i & 0x00ffU) << 8;
  return ( a | b );
}

EIF_INTEGER posix_swap32 (EIF_INTEGER i)
{
  int a,b,c,d; /* a is MSB byte, d is LSB byte */
  /* naive implementation
  a = (i & 0xff000000) >> 24;
  b = (i & 0x00ff0000) >> 16;
  c = (i & 0x0000ff00) >> 8;
  d = (i & 0x000000ff);
  return ( (a) | (b << 8) | (c << 16) | (d << 24));
  */
  /* hopefully faster one */
  a = (i & 0xff000000U) >> 24;
  b = (i & 0x00ff0000U) >> 8;
  c = (i & 0x0000ff00U) << 8;
  d = (i & 0x000000ffU) << 24;
  return ( a | b | c | d);
}

EIF_INTEGER_64 posix_swap64 (EIF_INTEGER_64 i) {
  EIF_INTEGER_64 a,b,c,d,e,f,g,h; /* a is MSB byte, h is LSB byte */
  a = (i & 0xff00000000000000ULL) >> 56;
  b = (i & 0x00ff000000000000ULL) >> 48;
  c = (i & 0x0000ff0000000000ULL) >> 40;
  d = (i & 0x000000ff00000000ULL) >> 32;
  e = (i & 0x00000000ff000000ULL) >> 24;
  f = (i & 0x0000000000ff0000ULL) >> 16;
  g = (i & 0x000000000000ff00ULL) >>  8;
  h = (i & 0x00000000000000ffULL);
  return ( (a) | (b << 8) | (c << 16) | (d << 24) | (e << 32) | (f << 40) | (g << 48) | (h << 56));
}

/* read/write arbitrary bytes */

EIF_CHARACTER posix_peek_character(EIF_POINTER ptr, EIF_INTEGER index)
{
  return (((unsigned char *) ptr)[index]);
}

EIF_INTEGER posix_peek_int16_native(EIF_POINTER ptr, EIF_INTEGER index)
{
  return (*( (short *) ((char *)ptr + index)) );
}

EIF_INTEGER posix_peek_int32_native(EIF_POINTER ptr, EIF_INTEGER index)
{
  /* hey, do I understand C pointer arithmetic and type casting, or not? :-) */
  return (*( (int *) ((char *)ptr + index)) );
}

EIF_INTEGER posix_peek_uint8(EIF_POINTER ptr, EIF_INTEGER index)
{
  return (((unsigned char *) ptr)[index]);
}

EIF_INTEGER posix_peek_uint16_native(EIF_POINTER ptr, EIF_INTEGER index)
{
  return (*( (unsigned short *) ((char *)ptr + index)) );
}

EIF_INTEGER posix_peek_uint32_native(EIF_POINTER ptr, EIF_INTEGER index)
{
  return (*( (unsigned int *) ((char *)ptr + index)) );
}


void posix_poke_character(EIF_POINTER ptr, EIF_INTEGER index, EIF_CHARACTER c)
{
  ((char *) ptr)[index] = c;
}

void posix_poke_int16_native(EIF_POINTER ptr, EIF_INTEGER index, EIF_INTEGER value)
{
  *((short *) ((char *)ptr + index)) = value;
}

void posix_poke_int32_native(EIF_POINTER ptr, EIF_INTEGER index, EIF_INTEGER value)
{
  *((int *) ((char *)ptr + index)) = value;
}

void posix_poke_uint8(EIF_POINTER ptr, EIF_INTEGER index, EIF_INTEGER value)
{
  ((unsigned char *) ptr)[index] = value;
}



/* pointer operations */

EIF_POINTER posix_pointer_add (EIF_POINTER p, EIF_INTEGER offset)
{
  return (EIF_POINTER) ( (char *)p + offset);
}

EIF_POINTER posix_pointer_advance (EIF_POINTER p)
{
  return (EIF_POINTER)((char **)p + 1);
}

EIF_POINTER posix_pointer_contents (EIF_POINTER p)
{
  return *((void**) p);
}


/* pointer conversion */

EIF_INTEGER posix_pointer_to_integer (EIF_POINTER p)
{
  return ((EIF_INTEGER) p);
}


/* which platform?? */

EIF_BOOLEAN is_windows()
{
#ifdef _WIN32
#ifndef __CYGWIN__
  return 1;
#else
  return 0;
#endif
#else
  return 0;
#endif
}
