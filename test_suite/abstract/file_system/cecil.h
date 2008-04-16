/*
-- This file is  free  software, which  comes  along  with  SmartEiffel. This
-- software  is  distributed  in the hope that it will be useful, but WITHOUT
-- ANY  WARRANTY;  without  even  the  implied warranty of MERCHANTABILITY or
-- FITNESS  FOR A PARTICULAR PURPOSE. You can modify it as you want, provided
-- this header is kept unaltered, and a notification of the changes is added.
-- You  are  allowed  to  redistribute  it and sell it, alone or as a part of
-- another product.
--       Copyright (C) 1994-2002 LORIA - INRIA - U.H.P. Nancy 1 - FRANCE
--          Dominique COLNET and Suzanne COLLIN - SmartEiffel@loria.fr
--                       http://SmartEiffel.loria.fr
--
*/
/*
  This file (SmartEiffel/sys/runtime/base.h) contains all basic Eiffel
  type definitions.
  This file is automatically included in the header for all modes of
  compilation: -boost, -no_check, -require_check, -ensure_check, ...
  This file is also included in the header of any cecil file (when the
  -cecil option is used).
  This file is also included in the header file of C++ wrappers (when
  using the external "C++" clause).
*/

#ifndef _BASE_H
#define _BASE_H

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <signal.h>
#include <stddef.h>
#include <stdarg.h>
#include <limits.h>
#include <float.h>
#include <setjmp.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#if defined __USE_POSIX || defined __unix__ || defined _POSIX_C_SOURCE
#  include <unistd.h>
#endif
#if !defined(WIN32) && \
       (defined(WINVER) || defined(_WIN32_WINNT) || defined(_WIN32) || \
	defined(__WIN32__) || defined(__TOS_WIN__) || defined(_MSC_VER))
#  define WIN32 1
#endif
#ifdef WIN32
#  include <windows.h>
#else
#  ifndef O_RDONLY
#    include <sys/file.h>
#  endif
#  ifndef O_RDONLY
#    define O_RDONLY 0000
#  endif
#endif

#if defined(_MSC_VER) 
typedef signed char int8_t;
typedef signed short int16_t;
typedef signed int int32_t;
typedef signed __int64 int64_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned __int64 uint64_t;
#  define PRId8 "d"
#  define PRId16 "d"
#  define PRId32 "d"
#  define PRId64 "I64d"
#  define INT8_C(c) c
#  define INT16_C(c) c
#  define INT32_C(c) c
#  define INT64_C(c) c ## i64
#elif defined(__WATCOMC__) && (__WATCOMC__ <= 1100) /* WATCOM 11 or lower */
typedef signed char int8_t;
typedef signed short int16_t;
typedef signed long int int32_t;
typedef signed __int64 int64_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long int uint32_t;
typedef unsigned __int64 uint64_t;
#  define PRId8 "d"
#  define PRId16 "d"
#  define PRId32 "d"
#  define PRId64 "Ld"
#  define INT8_C(c) c
#  define INT16_C(c) c
#  define INT32_C(c) c ## L
#  define INT64_C(c) c ## i64
#elif defined(__BORLANDC__) && (__BORLANDC__ < 0x600) /* Borland before 6.0 */
typedef signed char int8_t;
typedef signed short int16_t;
typedef signed long int int32_t;
typedef signed __int64 int64_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long int uint32_t;
typedef unsigned __int64 uint64_t;
#  define PRId8 "d"
#  define PRId16 "d"
#  define PRId32 "ld"
#  define PRId64 "I64Ld"
#  define INT8_C(c) c
#  define INT16_C(c) c
#  define INT32_C(c) c ## L
#  define INT64_C(c) c ## i64
#elif defined(__FreeBSD__) && (__FreeBSD__ < 5) /* FreeBSD before 5.0 */ && !defined (_SYS_INTTYPES_H_)
typedef signed char int8_t;
typedef signed short int16_t;
typedef signed long int int32_t;
typedef signed long long int int64_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long int uint32_t;
typedef unsigned long long int uint64_t;
#elif defined(__CYGWIN__) && defined(__BIT_TYPES_DEFINED__) /* Cygwin defines intxx_t in sys/types.h instead of inttypes.h */
typedef unsigned char uint8_t;
typedef __uint16_t uint16_t;
typedef __uint32_t uint32_t;
typedef __uint64_t uint64_t;
#else
#  include <inttypes.h>
#  if !defined(INT8_MAX) && defined(INT16_MAX)
/* int8_t is not mandatory */
typedef int_least8_t int8_t;
#  endif
#endif

