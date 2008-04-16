#ifdef EIFFEL_VENDOR_ge
#define EIFFEL_VENDOR_GE
#undef EIFFEL_VENDOR_SE
#undef EIFFEL_VENDOR_VE
#undef EIFFEL_VENDOR_ISE
#else
#ifdef EIFFEL_VENDOR_se
#define EIFFEL_VENDOR_SE
#undef EIFFEL_VENDOR_VE
#undef EIFFEL_VENDOR_ISE
#undef EIFFEL_VENDOR_GE
#else
#ifdef EIFFEL_VENDOR_ise
#define EIFFEL_VENDOR_ISE
#undef EIFFEL_VENDOR_SE
#undef EIFFEL_VENDOR_VE
#undef EIFFEL_VENDOR_GE
#else
#ifdef EIFFEL_VENDOR_ve
#define EIFFEL_VENDOR_VE
#undef EIFFEL_VENDOR_SE
#undef EIFFEL_VENDOR_ISE
#undef EIFFEL_VENDOR_GE
#endif
#endif
#endif
#endif

#if ( (! defined(EIFFEL_VENDOR_SE)) && (! defined(EIFFEL_VENDOR_ISE)) && (! defined(EIFFEL_VENDOR_VE)) && (! defined(EIFFEL_VENDOR_GE)) )
#error Eiffel vendor unknown. Please define EIFFEL_VENDOR_XXX.
#endif


#if HAVE_CONFIG_H
#include <config.h>
#endif


#ifdef EIFFEL_VENDOR_GE
#include <ge_eiffel.h>
#endif


#ifdef EIFFEL_VENDOR_ISE
#ifndef eif_h
#define eif_h
#include <eif_portable.h>
#include <eif_hector.h>
#include <eif_macros.h>
#endif
#endif

#ifdef EIFFEL_VENDOR_SE
#ifdef HAVE_C_BASE_H
/* SE 1.1 or higher */
#include "sys/runtime/c/base.h"
#else
#ifdef HAVE_BASE_H
/* SE 1.0 or lower */
#include "sys/runtime/base.h"
#else
/* we don't know, guess */
#include "sys/runtime/c/base.h"
#endif
#endif
#ifndef EIF_TRUE
#define EIF_TRUE		(EIF_BOOLEAN) '\01'
#endif
#ifndef EIF_FALSE
#define EIF_FALSE		(EIF_BOOLEAN) '\0'
#endif
#endif

#ifdef EIFFEL_VENDOR_VE
#include "cecil.h"
#ifndef EIF_TRUE
#define EIF_TRUE		(EIF_BOOLEAN) '\01'
#endif
#ifndef EIF_FALSE
#define EIF_FALSE		(EIF_BOOLEAN) '\0'
#endif
#ifndef EIF_PROCEDURE
#define EIF_PROCEDURE EIF_PROC
#endif
#ifndef EIF_OBJECT
#define EIF_OBJECT EIF_REFERENCE
#endif
#ifndef NULL
#define NULL 0
#endif
#endif