#if !defined(PRId16)
#  define PRId8 "d"
#  define PRId16 "d"
#  define PRId32 "ld"
#  define PRId64 "lld"
#elif !defined(PRId8)
#  define PRId8 "d"
#endif
#if !defined(INT16_C)
#  define INT8_C(c) c
#  define INT16_C(c) c
#  define INT32_C(c) c ## L
#  define INT64_C(c) c ## LL
#elif !defined(INT8_C)
#  define INT8_C(c) c
#endif
#if !defined(INT16_MIN)
#  define INT8_MIN (-INT8_C(127)-1)
#  define INT8_MAX (INT8_C(127))
#  define INT16_MIN (-INT16_C(32767)-1)
#  define INT16_MAX (INT16_C(32767))
#  define INT32_MIN (-INT32_C(2147483647)-1)
#  define INT32_MAX (INT32_C(2147483647))
#  define INT64_MIN (-INT64_C(9223372036854775807)-1)
#  define INT64_MAX (INT64_C(9223372036854775807))
#elif !defined(INT8_MIN)
#  define INT8_MIN (-INT8_C(127)-1)
#endif


/*
  Endian stuff
*/
#if defined(BSD) && (BSD >= 199103)
#  include <machine/endian.h>
#elif defined(__alpha__) || defined(__alpha) || defined(_M_ALPHA)
/* bi-endian processor, current mode should be find in machine/endian.h file */
#  include <machine/endian.h>
#elif defined(linux)
#  include <endian.h>
#endif



#if !defined(BYTE_ORDER) && defined(__BYTE_ORDER)
#  define BYTE_ORDER      __BYTE_ORDER
#endif

#if !defined(LITTLE_ENDIAN) && defined(__LITTLE_ENDIAN)
#  define LITTLE_ENDIAN      __LITTLE_ENDIAN
#endif

#if !defined(BIG_ENDIAN) && defined(__BIG_ENDIAN)
#  define BIG_ENDIAN      __BIG_ENDIAN
#endif

#if !defined(LITTLE_ENDIAN)
#  define LITTLE_ENDIAN   1234    /* LSB first (vax, pc) */
#endif
#if !defined(BIG_ENDIAN)
#  define BIG_ENDIAN      4321    /* MSB first (IBM, net) */
#endif
#if !defined(PDP_ENDIAN)
#  define PDP_ENDIAN      3412    /* LSB first in word, MSW first in long */
#endif

#if !defined(BYTE_ORDER) && defined(BIT_ZERO_ON_RIGHT)
#  define BYTE_ORDER      LITTLE_ENDIAN
#elif !defined(BYTE_ORDER) && defined(BIT_ZERO_ON_LEFT)
#  define BYTE_ORDER      BIG_ENDIAN
#elif !defined(BYTE_ORDER)

/* HP RISC */
#  if defined(__hppa__) || defined(__hppa) || defined(__hp9000) || \
      defined(__hp9000s300) || defined(hp9000s300) || \
      defined(__hp9000s700) || defined(hp9000s700) || \
      defined(__hp9000s800) || defined(hp9000s800) || defined(hp9000s820)
#    define BYTE_ORDER      BIG_ENDIAN
#  endif

/* IBM */
#  if defined(ibm032) || defined(ibm370) || defined(_IBMR2)
#    define BYTE_ORDER      BIG_ENDIAN
#  endif

/* Intel x86 */
#  if defined(i386) || defined(__i386__) || defined(__i386) || \
      defined(_M_IX86) || defined(_X86_) || defined(__THW_INTEL) || \
      defined(sun386)
#    define BYTE_ORDER      LITTLE_ENDIAN
#  endif

/* Intel Itanium */
#  if defined(__ia64__) || defined(_IA64) || defined(__IA64__) || \
      defined(_M_IA64)
#    define BYTE_ORDER      LITTLE_ENDIAN
#  endif

/* Nationnal Semiconductor 32000 serie */
#  if  defined(ns32000)
#    define BYTE_ORDER      LITTLE_ENDIAN
#  endif

/* Motorola 68000 */
#  if defined(mc68000) || defined(is68k) || defined(macII) || defined(m68k)
#    define BYTE_ORDER      BIG_ENDIAN
#  endif

/* MIPS */
#  if defined(MIPSEL) || defined(_MIPSEL)
#    define BYTE_ORDER      LITTLE_ENDIAN
#  elif defined(MIPSEB) || defined(_MIPSEB)
#    define BYTE_ORDER      BIG_ENDIAN
#  elif defined(__mips__) || defined(__mips) || defined(__MIPS__)
#    error "MIPS are bi-endian processors. Endianness is unknown for this system, please drop an e-mail to SmartEiffel@loria.fr"
#  endif

/* Power PC */
/* this processor is bi-endian, how to know if little-endian is set? */
#  if defined(__powerpc) || defined(__powerpc__) || defined(__POWERPC__) || \
      defined(__ppc__) || defined(__ppc) || defined(_M_PPC) || \
      defined(__PPC) || defined(__PPC__)
#    define BYTE_ORDER      BIG_ENDIAN
#  endif

/* Pyramid 9810 */
#  if defined(pyr)
#    define BYTE_ORDER      BIG_ENDIAN
#  endif

/* RS/6000 */
#  if defined(__THW_RS6000) || defined(_IBMR2) || defined(_POWER) || \
      defined(_ARCH_PWR) || defined(_ARCH_PWR2)
#    define BYTE_ORDER      _ENDIAN
#  endif

/* SPARC */
#  if defined(__sparc__) || defined(sparc) || defined(__sparc)
#    define BYTE_ORDER      BIG_ENDIAN
#  endif

/* CCI Tahoe */
#  if defined(tahoe)
#    define BYTE_ORDER      BIG_ENDIAN
#  endif

/* VAX */
#  if defined(vax) || defined(VAX) || defined(__vax__) || defined(_vax_) || \
      defined(__vax) || defined(__VAX)
#    define BYTE_ORDER      LITTLE_ENDIAN
#  endif

/* ELATE is a virtual OS with a little endian Virtual Processor */
#  if defined(__ELATE__)
#    define BYTE_ORDER      LITTLE_ENDIAN
#  endif

/* Miscellaneous little endian */
#  if defined(wrltitan)
#    define BYTE_ORDER      LITTLE_ENDIAN
#  endif

/* Miscellaneous big endian */
#  if defined(apollo) || defined(__convex__) || defined(_CRAY) || defined(sel)
#    define BYTE_ORDER      BIG_ENDIAN
#  endif
#endif


#if !defined(BYTE_ORDER)
#  error "Unknown byte order. Add your system in above macros once you know your system type. Please drop an e-mail to SmartEiffel@loria.fr"
#endif
#if (BYTE_ORDER != BIG_ENDIAN && BYTE_ORDER != LITTLE_ENDIAN)
#  error "Only little-endian and big-endian are valid at this time. Please drop an e-mail to SmartEiffel@loria.fr"
#endif


/*
  Byte swapping stuff
*/
extern void copy_swap_16(const uint16_t *src, uint16_t *dest, int count);


/* Because ANSI C EXIT_* are not always defined: */
#ifndef EXIT_FAILURE
#  define EXIT_FAILURE 1
#endif
#ifndef EXIT_SUCCESS
#  define EXIT_SUCCESS 0
#endif

/*
   On Linux glibc systems, we need to use sig.* versions of jmp_buf,
   setjmp and longjmp to preserve the signal handling context.
   Currently, the way I figured to detect this is if _SIGSET_H_types has
   been defined in /usr/include/setjmp.h.

   NOTE: with gcc, -ansi is used for SmartEiffel generated files EXCEPT in
   -no_split mode. ANSI only recognizes the non-sig versions.
*/
#if (defined(_SIGSET_H_types) && !defined(__STRICT_ANSI__))
#  define JMP_BUF    sigjmp_buf
#  define SETJMP(x)  sigsetjmp( (x), 1)
#  define LONGJMP    siglongjmp
#else
#  define JMP_BUF    jmp_buf
#  define SETJMP(x)  setjmp( (x) )
#  define LONGJMP    longjmp
#endif

/*
   Type to store reference objects Id:
 */
typedef int Tid;
typedef struct S0 T0;
struct S0{Tid id;};

/*
   The default channel used to print runtime error messages:
*/
#define SE_ERR stderr

/*
   Eiffel type INTEGER_8 is #1:
*/
typedef int8_t T1;
#define EIF_INTEGER_8 T1
#define M1 (INT8_C(0))
#define EIF_INTEGER_8_BITS (CHAR_BIT)
#define EIF_MINIMUM_INTEGER_8 (INT8_MIN)
#define EIF_MAXIMUM_INTEGER_8 (INT8_MAX)

/*
  Eiffel type INTEGER_16 is #10:
*/
typedef int16_t T10;
#define EIF_INTEGER_16 T10
#define M10 (INT16_C(0))
#define EIF_INTEGER_16_BITS (CHAR_BIT*sizeof(T10t))
#define EIF_MINIMUM_INTEGER_16 (INT16_MIN) /*-32768*/
#define EIF_MAXIMUM_INTEGER_16 (INT16_MAX) /*+32767*/

/*
  Eiffel type INTEGER or INTEGER_32 is #2:
*/
typedef int32_t T2;
#define EIF_INTEGER T2
#define EIF_INTEGER_32 T2
#define M2 (INT32_C(0))
#define EIF_INTEGER_BITS ((T2)(CHAR_BIT*sizeof(T2)))
#define EIF_INTEGER_32_BITS EIF_INTEGER_BITS
#define EIF_MINIMUM_INTEGER (INT32_MIN)
#define EIF_MAXIMUM_INTEGER (INT32_MAX)

/*
  Eiffel type INTEGER_64 is #11:
*/
typedef int64_t T11;
#define EIF_INTEGER_64 T11
#define M11 (INT64_C(0))
#define EIF_INTEGER_64_BITS (CHAR_BIT*sizeof(T11))
#define EIF_MINIMUM_INTEGER_64 (INT64_MIN)
#define EIF_MAXIMUM_INTEGER_64 (INT64_MAX)

/*
  Eiffel type CHARACTER is #3:
*/
typedef unsigned char T3;
#define EIF_CHARACTER T3
#define M3 (0)
#define EIF_CHARACTER_BITS (CHAR_BIT)
#define EIF_MINIMUM_CHARACTER_CODE (0)
#define EIF_MAXIMUM_CHARACTER_CODE (255)
#define T3code(x) ((T10)(x))
#define T3to_integer(x) ((signed char)(x))
#define T3to_bit(x) (x)

/*
  Eiffel type REAL is #4:
*/
typedef float T4;
#define EIF_REAL T4
#define M4 (0.0)
#define EIF_REAL_BITS (CHAR_BIT*sizeof(float))
#define EIF_MINIMUM_REAL (-(FLT_MAX))
#define EIF_MAXIMUM_REAL (FLT_MAX)

/*
  Eiffel type DOUBLE is #5:
*/
typedef double T5;
#define EIF_DOUBLE T5
#define M5 (0.0)
#define EIF_DOUBLE_BITS (CHAR_BIT*sizeof(double))
#define EIF_MINIMUM_DOUBLE (-(DBL_MAX))
#define EIF_MAXIMUM_DOUBLE (DBL_MAX)

/*
  Eiffel type BOOLEAN is #6:
*/
typedef char T6;
#define EIF_BOOLEAN T6
#define M6 (0)
#define EIF_BOOLEAN_BITS (CHAR_BIT)

/*
   Eiffel type POINTER is #8:
*/
typedef void* T8;
#define EIF_POINTER T8
/* Sometimes, NULL is defined as 0 */
#define M8 ((void*)NULL)
#define EIF_POINTER_BITS (CHAR_BIT*sizeof(void*))

/*
  To use type STRING on the C side:
*/
#define EIF_STRING T7*

/*
  Some Other EIF_* defined in ETL:
*/
#define eif_access(x) ((char*)(x))
#define EIF_REFERENCE T0*
#define EIF_OBJ T0*
#define EIF_OBJECT EIF_OBJ

/*
   Wrappers for `malloc' and `calloc':
*/
void* se_malloc(size_t size);
void* se_calloc(size_t nmemb, size_t size);

/*
   Infinities
*/

#ifdef INFINITY /* ISO C99 constant */
#   define POSITIVE_INFINITY INFINITY
#else /* Fallback for infinity in non-ISO C99 compilers  */
#   define POSITIVE_INFINITY (1.0/0.0)
#endif

#define NEGATIVE_INFINITY (-POSITIVE_INFINITY)

#endif /* #ifndef _BASE_H */
extern void*eiffel_root_object;

typedef unsigned char* T9;
/* Available Eiffel routines via -cecil:
*/
void stdc_exit_switch_at_exit(void* C);
void stdc_signal_switch_switcher(void* C,T2 a1);
